From: Patrick McHardy <kaber@trash.net>
Subject: Re: Guided option parser run 8
Date: Mon, 23 May 2011 15:23:19 +0200
Message-ID: <4DDA5FC7.4080006@trash.net>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33945 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1EWNYG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 09:24:06 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13.05.2011 02:47, Jan Engelhardt wrote:
> The following changes since commit 59ce5bd1d05225911051a4c46ce5ccdd7c1ed078:
> 
>   Merge branch 'floating/opts' of git://dev.medozas.de/iptables (2011-05-12 11:11:51 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (12):
>       src: replace old IP*T_ALIGN macros
>       src: combine default_command functions
>       libxt_policy: option table fixes, improved error tracking
>       libxtables: avoid running into .also checks when option not used
>       libxt_policy: use XTTYPE_PROTOCOL type
>       libxtables: collapse double protocol parsing
>       libipt_[SD]NAT: flag up module name on error
>       libipt_[SD]NAT: avoid false error about multiple destinations specified
>       libxt_conntrack: correct printed module name
>       libxt_conntrack: fix assignment to wrong member
>       libxt_conntrack: resolve erroneous rev-2 port range message
>       libip6t_rt: rt-0-not-strict should take no arg

Pulled, thanks Jan.
