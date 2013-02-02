From: Florian Westphal <fw@strlen.de>
Subject: Re: api: add connlabel api and attribute
Date: Sat, 2 Feb 2013 21:48:11 +0100
Message-ID: <20130202204811.GA32078@breakpoint.cc>
References: <1358980701-3747-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37306 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3BBUsM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:48:12 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@strlen.de>)
	id 1U1k0R-0008Kl-98
	for netfilter-devel@vger.kernel.org; Sat, 02 Feb 2013 21:48:11 +0100
Content-Disposition: inline
In-Reply-To: <1358980701-3747-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

I was about to push the pending connlabel patches
for libnetfilter_conntrack, but then noticed one important
point, namely, handling of ATTR_CONNLABEL with nfct_set_attr().

The existing setters all copy their argument, but the current connlabel
setter only assigns the pointer, i.e., 'ownership' of the bitmask object
is then tied to conntrack object.  This may not be whats expected.

Should I make this change:

set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
{
-  ct->connlabels = (void *) value;
+  ct->connlabels = nfct_bitmask_clone(value);
}

to avoid this or not?

If noone objects, I will make this modifcation and push into -next branch.
