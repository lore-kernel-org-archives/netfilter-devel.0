From: Jan Engelhardt <jengelh@inai.de>
Subject: Release of nftables-plus 0.099
Date: Tue, 21 Jan 2014 00:38:41 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401202336140.22927@nerf08.vanv.qr>
References: <20140120131132.GA32427@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>,
	announce@lists.netfilter.org,
	Linux Networking Developer Mailing List
	<netdev@vger.kernel.org>, coreteam@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43342 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaATXin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:38:43 -0500
In-Reply-To: <20140120131132.GA32427@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


My lone self presents:

	nftables-plus 0.099


Overview
========

A package that is based upon nftables and adds usability patches.


Status
======

In this first addon release, the build system was converted to automake 
to give distributions a better build experience.


Naming
======

	What's in a name?


Resources
=========

nftables-plus is obtainable from

http://xtables.de/
git://git.xtables.de/nftables-plus

The same build requirements as plain nftables apply. Apparently 
minus lex and bison, which have become optional.

The code appears now.
