From: Florian Westphal <fw@strlen.de>
Subject: Re: nfnetlink_queue question
Date: Wed, 10 Jul 2013 08:26:40 +0200
Message-ID: <20130710062640.GC30208@breakpoint.cc>
References: <20130709224013.GA22816@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38381 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab3GJG0m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:26:42 -0400
Content-Disposition: inline
In-Reply-To: <20130709224013.GA22816@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> The in-kernel header file include/uapi/linux/netfilter/nfnetlink_queue.h
> nfqnl_attr_type enum includes two additional types:
> 
>         NFQA_CAP_LEN,                   /* __u32 length of captured packet */
>         NFQA_SKB_INFO,                  /* __u32 skb meta information */
> 
> Which are not in the version shipped with libnetfilter_queue.  Should
> these be in sync?

They are in the 'next' branch of libnetfilter_queue.git
