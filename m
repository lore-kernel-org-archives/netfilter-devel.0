From: Jan Engelhardt <jengelh@medozas.de>
Subject: Targets with "mangle" table limiting (Was: Re: Troubles with MARK
 target in 2.6.28)
Date: Thu, 15 Jan 2009 09:06:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net>
 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZAOIGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:06:07 -0500
In-Reply-To: <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-14 06:39, Jan Engelhardt wrote:
>parent cc46eb3e855b7c1f628e934e01b97f4f2642973e (v2.6.29-rc1-22-gcc46eb3)
>commit 11d60b1b555097e613ad6548b9b695a19735dda1
>Author: Jan Engelhardt <jengelh@medozas.de>
>Date:   Wed Jan 14 06:36:10 2009 +0100
>
>netfilter: proc file for extension overview
>
>Add a procfs file that dumps out the full Xtables target, match and
>table info for all known nfprotos, superseding the IPv4/v6-only
>/proc/net/ip{,6}_tables* which only provide names.

With this patch of mine I was able to identify a small discrepancy
(/proc/net/ip* would not have told me as it just prints names):

># -- Targets --
># type	Name         	rev	table	nfproto	l4proto	hooks	tgsize
>target	MARK           	2	*	*	*	*	     8
>target	MARK           	1	mangle	*	*	*	     8
>target	MARK           	0	mangle	*	*	*	     4

Namely that MARK.2 is available for all tables. It looks like an error,
given that the previous ones were all limited to the mangle table.
But, I would have to ask - what do we gain from limiting it to mangle?
All other *MARK targets are available for all tables too, so what was
the original reason for the table limit?

I could imagine it having to do with routing (nfmark can be used as
a routing key, as can TOS/DSCP):

>target	TOS            	1	mangle	IPv4	*	*	     2
>target	TOS            	0	mangle	IPv4	*	*	     1
>target	DSCP           	0	mangle	IPv4	*	*	     1

then again, MARK has more uses than just for routing; it can, for example,
serve as a way to reduce the number of rules by remembering some previous
result.
What do others think?
