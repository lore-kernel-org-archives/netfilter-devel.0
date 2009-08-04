From: Patrick McHardy <kaber@trash.net>
Subject: Re: Xtables2 snapshot 20090804
Date: Tue, 04 Aug 2009 14:47:36 +0200
Message-ID: <4A782DE8.90300@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40634 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbZHDMrh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:47:37 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> here is my prospected patch queue for 2.6.32. The important changes
> are the start of a patch-wise overhaul of the firewall(s), eventually
> leading to what I would bless as Xtables2 - a logical continuation of
> the x_tables consolidation work done by Patrick McHardy et al in
> 2006/2007. (Of course it does not yet have everything I wanted, so
> it's not a final v2. But it is usable.)
> 
> The internal structure of the ruleset is switched from the serialized
> blob format (concatenated packed structs) to linked lists. Whereas
> classic iptables always exchanges complete tables with the kernel
> even if you just add a single rule from userspace, the linked-list
> preparatory spadework allows the manipulation of single rules in the
> future. Currently, only table-granularity swapping is supported;
> appropriate RCU for chains and rules is absent at this time.
> 
> iptables compatibility is retained by means of a translation layer.
> ip_tables has shown itself to be very forkable, leading to 4 firewall
> subimplementations, supporting 7 data formats. The new translation
> layer was written in a template fashion (hopefully not too ugly),
> consolidating most of ip_tables, ip6_tables, arp_tables and their
> compat variants, leading to a drop of LOC by ~50%. Ebtables has not
> been touched yet.
> 
> 
> It can be retrieved from
> 
> 	git://dev.medozas.de/linux  xt2-20090804
> 
>  181 files changed, 4060 insertions(+), 8823 deletions(-)

I suggest you begin by submitting the removal patches of old
revisions in a first series, then we can continue on with
cleanups and finally discuss your proposed functional changes.
But this is just too big to reasonably review in one go.
Thanks.

