From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: api: add connlabel api and attribute
Date: Sun, 3 Feb 2013 10:59:21 +0100
Message-ID: <20130203095921.GA3560@localhost>
References: <1358980701-3747-3-git-send-email-fw@strlen.de>
 <20130202204811.GA32078@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:42287 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752951Ab3BCJ71 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2013 04:59:27 -0500
Content-Disposition: inline
In-Reply-To: <20130202204811.GA32078@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 02, 2013 at 09:48:11PM +0100, Florian Westphal wrote:
> Hi.
> 
> I was about to push the pending connlabel patches
> for libnetfilter_conntrack, but then noticed one important
> point, namely, handling of ATTR_CONNLABEL with nfct_set_attr().
> 
> The existing setters all copy their argument, but the current connlabel
> setter only assigns the pointer, i.e., 'ownership' of the bitmask object
> is then tied to conntrack object.  This may not be whats expected.
> 
> Should I make this change:
> 
> set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
> {
> -  ct->connlabels = (void *) value;
> +  ct->connlabels = nfct_bitmask_clone(value);
> }
> 
> to avoid this or not?

To attach expectations to master conntracks, we pass the object via
the setter without cloning it.

So my suggestion is to document how it works and leave it as is. BTW,
make sure that object is released in the nfct_destroy path if you do
so.

Regards.
