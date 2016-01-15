From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Fri, 15 Jan 2016 11:49:58 +0100
Message-ID: <20160115104958.GC7462@breakpoint.cc>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115100628.GB7462@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephane Bryant <stephane.ml.bryant@gmail.com>,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38002 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbcAOKuB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 05:50:01 -0500
Content-Disposition: inline
In-Reply-To: <20160115100628.GB7462@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Stephane Bryant <stephane.ml.bryant@gmail.com> wrote:
> > From: stephane <stephane.ml.bryant@gmail.com>
> > 
> > For bridge packets queued to userspace, this uses the skb tci info
> > to reinstate the VLAN header, and conversely parses and removes it
> > to fill the tci info on the way back.
> > -			 * it gets copied in
> > -			 */
> >  			mac_header_len =
> >  				(int)(entskb->data - skb_mac_header(entskb));
> > -			skb_push(entskb, mac_header_len);
> > +			if (skb_vlan_tag_present(entskb))
> > +				vlan_len = VLAN_HLEN;
> 
> I wondered if we could use the saveroute and reroute hooks in the nf
> afinfo to perform the push/pull.
> 
> It would keep the bridge specific parts out of the generic code.

Addendum: If its not possible I'd prefer to add afinfo helpers for it to
keep this out of the generic part.

F.e. we will likely also want netdev family support later on.

As for complications wrt. nf_bridge_adjust_skb_data() (the software
segmentation part) I think the best way would be to reject attempts to
bind a queue for families other than NFPROTO_IPV4|6 without
NFQA_CFG_F_GSO flag present.

