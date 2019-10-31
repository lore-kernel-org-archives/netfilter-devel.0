Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779FCCA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 18:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A902086D
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 18:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="gU/F817j";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="gU/F817j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfJaS6A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 14:58:00 -0400
Received: from mail1.tootai.net ([213.239.227.108]:37718 "EHLO
        mail1.tootai.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbfJaS6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 14:58:00 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 14:57:59 EDT
Received: from mail1.tootai.net (localhost [127.0.0.1])
        by mail1.tootai.net (Postfix) with ESMTP id 48213603F26B
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 19:48:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1572547696; bh=eXOPXFG5LFARtIdeOnoZnlhxuSnWEFAv9Xq8dzp72cA=;
        h=To:From:Subject:Date:From;
        b=gU/F817jb2Z9VcKBbqFBSp2SUtcB1JmjtvPy7Rg2/ENPUrWVTBeMxfxPkel1zq2R2
         Sl3DbsLT1GtILiEFgl5lYwSagH4VRQvDAkuRpd/CCDUyHrSymYdAM4jbGzTtd+2D5q
         oY7cE5lw5r/gVot4oybfbiyqZ8fMapnbKa/VSJGc=
Received: from [192.168.10.4] (unknown [192.168.10.4])
        by mail1.tootai.net (Postfix) with ESMTPSA id 0F7D7603F11A
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 19:48:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1572547696; bh=eXOPXFG5LFARtIdeOnoZnlhxuSnWEFAv9Xq8dzp72cA=;
        h=To:From:Subject:Date:From;
        b=gU/F817jb2Z9VcKBbqFBSp2SUtcB1JmjtvPy7Rg2/ENPUrWVTBeMxfxPkel1zq2R2
         Sl3DbsLT1GtILiEFgl5lYwSagH4VRQvDAkuRpd/CCDUyHrSymYdAM4jbGzTtd+2D5q
         oY7cE5lw5r/gVot4oybfbiyqZ8fMapnbKa/VSJGc=
To:     Netfilter list <netfilter-devel@vger.kernel.org>
From:   Daniel Huhardeaux <tech@tootai.net>
Subject: Nat redirect using map
Message-ID: <6ea6ecb5-99c5-5519-b689-8e1291df69cc@tootai.net>
Date:   Thu, 31 Oct 2019 19:48:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have a map like this

map redirect_tcp {
                 type inet_service : inet_service
                 flags interval
                 elements = { 12345 : 12345, 36025 : smtp }
         }

and want to use nat redirect but it fail with unexpecting to, expecting 
EOF or semicolon. Here is the rule

nft add rule ip nat prerouting iif eth0 tcp dport map @redirect_tcp 
redirect to @redirect_tcp

How can I get this working ?

Other: when using dnat for forwarding, should I take care of forward rules ?

Example for this kind of rule from wiki:

nft add rule nat prerouting iif eth0 tcp dport { 80, 443 } dnat 
192.168.1.120

Thanks for any hint
-- 
TOOTAi Networks
