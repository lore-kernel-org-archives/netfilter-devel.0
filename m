From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Project proposal/idea: Categorize traffic by behavior
Date: Sun, 25 Nov 2007 00:39:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711250034540.3883@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711242340570.6487@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: lartc@mailman.ds9a.nl,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59707 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXKXXjD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:39:03 -0500
In-Reply-To: <Pine.LNX.4.64.0711242340570.6487@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 24 2007 23:52, Jesper Dangaard Brouer wrote:
>
> Back in 2003/2004 when finding the topic for my masters thesis, I had a
> secondary project idea, perhaps its about time to do something about the idea,
> and hear if anyone else thinks its a good idea?
>
> The basic idea is to: "Categorize traffic by behavior"
>
A behavior-analyzing project is http://jengelh.hopto.org/p/chaostables/ which
uses TCP initialization behavior observation to figure out netscans and a small
L7 length check to detect version banner grabs (think smtp, ssh).

>
> I propose this could be implemented with Netfilter target modules for
> categorizing traffic, and using conntrack flows for saving the group/type, that
> other rules can match upon.
>
As usual, "patches welcome" ;-)
