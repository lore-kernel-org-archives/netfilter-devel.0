From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Fix make/compile error for iptables-1.4.0rc1
Date: Fri, 23 Nov 2007 17:38:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711231738200.8042@fbirervta.pbzchgretzou.qr>
References: <1195245146.15945.50.camel@localhost.localdomain>
 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
 <1195390182.15945.57.camel@localhost.localdomain>
 <1195395787.15945.77.camel@localhost.localdomain>
 <1195600242.1228.7.camel@localhost.localdomain>  <4743E403.8090408@trash.net>
  <1195673456.1228.14.camel@localhost.localdomain>  <47455A68.3030309@trash.net>
  <1195828201.3866.20.camel@localhost.localdomain> <1195834612.3866.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, yasuyuki@netfilter.org,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <jdb@comx.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37027 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbXKWQjA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:39:00 -0500
In-Reply-To: <1195834612.3866.42.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 23 2007 17:16, Jesper Dangaard Brouer wrote:
>
>Commit text:
>------------
>Fixing a make/compile issue with iptables, release candidate 1.4.0rc1,
>which has existed since SVN changeset 6920.  This patch adds ip_tables.h
>and ip6_tables.h, and updates x_tables.h, taken from Linus'es git tree.
                                                            ^
-e

>Remember we now need to keep these include files in sync with kernel.

Not only them, but all .h files in include/linux/ :-/
