From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 20:56:07 +0100
Message-ID: <20130319195607.GL7938@breakpoint.cc>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141605.158831637@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34396 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab3CST4I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:56:08 -0400
Content-Disposition: inline
In-Reply-To: <20130319141605.158831637@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

holger@eitzenberger.org <holger@eitzenberger.org> wrote:
> +struct xt_NFQ_info_v3 {
> +	__u16 queuenum;
> +	__u16 queues_total;
> +	__u16 bypass;
> +	__u16 flags;
> +#define NFQ_FLAG_CPU_FANOUT		0x01 /* use current CPU (no hashing) */
> +};

minor nit:
'bypass' could be folded into 'flags' via a '#define NFQ_FLAG_BYPASS'.
