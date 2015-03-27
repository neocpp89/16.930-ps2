function [Cp] = calculatePressureCoefficientFromVel(vel)
    Cp(:,:) = 1.0 - (vel(:,1,:).^2 + vel(:,2,:).^2);
end
