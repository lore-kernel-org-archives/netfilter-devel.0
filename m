From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 0/3] netfilter: add connlabel conntrack extension
Date: Fri, 16 Nov 2012 12:31:09 +0100
Message-ID: <20121116113109.GK20678@breakpoint.cc>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <20121116100256.GA25964@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44486 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab2KPLbL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:31:11 -0500
Content-Disposition: inline
In-Reply-To: <20121116100256.GA25964@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Nov 15, 2012 at 04:55:12PM +0100, Florian Westphal wrote:
> > Changes since RFCv2:
> > - make it a variable-size extension and remove dynamic
> >   reallocation of the label array
> > - add ctnetlink support for receiving/setting labels
> > - limit to 128 instead of 1k labels due to limited extension
> >   space (128 is more than enough for now, so this is no problem).
> 
> At a quick glance I like this round, you got this simplified :-).
> 
> My only concern is that (if I'm not missing anything) it
> inconditionally add the extension even if we don't need it.

Its conditional:

words = ACCESS_ONCE(net->ct.label_words);
if (words == 0 || WARN_ON_ONCE(words > 8))
	return NULL;
cl_ext = nf_ct_ext_add_length(ct, NF_CT_EXT_LABELS, words * sizeof(long),..

xt_connlabel increases "label_words" to a non-zero
value based on the highest bit it saw so far.  So e.g. when bit 32 is
requested, a 32-bit machine kernel will set words to 2, and
a 64 bit kernel to 1, thus turning the extension on for new connections.

The only drawback is that when you add a connlabel rule for bits 127,
then for bit 1, then delete the first rule again words will be larger
than one.

But i think this ok (I don't want to add per-bit refcountr :-) )
