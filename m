From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/2] iio: adc: replace comma with a semicolon
Date: Sat,  1 Apr 2017 09:58:26 +0530
Message-ID: <20170401042827.30500-2-arushisinghal19971997@gmail.com>
References: <20170401042827.30500-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33911 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdDAE2s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 00:28:48 -0400
Received: by mail-pf0-f194.google.com with SMTP id o126so3122730pfb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 21:28:47 -0700 (PDT)
In-Reply-To: <20170401042827.30500-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace a comma between expression statements by a semicolon. This
changes the semantics of the code, but given the current indentation
appears to be what is intended.
A simplified version of the Coccinelle semantic patch that performs this
transformation is as follows:

// <smpl>
@r@
expression e1,e2;
@@

 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/iio/adc/max11100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/max11100.c b/drivers/iio/adc/max11100.c
index 23c060e1b663..1180bcc22ff1 100644
--- a/drivers/iio/adc/max11100.c
+++ b/drivers/iio/adc/max11100.c
@@ -124,8 +124,8 @@ static int max11100_probe(struct spi_device *spi)
 	indio_dev->name = "max11100";
 	indio_dev->info = &max11100_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-	indio_dev->channels = max11100_channels,
-	indio_dev->num_channels = ARRAY_SIZE(max11100_channels),
+	indio_dev->channels = max11100_channels;
+	indio_dev->num_channels = ARRAY_SIZE(max11100_channels);
 
 	state->vref_reg = devm_regulator_get(&spi->dev, "vref");
 	if (IS_ERR(state->vref_reg))
-- 
2.11.0

