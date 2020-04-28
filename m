Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99405C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 13:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF91E206B9
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 13:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="Zfda5Itg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgD1Ny6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgD1Ny6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 09:54:58 -0400
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Apr 2020 06:54:58 PDT
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6BDC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 06:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588082096;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:Subject:To:From:Date:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=jKx3r4OriyMc93JVge4Bi/EtNMyYTK9+aBUxgmJpbB4=;
        b=Zfda5ItgJx/vN8Ic6yM6g6nmEe2pcGI0PUPMqePQWYBHk3X4MQE84SgrC1OqsP9G4w
        kWH8KwZAlc5c9gp2xm+/bsAMj0YrUqI8krkQ/tsPrwCYz8d5/Xyo3WNYR8EexiZgOHNU
        NCMMXry+Bzeo4+85RsYkt8aXF6wbKd7/0dMWNj0eIURQ6+LGTIPy9sPH9IT857d1Zd2f
        RC58+J4IJm02sBMpOLV3bpmfz3X/WPGIeYOAocYqiMfteLRFZ3x5q1mbAUcaKzzYAEf+
        Uw/9DYMaKHOuplFFcr39kPWgLxD7qBwzOobiS4PdasEOZA45e5TpRaCtYCzMjEf9tyP+
        NrJQ==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4vkpMyVs8OZgL8DEz3ffJ2LRkSjMXbyt5AaWA=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id g05fffw3SDpsVSo
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate)
        for <netfilter-devel@vger.kernel.org>;
        Tue, 28 Apr 2020 15:51:54 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 1CDAD154144
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:51:54 +0200 (CEST)
Received: from wXUsowys0Snr34D3AhM8cUGOFUs2mI2RBWq9d6HKDLMy1ksj58safQ==
 (hbqTNT0Fgmmuli8fTm36B14TDMxM8wlq)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Tue, 28 Apr 2020 15:51:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Apr 2020 15:51:46 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Subject: Issues with nft typeof
User-Agent: Roundcube Webmail/1.4.2
Message-ID: <adfe176a20d9b4f9f93ed7e783309ee9@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I've been playing around with typeof support (on 2885cf2e on 5.4 kernel) 
and came across the following issues:

> nft add table bridge t
> nft set bridge t s3 '{typeof meta ibrpvid; elements = { 2, 3, 103 }; }'
> nft list ruleset

On an embedded system (openwrt on ppc) with kernel 5.4, this results in

table bridge t {
         set s3 {
                 typeof meta ibrpvid
                 elements = { 2, 3, 103 }
         }
}

But on buster-backports kernel 5.4 (x86_64), this results in

table bridge t {
         set s3 {
                 typeof meta ibrpvid
                 elements = { 512, 768, 26368 }
         }
}

Which is strange and not correct. It also happens with v0.9.4.
Debug output on x86_64 Machine:

> nft --debug=netlink set bridge t s3 '{typeof meta ibrpvid; elements = { 
> 2, 3, 103 }; }'
(null) (null) 0
s3 t 0
         element 00000200  : 0 [end]     element 00000300  : 0 [end]     
element 00006700  : 0 [end]

Debug output on openwrt machine (ppc):

> nft --debug=netlink set bridge t s3 '{typeof meta ibrpvid; elements = { 
> 2, 3, 103 }; }'
(null) (null) 0
s3 t 0
         element 00020000  : 0 [end]     element 00030000  : 0 [end]     
element 00670000  : 0 [end]

So it looks like an endianess issue to me.
The nft set bridge output looks the same when using vlan id instead of 
meta ibrvpid.
But nft list ruleset creates the correct output for vlan but not for 
meta ibrpvid.

x86_64 machine:

table bridge t {
         set s3 {
                 typeof meta ibrpvid
                 elements = { 512, 768, 26368 }
         }

         set s4 {
                 typeof vlan id
                 elements = { 2, 3, 103 }
         }
}

OpenWRT machine (ppc):

table bridge t {
         set s3 {
                 typeof meta ibrpvid
                 elements = { 2, 3, 103 }
         }

         set s4 {
                 typeof vlan id
                 elements = { 2, 3, 103 }
         }
}

So I'm unsure if this is a display error when reading back? Or is the 
wrong value written to the kernel?

> nft add chain bridge t c3
> nft add rule bridge t c3 'meta ibrpvid @s3 accept;'
> nft set bridge t s4 '{typeof vlan id . ip daddr; }'
Error: can not use variable sized data types (integer) in concat 
expressions
set bridge t s4 {typeof vlan id . ip daddr; }

So while "typeof vlan id" and typeof with concatenations works, using 
both concatenation and vlan id does not.

Any hints here to start?

Regards,
Michael
