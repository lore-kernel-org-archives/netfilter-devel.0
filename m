From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [xtables-addons][PATCH 0/2] Compatibility fixes for linux 4.14 and 4.15
Date: Thu,  4 Jan 2018 15:50:48 -0200
Message-ID: <1515088250-32295-1-git-send-email-marcelo.cerri@canonical.com>
Cc: jengelh@inai.de,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58321 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbeADRvI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jan 2018 12:51:08 -0500
Received: from mail-qk0-f198.google.com ([209.85.220.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1eX9fX-0005vn-KD
        for netfilter-devel@vger.kernel.org; Thu, 04 Jan 2018 17:51:07 +0000
Received: by mail-qk0-f198.google.com with SMTP id a22so1526619qkc.9
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jan 2018 09:51:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches fix the build against 4.14 and 4.15 kernels.

Marcelo Henrique Cerri (1):
  build: support for Linux 4.15

Seth Forshee (1):
  build: support for Linux 4.14

 extensions/compat_xtables.h   |  4 ++++
 extensions/pknock/xt_pknock.c | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.7.4

