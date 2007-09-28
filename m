From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: new target or new option
Date: Fri, 28 Sep 2007 19:36:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr>
References: <20070928170244.M71172@varna.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kaloyan Kovachev <kkovachev@varna.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42540 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbXI1RgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:36:16 -0400
In-Reply-To: <20070928170244.M71172@varna.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 28 2007 20:06, Kaloyan Kovachev wrote:
>Hello,
> i need to mark the connection with the realm number, but it seems there is no
>'easy way' and there should be separate rule for each realm.
>
> Are there any plans to add this functionality and which is the preferable way
>to go:
>   1) create new REALMCONNMARK target with and/or mask

Yeah, since there is already an xt_realm, a xt_REALM would be
the logical counterpart.

>   2) extend the current CONNMARK by adding --realm-mark in addition to --set-mark
>
> I think the second one will be easier and can be done in iptables extension
>only without touching the kernel source right?
