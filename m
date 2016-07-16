From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] extensions: libxt_connlabel: fix crash when
 connlabel.conf is empty
Date: Sat, 16 Jul 2016 13:47:39 +0200
Message-ID: <20160716114739.GA16259@breakpoint.cc>
References: <1468669193-28298-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49130 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbcGPLsC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 07:48:02 -0400
Content-Disposition: inline
In-Reply-To: <1468669193-28298-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> When connlabel.conf is empty, nfct_labelmap_new will return NULL and
> set errno to 0. So we will miss to check this situation, and cause NULL
> deference in nfct_labelmap_get_bit.
> 
> Input the following commands will reproduce this crash:
>   # echo > /etc/xtables/connlabel.conf
>   # iptables -A INPUT -m connlabel --label abc
>   Segmentation fault (core dumped)

Applied, thanks!
