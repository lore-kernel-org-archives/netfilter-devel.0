From: "Kaloyan Kovachev" <kkovachev@varna.net>
Subject: Re: new target or new option
Date: Mon, 1 Oct 2007 09:52:07 +0300
Message-ID: <20071001065043.M57079@varna.net>
References: <20070928170244.M71172@varna.net> <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=windows-1251
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.Varna.Net ([217.145.80.1]:60085 "EHLO ns.varna.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXJAGwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:52:18 -0400
In-Reply-To: <Pine.LNX.4.64.0709281935540.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 Sep 2007 19:36:15 +0200 (CEST), Jan Engelhardt wrote
> On Sep 28 2007 20:06, Kaloyan Kovachev wrote:
> >Hello,
> > i need to mark the connection with the realm number, but it seems there is no
> >'easy way' and there should be separate rule for each realm.
> >
> > Are there any plans to add this functionality and which is the preferable way
> >to go:
> >   1) create new REALMCONNMARK target with and/or mask
> 
> Yeah, since there is already an xt_realm, a xt_REALM would be
> the logical counterpart.

xt_REALM seams a logical name for changing the realm, not for marking the
packet or connection

> 
> >   2) extend the current CONNMARK by adding --realm-mark in addition to
--set-mark
> >
> > I think the second one will be easier and can be done in iptables extension
> >only without touching the kernel source right?

