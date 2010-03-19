From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 16:04:45 +0100
Message-ID: <201003191604.45719.thomas.jarosch@intra2net.com>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <4B83DF52.5000806@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Tim Gardner <timg@tpi.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:43728 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0CSPR7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:17:59 -0400
In-Reply-To: <4B83DF52.5000806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday, 23. February 2010 14:59:46 Patrick McHardy wrote:
> Tim Gardner wrote:
> >>From 146111514a8c126268e848e45b7dd967329b072f Mon Sep 17 00:00:00 2001
> >>
> > From: Tim Gardner <tim.gardner@canonical.com>
> > Date: Thu, 18 Feb 2010 20:33:00 -0700
> > Subject: [PATCH] xt_recent: Fix false match.
> > 
> > A rule with a zero hit_count will always match.
> 
> Also applied, thanks Tim.

I just updated from kernel 2.6.32.9 to kernel 2.6.32.10 which contains
the xt_recent "zero hit_count will always match" fix.

After that xt_recent stopped working for this scenario:

iptables -A INPUT -m recent --rcheck --rdest --name INET_IP -j LOG
echo "+1.2.3.4" >/proc/net/xt_recent/INET_IP

The ip address 1.2.3.4 represents the current ip of my dial up connection.

If I change "--rcheck" to "--update", it works again.
Reverting the patch fixes the issue.

Maybe this is related to the xt_recent
proc interface creating the entry
(with a zero hit count)?

Cheers,
Thomas
