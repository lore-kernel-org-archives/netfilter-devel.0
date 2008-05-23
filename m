From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Fri, 23 May 2008 14:47:26 +0200
Message-ID: <1211546846.32088.8.camel@enterprise.ims-firmen.de>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de>
	 <4835C6F0.5080604@trash.net> <00d501c8bccb$d7922000$86b66000$@com>
	 <4836B562.6000302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:35434 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYEWMr2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 08:47:28 -0400
In-Reply-To: <4836B562.6000302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2008-05-23 at 14:15 +0200, Patrick McHardy wrote:
> Basically, you'd change (in ipt_do_table):
> 
>                                  int newpos = t->verdict; 
> 
> 
> to get the new position from the target module. This probably
> requires to change the target function signature. Alternatively
> you could try to encode it in the verdict. Loop detection
> needs some way to get all possible jumps from the target
> and check each possible path. Maybe the easiest way is probably
> a target built into ip_tables.c

Out of curiosity, if Nishit would actually do it (@Nishit: if you do,
maybe we could work together on this?) but there are really major
changes afoot for netfilter during the course of this year, wouldn't
those changes make such an extension obsolete and/or pretty
difficult to port to the new netfilter?




