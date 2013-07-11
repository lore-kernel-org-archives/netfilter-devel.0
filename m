From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 16/29] add permanent byte/packet format
 capability to nfacct
Date: Thu, 11 Jul 2013 22:12:22 +0200
Message-ID: <20130711201222.GG27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com>
 <20130710200024.GB27468@breakpoint.cc>
 <51DEFFDC.3040502@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44926 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab3GKUM0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:12:26 -0400
Content-Disposition: inline
In-Reply-To: <51DEFFDC.3040502@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> Florian Westphal wrote:
> > Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> >> * add a 'fmt' variable to each nfacct object, allowing a permanent packets
> >> and bytes formatting to be stored. The two packet and byte formats are
> >> independent of each other.
> > 
> > Every other in-kernel byte counter (that I can think of) is a plain u64.
> > 
> > It might help if you'd explain why this is necessary.
> This isn't a counter. This field stores the formatting of byte and packet numbers for each accounting object registered with the kernel (8-bits each = 16 bits in total unsigned). If you look at the man page (section FORMAT OPTIONS) it is all explained there - with examples.

It makes no sense to me.

Why should a 'display/representation property' be part of an operating
system kernel?  It seems completely out of place.
