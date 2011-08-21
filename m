From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fixes to iptables-1.4.12
Date: Sun, 21 Aug 2011 11:31:19 +0200
Message-ID: <4E50D067.3030102@trash.net>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38701 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1HUJbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 05:31:24 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.08.2011 21:24, Jan Engelhardt wrote:
> The following changes since commit 91ca4603f649a9b9fed4f2e31a8c005cdbdacd1e:
> 
>   Merge branch 'master' of git://dev.medozas.de/iptables (2011-08-09 13:23:17 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Bernard Massot (1):
>       doc: fix typo in libxt_TRACE
> 
> Dwight Davis (1):
>       libxt_string: fix space around arguments
> 
> Jan Engelhardt (4):
>       libxt_u32: fix missing allowance for inversion
>       libxt_set: update man page about kernel support on the feature
>       libxt_tcp: always print the mask parts
>       libxt_set: put differing variable names in directly
> 

Pulled, thanks Jan.
