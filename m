From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 0/2] Add/Remove spaces
Date: Sat,  1 Apr 2017 09:58:25 +0530
Message-ID: <20170401042827.30500-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35858 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdDAE2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 00:28:35 -0400
Received: by mail-pf0-f195.google.com with SMTP id r137so3120457pfr.3
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 21:28:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add and remove spaces to follow kernel coding style.

Arushi Singhal (2):
  iio: adc: replace comma with a semicolon
  staging: iio: meter: Replace mlock with driver private buf_lock

 drivers/iio/adc/max11100.c          | 4 ++--
 drivers/staging/iio/meter/ade7759.c | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.11.0

