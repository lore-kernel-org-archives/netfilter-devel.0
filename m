From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_conntrack: set_attr_dnat_ipv4
Date: Tue, 8 Dec 2015 23:37:57 +0100
Message-ID: <20151208223757.GC31055@breakpoint.cc>
References: <CAMp4zn9xj41jv+BhQg0SPaY8VEoJa6SiHTQj470A7L1_Yr=NDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42401 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbbLHWh7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2015 17:37:59 -0500
Content-Disposition: inline
In-Reply-To: <CAMp4zn9xj41jv+BhQg0SPaY8VEoJa6SiHTQj470A7L1_Yr=NDQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sargun Dhillon <sargun@sargun.me> wrote:
> I'm curious, I'm looking at the libnetfilter_conntrack code, and I see
> the following function definition:
> 
> static void
> set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
> {
>     ct->dnat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
> }

Sure looks like a copy & paste bug...
