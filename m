From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables data type names
Date: Sun, 13 Apr 2014 14:37:28 +0200
Message-ID: <20140413123728.GA26141@localhost>
References: <20140412102901.GA8090@macbook.localnet>
 <20140412105646.GJ31953@breakpoint.cc>
 <20140412110352.GA15624@macbook.localnet>
 <20140413105751.GA1188@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45684 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbaDMMhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:37:35 -0400
Content-Disposition: inline
In-Reply-To: <20140413105751.GA1188@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 13, 2014 at 12:57:53PM +0200, Patrick McHardy wrote:
> On Sat, Apr 12, 2014 at 01:03:53PM +0200, Patrick McHardy wrote:
> > On Sat, Apr 12, 2014 at 12:56:46PM +0200, Florian Westphal wrote:
> > > Patrick McHardy <kaber@trash.net> wrote:
> > > > Before the upcoming release, I'd like to add some more consistency among
> > > > nftables data type names. We currently have the following types:
> > > [..]
> > > > In some cases we're more verbose, in other we're using abrevations.
> > > > I'd like to decide for either one.
> > > > 
> > > 
> > > I like ether_type/ether_addr.
> > > ...
> > > Fully agree, more consistency would be good.
> > 
> > Thanks for the feedback, I'll post a patch soon.
> 
> What I've got now is:
> 
> Address types:
> 
>  ll_addr
>  ipv4_addr
>  ipv6_addr
>  ether_addr
> 
> Protocol types:
> 
>  nf_proto
>  inet_proto
> 
> (l3proto and l4proto don't exist as types)
> 
> Conntrack types:
> 
>  ct_state
>  ct_dir
>  ct_status
>  ct_label
> 
> Packet type related types:
> 
>  mh_type
>  iface_type
>  icmp_type
>  dccp_pkttype
>  icmpv6_type
>  ether_type
> 
> Interface related types:
> 
>  ifindex
>  iface_type
> 
> Arp types:
> 
>  arp_op
> 
> Other types:
> 
>  mark
>  time
>  realm
>  uid
>  gid
> 
> And a few base types that are fine as they are.
> 
> The things I'm not sure about are:
> 
>  ifindex: this is a well established term I think, however it would be more
>           consistent to use iface_index

We can have an alias for this perhaps so both work?

>  mark/realm: pkt_mark and pkt_realm/route_realm perhaps. Not sure

if we would ever have ct_mark, then the initial pkt_ prefix is good to
have.

>  uid/gid: sk_uid/sk_gid?

I like the sk_ prefix also clearly specifies to users that this is
related to the socket information.

So following prefix_keytype looks good to me. The prefix just denotes
the scope for which the keytype applies.
