From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 18:19:28 +0000
Message-ID: <20140106181928.GA19666@macbook.localnet>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
 <20140106170523.GA9894@breakpoint.cc>
 <20140106171523.GC23002@macbook.localnet>
 <CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaAFSTc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:19:32 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 07:09:58PM +0100, Kristian Evensen wrote:
> Hello,
> 
> On Mon, Jan 6, 2014 at 6:15 PM, Patrick McHardy <kaber@trash.net> wrote:
> > Well, actually the ct expression already supports connmark, as does userspace.
> >
> > #ifdef CONFIG_NF_CONNTRACK_MARK
> >         case NFT_CT_MARK:
> >                 dest->data[0] = ct->mark;
> >                 return;
> > #endif
> 
> Thank you very much for pointing this out. I will change my approach
> and add a set command in ct (similar to what was recently added to
> meta). Or is someone already working on this?

Not sure what you're trying to achieve, we already support the connmark
in the ct expression:

nft filter output ct mark 0x1 ...
