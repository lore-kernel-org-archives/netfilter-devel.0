From: =?ISO-8859-1?Q?Bj=F8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: nftables and sets
Date: Wed, 22 Jan 2014 15:09:30 +0100
Message-ID: <CAJO99T=OERsyTy91n=DJSceSdfxUeQVSO5JJtpMwuPyKh6MicQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:57501 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaAVOJc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:09:32 -0500
Received: by mail-la0-f44.google.com with SMTP id hm7so354212lab.31
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2014 06:09:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is it planned (or already implemented) support for multiple value vmaps?
for example {type uid, type ipv4 : verdict}

Also, using iptables I am doing something like this

-A INPUT -j BLOCK
-A BLOCK -m set --match-set ignorelist src -j RETURN
-A BLOCK -m set --match-set blocklist src -j DROP

..to make sure ips listed in ignorelist does not get blocked..

How would I do the same using nft?

-- 
Bj(/)rnar
