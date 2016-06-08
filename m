From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/4] netfilter: xt_TRACE: add explicitly
 nf_logger_find_get call
Date: Wed, 8 Jun 2016 15:00:51 +0200
Message-ID: <20160608130051.GB29699@breakpoint.cc>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
 <1465389800-27842-4-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59382 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbcFHNBA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 09:01:00 -0400
Content-Disposition: inline
In-Reply-To: <1465389800-27842-4-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Consider such situation, if nf_log_ipv4 kernel module is not installed,
> and the user add a following iptables rule:
>   # iptables -t raw -I PREROUTING -j TRACE
> 
> There will be no trace log generated until the user install nf_log_ipv4
> module manully.

Right, this is a constant source of confusion.

Acked-by: Florian Westphal <fw@strlen.de>
