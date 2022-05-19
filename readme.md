# CodeM Crafting

Beautiful Crafting System for ESX and QBcore

[Preview](https://streamable.com/ii9wao)
 
```sql
 CREATE TABLE IF NOT EXISTS `codem_craft` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) DEFAULT NULL,
    `weaponname` varchar(50) DEFAULT NULL,
    `weapontime` varchar(50) DEFAULT NULL,
    `weaponlabel` varchar(50) DEFAULT NULL,
    `itemtime` varchar(50) DEFAULT NULL,
    `images` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4;





ALTER TABLE `users`
ADD COLUMN `crafttxp` INT NULL DEFAULT 0 ;
```
