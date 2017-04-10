ggplot(data = cid2013, aes(x = x_coordinate, y = y_coordinate)) +
  geom_point(size = 0.1, alpha = 0.1) +
  coord_cartesian(xlim = c(7600000, 7700000), ylim = c(650000, 730000))
