From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Wed, 6 May 2015 20:50:40 +0200
Message-ID: <20150506185040.GA14459@salvia>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
 <20150504103451.GA12200@salvia>
 <55475F13.1000304@iogearbox.net>
 <20150504130828.GA3607@salvia>
 <20150504134733.GB1405@pox.localdomain>
 <20150506142741.GA3547@salvia>
 <554A56CA.4040101@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Graf <tgraf@suug.ch>, netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39857 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbbEFSqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2015 14:46:08 -0400
Content-Disposition: inline
In-Reply-To: <554A56CA.4040101@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Daniel,

On Wed, May 06, 2015 at 08:00:42PM +0200, Daniel Borkmann wrote:
> On 05/06/2015 04:27 PM, Pablo Neira Ayuso wrote:
[...]
> >But what is the use case for -j CT --flextuple reply ? By when you see
> >the reply packet the tuple was already created.
> 
> Given this change is completely NAT agnostic, we can keep it as a
> generic addition to the conntracker. Given that the mark is very
> flexible, I think it could also be used for load balancing as a
> different usage.

The original and reply tuples of the conntrack are set by the first
packet going in the original direction, at that time they are both
inserted in the hashes, in this scenario it will use the default mark
(0). So if you set the --flextuple reply, conntrack will include the
mark as part of the hashtuple in the first reply packet, but that
packet will not match the conntrack object that was created by the
first original packet and it will result a new conntrack assuming that
the reply is the original direction. This looks broken to me.

> >Another question is if it makes sense to have part of the flows using
> >your flextuple idea while some others not, ie.
> >
> >         -s x.y.z.w/24 -j CT --flextuple original
> >
> >so shouldn't this be a global switch that includes the skb->mark
> >only for packets coming in the original direction?
> 
> I first thought about a global sysctl switch, but eventually found
> this config possibility from iptables side much cleaner resp. better
> integrated. I think if the environment is correctly configured for
> that, such a partial flextuple scenario works, too.

This is consuming two ct status bits, these are exposed to userspace,
and we have a limited number of bits there. The one in the original
direction might be justified for the SNAT case in the specific
scenario that you show.

I don't see yet how this can make sense in a hybrid scenario. We may
end up with a packet that can potentially create and match two
different flow objects if this is misconfigured.

> >I also wonder how you're going to deal with port redirections. This
> >only seem to be working SNAT/masquerade to me if the NAT happens from
> >VRF side.
> 
> In our case, we'd like to use the flextuple when we're explicitly
> configuring iptables with SNAT. For DNAT, one could reuse it in a
> different, somewhat reversed example we previously had and together
> with mark based routing and match on the reply side.

OK, so different VRFs with overlapping networks that are redirected to
the port of another destination. That might makes sense. Still the
hybrid scenario and the --flextuple reply need some thinking.

Thanks.
