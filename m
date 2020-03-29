Return-Path: <SRS0=U5qg=5O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBD2C43331
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 14:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F312073E
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 14:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=thinline.cz header.i=@thinline.cz header.b="COrHyJw2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgC2OhN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 10:37:13 -0400
Received: from gelf9.thinline.cz ([91.239.200.179]:58131 "EHLO
        gelf9.thinline.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgC2OhM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 10:37:12 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2020 10:37:11 EDT
Received: from localhost (unknown [127.0.0.1])
        by gelf9.thinline.cz (Postfix) with ESMTP id 8488274A27
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2020 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=thinline.cz;
        s=gelf9-201906; t=1585492318;
        bh=IuqlxFhXVwRVLgSgKTXGb0PQ8OC4xo9Cqh8zMToqpow=;
        h=Date:From:To:Subject;
        b=COrHyJw260B6VzPaeSKVJCLUXzOcUPR4jZBfV//DV56IWBom3GgZgtSTy4Ga+hDZV
         pWJFM1lwYORllNeafFXQBkaHwIK6iDU/wrUScKsrpslolbayjl4bVkz+Hk07ZieVc5
         19RPbUE/zB4FMTdIA9jzuf5sbYooDgDgjqmG12By2icW0+X6fRmxKTAGbEQOEjeZTm
         xoDOos0XuFMW2o06VKBCQEoWjtXtruyjNacbWiRWlfbfKMnd6i+19xyNjJZJn9DiQu
         rG1lFwptsf1i/sTdX2w/3Hzp5EeW2ivu26X4pLCo2SbyGGmrpLTZAVloVBnXlGfHLo
         LJRk4qCErS+RA==
X-Virus-Scanned: amavisd-new at thinline.cz
Received: from gelf9.thinline.cz ([127.0.0.1])
        by localhost (gelf9.cesky-hosting.cz [127.0.0.1]) (amavisd-new, port 10025)
        with ESMTP id iojThz4qSaxh for <netfilter-devel@vger.kernel.org>;
        Sun, 29 Mar 2020 16:31:57 +0200 (CEST)
Received: from webmail2.cesky-hosting.cz (localhost [127.0.0.1])
        (Authenticated sender: jaroslav@thinline.cz)
        by gelf9.thinline.cz (Postfix) with ESMTPA
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2020 16:31:57 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 29 Mar 2020 16:31:57 +0200
From:   jaroslav@thinline.cz
To:     netfilter-devel@vger.kernel.org
Subject: Suggestion: replacement for physdev-is-bridged in nft
Message-ID: <8b6e45ba8945b226e4c95e6e9a1cf2e4@thinline.cz>
X-Sender: jaroslav@thinline.cz
User-Agent: Roundcube Webmail/1.3.10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I hope this is the correct list to post to (based on info on 
https://netfilter.org/mailinglists.html), I apologize for the noise if 
not.

I am trying to replace these iptables rules:

iptables -P FORWARD DROP
iptables -A FORWARD -m physdev --physdev-is-bridged -j ACCEPT

The machine is a VM host and has multiple bridge interfaces connecting 
the VMs into physical networks, mostly 2 (internet and internal), 
sometimes more, which are created on-demand. The host needs to be able 
to forward some traffic between networks (ie. 
sys.net.ipv4.ip_forward=1), but generally, forwarding between networks 
needs to be blocked, so setting policy to accept is not an option

I found a workaround for static bridges:

table inet filter {
   chain forward {
     type filter hook forward priority 0
     policy drop
     iifname "br0" oifname "br0" accept
     iifname "br1" oifname "br1" accept
   }
}

However, the VM host also creates bridge interfaces on-demand. The 
iptables rule above takes care of them, but by switchting to nftables I 
would need to come up with a way to add a rule corresponding to every 
interface created. It would be really convenient to have something like 
this:

table inet filter {
   chain forward {
     type filter hook forward priority 0
     policy drop
     iifname_equals_oifname accept
   }
}

As far as I know, the nftables filtering uses an in-kernel virtual 
machine and rules are compiled into a program by the nft tool. Since 
it's already possible to do comparisons with static strings, it occurred 
to me it might be possible to instruct the VM to compare both interface 
names with each other, implementing this feature without the need to do 
any changes in the kernel.

Is it possible to implement something like this in nft? Provided the 
solution is really as simple as I envisioned it.

Please CC me in replies, I am not on the list.
