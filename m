From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Fri, 15 Jan 2016 17:33:15 +0100
Message-ID: <20160115163315.GA1276@salvia>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115110218.GA2361@salvia>
 <20160115140412.GD7462@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephane Bryant <stephane.ml.bryant@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44913 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbcAOQdZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 11:33:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 09F66245E4D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 17:33:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEC2FDA80C
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 17:33:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01ADFDA843
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 17:33:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160115140412.GD7462@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 15, 2016 at 03:04:12PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > For the specific case of nfnetlink_queue, I would expose the vlan
> > information through a new netlink attribute NFQA_VLAN (similar to what
> > we do for NFQA_HWADDR for the layer 3).
> 
> If we do this I think it does make sense to consider putting
> the entire L2 mac header under its own attr too.
> 
> This is especially good if we'd later add support for NETDEV
> family.  Since drivers already pull the L2 header userspace
> would not need to handle arbirary L2 protocols.

Good point, fine with me.

> > > +				payload += VLAN_HLEN;
> > > +				payload_len -= VLAN_HLEN;
> > > +			} else {
> > > +				entry->skb->vlan_tci &= ~VLAN_TAG_PRESENT;
> > > +				entry->skb->protocol = veth->h_vlan_proto;
> > > +			}
> > > +		}
> > 
> > I'm awar it's more work, but it would be good to reduce ifdef pollution
> > by placing all this bridge netfilter code wrapped into functions under
> > one single ifdef in this file to improve maintainability.
> 
> Right, but for anything family specifiy it would be even better to push
> it into nf afinfo. In case thats too much work or too cumbersome (e.g.
> because you'd need 12 function arguments ...) then the ifdef-wrapped
> helper is fine of course.

I'm fine with pushing this info afinfo if it fits fine there.
