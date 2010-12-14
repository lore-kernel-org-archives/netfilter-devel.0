From: "Luke-Jr" <luke@dashjr.org>
Subject: 6to4/Teredo IPv4 matching
Date: Tue, 14 Dec 2010 09:40:07 -0500
Message-ID: <201012140940.11119.luke@dashjr.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([173.242.112.54]:36638 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0LNOss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:48:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Are there any plans to allow matching 6to4/Teredo IPv6 packets against IPv4 
rules (or at least ipsets)? Recently I have a server that's been under 
constant DDoS from China, and I found that when I use ipsets to drop 
everything from China, some continue to hammer my server over 6to4 and/or 
Teredo. So I just figured I'd throw the idea out there in case it hasn't 
occurred to anyone yet. ;)
