From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 2/2] staging: iio: meter: Replace mlock with driver private buf_lock
Date: Sat,  1 Apr 2017 09:58:27 +0530
Message-ID: <20170401042827.30500-3-arushisinghal19971997@gmail.com>
References: <20170401042827.30500-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32883 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdDAE2w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 00:28:52 -0400
Received: by mail-pg0-f65.google.com with SMTP id 79so21140236pgf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 21:28:52 -0700 (PDT)
In-Reply-To: <20170401042827.30500-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The driver needs to insure atomicity during frequency
changes of bus and device. The iiodev->mlock as used
was not doing that. Replace it with the drivers existing
buffer lock and execute spi_write directly.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/iio/meter/ade7759.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
index 0b65f1847510..a5ee4501d30a 100644
--- a/drivers/staging/iio/meter/ade7759.c
+++ b/drivers/staging/iio/meter/ade7759.c
@@ -429,7 +429,7 @@ static ssize_t ade7759_write_frequency(struct device *dev,
 	if (!val)
 		return -EINVAL;
 
-	mutex_lock(&indio_dev->mlock);
+	mutex_lock(&st->buf_lock);
 
 	t = 27900 / val;
 	if (t > 0)
@@ -447,10 +447,13 @@ static ssize_t ade7759_write_frequency(struct device *dev,
 	reg &= ~(3 << 13);
 	reg |= t << 13;
 
-	ret = ade7759_spi_write_reg_16(dev, ADE7759_MODE, reg);
+	st->tx[0] = ADE7759_WRITE_REG(ADE7759_MODE);
+	st->tx[1] = reg;
+
+	ret = spi_write(st->us, st->tx, 2);
 
 out:
-	mutex_unlock(&indio_dev->mlock);
+	mutex_unlock(&st->buf_lock);
 
 	return ret ? ret : len;
 }
-- 
2.11.0

