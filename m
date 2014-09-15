From: SaRaVanAn <saravanan.nagarajan87@gmail.com>
Subject: Query on "Add locking to prevent concurrent instances" patch
Date: Mon, 15 Sep 2014 18:05:35 +0530
Message-ID: <CA+86yMj=JY+x6v96wFmS8RrGuqard-kETu57fm-6VvGdvx6b5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:37685 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaIOMfm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:35:42 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so3902657wes.36
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2014 05:35:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Team,
   We are using iptables version "1.4.14". We decided to take latest
iptables version to resolve "resource temporarily unavailable"
issue.We have compiled the latest version "1.4.20-1"  and tried
installing it. It seems the latest iptables code needs glibc-2.14.

Is it possible to merge the patch alone without going for glibc
upgrade? Will it work without glibc upgrade?

Glibc upgrade is a major change for us, since it leads to many library upgrades.

Please provide your inputs on this.


Regards,
Saravanan N
