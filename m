From: Shmulik Ladkani <shmulik@nsof.io>
Subject: Re: [PATCH v2 1/2] iptables: support match info fixup after tc_init
Date: Mon, 18 Sep 2017 20:00:42 +0300
Message-ID: <20170918200042.3189aa0f@pixies>
References: <20170917112031.8644-1-shmulik@nsof.io>
        <20170917112031.8644-2-shmulik@nsof.io>
        <20170918162811.GA6091@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:50489 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932254AbdIRRAq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 13:00:46 -0400
Received: by mail-wm0-f41.google.com with SMTP id v142so4494237wmv.5
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2017 10:00:46 -0700 (PDT)
In-Reply-To: <20170918162811.GA6091@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, 18 Sep 2017 18:28:11 +0200 Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> >  
> > +	/* Fixes the match info after init. */
> > +	void (*tc_init_fixup)(struct xt_entry_match *match);  
> 
> If this is only broken from tc ipt actions, could you fix this from
> iproute2/tc instead?

No, this is not iproute2/tc specfic.

We named it 'tc_init_fixup' as it occurs just after the TC_INIT
(iptc_init/ip6tc_init) call.
If this is confusing, we can rename to 'init_fixup' or 'post_init_fixup'
or 'iptc_init_fixup'.

This must occur after every load of entries, as the xt_bpf match needs
a fixup once read from kernel.

The problem lies in the xt_bpf_info_v1 ABI.
See:
https://marc.info/?l=netfilter-devel&m=150530909630143&w=2

Regards,
Shmulik
