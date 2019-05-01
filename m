Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF6CC43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 10:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1D1021670
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 10:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=isbnet.com header.i=@isbnet.com header.b="qO+tAzC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfEAKZR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 06:25:17 -0400
Received: from mail.isbnet.com ([173.212.235.232]:42058 "EHLO isbnet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfEAKZR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 06:25:17 -0400
X-Greylist: delayed 3549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2019 06:25:16 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=isbnet.com;
         s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:To:Subject:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZuvOq1JNKWsebSYLviX/KHPdPT3hKLhVbfUkDN4Lvio=; b=qO+tAzC7rQWr6DnJnJzl0hcJmk
        wsphl9ubMMtNp18V/zT+Jq6HiPsivLjQwgGWpt70jMpabrI5/Q76JQFXgl6a+Bgml+6XkjsePm1F9
        u9wR9ZMHDNfw0RsqZEKgkqtkj27mSzQgclTBF2ghZxfHqSi6sFEMUUY9qPDlYyTVcdyM=;
Received: from [92.116.105.35] (helo=[192.168.178.21])
        by isbnet.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <patrickbln@isbnet.com>)
        id 1hLlV8-0004R7-B3
        for netfilter-devel@vger.kernel.org; Wed, 01 May 2019 11:26:06 +0200
From:   Patrick Adam <patrickbln@isbnet.com>
Subject: Debian 9 vs Xtables-addons 3.3 and GeoLite2
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <e2c079aa-afa1-6945-1ff4-acff149114a5@isbnet.com>
Date:   Wed, 1 May 2019 11:26:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-CA
X-AVK-Virus-Check: AVA 25.21726;619CF20B
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I hope I am not fully wrong here.

I am on Debian 9.9 with kernel v 4.9.0-9. I have been using 
Xtables-addons 2.12+geoip to block some countries via iptables.

This doesn't work anymore since GeoLite2 came.

I took xt_geoip_dl & xt_geoip_build from the current version 3.2. Since 
the generated files from CSVs won't be put in BE & LE folders anymore 
and I read here "Philip Prindeville: This allows a single database to be 
built and distributed as a package that is accepted by both big- and 
little-endian hosts." I copied them to BE & LE folders hoping it would 
work. Well, it didn't.

I saw lots of messages with patches... but I am missing the step 
explaining how to adapt my installation on Debian Strech.

As per the minimum requirements of the current version of Xtables-addons 
kernel >= 4.15 is needed. Is there any way to get current version of 
Xtables-addons working on Debian Strech as its current kernel is of 
version 4.9.0-9 ?

Thank you very much in advance for your support !

Sunny regards,

Patrick

