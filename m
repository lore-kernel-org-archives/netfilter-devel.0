From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 23:54:12 +0200
Message-ID: <20160425215412.GC17538@breakpoint.cc>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
 <20160425170541.GC9987@macbook.localdomain>
 <20160425211937.GB17538@breakpoint.cc>
 <20160425213519.GA29318@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33371 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965002AbcDYVyP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 17:54:15 -0400
Content-Disposition: inline
In-Reply-To: <20160425213519.GA29318@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > If not, I see no choice other than resubmitting the original V1 kernel
> > patch that simply copied the entire sreg into the label area, this way
> > no userspace changes are needed.
> 
> I have to follow up on the previous discussion. Just wondering, what's wrong
> with simply memcpy'ing and supplying the full set of labels?

Ok, here is a summary.

iptables: userspace gives u16 indicating bit, kernel test_bit()s or
set_bits depending if set or get is wanted.

The checkentry hook tells the kernel that label extension for X bits should be
allocated for new conntracks (where X is what userspace gave in the
match struct).


nftables:
get operation simply copies the label area to the sreg.
Since we only support up to 129 labels at the moment this fits into
an nft register.

nft ct label bla

simply expands to a bit test on the sreg filled from nft_ct expression.

There is currently no 'please enable labels for new conntracks'.

First proposal for set operation was to simply expect userspace to
populate the label space for us and memcpy the sreg to the label area.

So

nft label set bla

will *replace* the entire area with the sreg content, i.e. we delete
any other label(s) present.

To only set a label, one has to use

ct labels set ct labels | bla

I have no preference; this is the most simple patch/approach since
it requires no userspace changes (except documenting it).

Second drawback is that we don't know which label(s) will be set or
requested so we either have to unconditionally allocate 16 byte
in the conntrack extension, or, alternatively, raise the 'use this many
bits when allocating a new conntrack' variable in the packet path (should
not be a huge deal since after some time all conntracks would have
sufficient space).

3rd drawback is that its not atomic anymore since we replace
the entire thing (but I don't think this is a problem in practice).
