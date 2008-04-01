From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 07/29] [NETFILTER]: remove arpt_table indirection macro
Date: Tue, 1 Apr 2008 17:26:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804011719160.13835@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <d77e5bacf4b9bb4fcc89fd261529a31c7c5002b2.1206469820.git.jengelh@computergmbh.de> <47EAB39C.3050004@trash.net> <alpine.LNX.1.10.0803270216480.22661@fbirervta.pbzchgretzou.qr>
 <47F233C9.7090509@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41342 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbYDAP0U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:26:20 -0400
In-Reply-To: <47F233C9.7090509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-01 15:08, Patrick McHardy wrote:
>
> Does not apply on top of 7/29:
>
That is strange, I used  git checkout -b arpfixup d77e5bac
to create it, and verifying it with doing the same and
git-apply arpfixup.diff comes out without any rejects.
The tree is even based on yours.

    ...
    49de6a3... [NETFILTER]: remove ARPT_{STANDARD,ERROR}_TARGET indirection macro
    9091e49... [NETFILTER]: remove arpt_target indirection macro
-> d77e5ba... [NETFILTER]: remove arpt_table indirection macro
    af437bf... [NETFILTER]: Use unsigned types for hooknum and pf vars
    28d915e... [NETFILTER]: annotate rest of nf_nat_* with const
    ff0e677... [NETFILTER]: annotate rest of nf_conntrack_* with const
    38d2cb1... [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
    4a129f3... [NETFILTER]: annotate xtables targets with const and remove casts
    720350a... [NETFILTER]: xt_sctp: simplify xt_sctp.h
    5ada5a1... [NETFILTER]: nf_conntrack_sip: update copyright
    ...

> patching file net/ipv4/netfilter/arp_tables.c
> Hunk #1 FAILED at 737.
> Hunk #2 FAILED at 1555.
> Hunk #3 FAILED at 1593.
> 3 out of 3 hunks FAILED -- saving rejects to file 
> net/ipv4/netfilter/arp_tables.c.rej
>
