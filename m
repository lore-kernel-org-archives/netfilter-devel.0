From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] NETFILTER:  Remove superfluous __KERNEL__ tests from
 unexported headers.
Date: Thu, 03 Apr 2008 17:09:56 +0200
Message-ID: <47F4F344.602@trash.net>
References: <alpine.LFD.1.00.0804020946430.18913@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37614 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbYDCPKA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:10:00 -0400
In-Reply-To: <alpine.LFD.1.00.0804020946430.18913@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>  include/linux/netfilter/nf_conntrack_h323.h      |    4 ----
>  include/linux/netfilter/nf_conntrack_irc.h       |    3 ---
>  include/linux/netfilter/nf_conntrack_pptp.h      |    3 ---
>  include/linux/netfilter/nf_conntrack_proto_gre.h |    2 --
>  include/linux/netfilter/nf_conntrack_sane.h      |    4 ----
>  include/linux/netfilter/nf_conntrack_sip.h       |    2 --
>  6 files changed, 18 deletions(-)


Parts of almost all of these files will be exported at
some point for ctnetlink, so for now I prefer to keep the
__KERNEL__ guards.
