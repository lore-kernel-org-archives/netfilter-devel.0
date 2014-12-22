From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Mon, 22 Dec 2014 14:00:59 +0100
Message-ID: <20141222130059.GA3632@salvia>
References: <54885B08.1010700@c-s.fr>
 <20141210182244.GA5622@salvia>
 <548AC07D.6080703@c-s.fr>
 <20141222115448.GA4908@salvia>
 <9FE9AEC5-F57E-4EB8-8F06-3EDFCD5A5A3D@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: leroy christophe <christophe.leroy@c-s.fr>,
	arturo.borrero.glez@gmail.com, GUITTON Alex <alex.guitton@c-s.fr>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbaLVM6a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:58:30 -0500
Content-Disposition: inline
In-Reply-To: <9FE9AEC5-F57E-4EB8-8F06-3EDFCD5A5A3D@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 22, 2014 at 01:44:12PM +0100, Patrick McHardy wrote:
> Am 22. Dezember 2014 12:54:48 MEZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
> >On Fri, Dec 12, 2014 at 11:16:29AM +0100, leroy christophe wrote:
> >> Hi,
> >> 
> >> table ip nat {
> >>         chain prerouting {
> >>                  type nat hook prerouting priority 0;
> >>                  tcp dport 222 redirect :22
> >>         }
> >>         chain postrouting {
> >>                  type nat hook postrouting priority 0;
> >>         }
> >> }
> >> 
> >> With the above rules, data[priv->sreg_proto_min].data[0] has value
> >> 0x160000 instead of 0x16 on powerpc (Big Endian byte order)
> >> 
> >> Due to this, mr.range[0].min.all gets assigned value 0 instead of 22.
> >> 
> >> Below patch fixes it, but it is maybe not the proper way to fix it,
> >> so I let it up to you.
> >> 
> >> Christophe
> >> 
> >> diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c
> >> b/net/ipv4/netfilter/nft_redir_ipv4.c
> >> index 643c596..554bb32 100644
> >> --- a/net/ipv4/netfilter/nft_redir_ipv4.c
> >> +++ b/net/ipv4/netfilter/nft_redir_ipv4.c
> >> @@ -28,9 +28,9 @@ static void nft_redir_ipv4_eval(const struct
> >> nft_expr *expr,
> >>  	memset(&mr, 0, sizeof(mr));
> >>  	if (priv->sreg_proto_min) {
> >>  		mr.range[0].min.all = (__force __be16)
> >> -					data[priv->sreg_proto_min].data[0];
> >> +					*(__be16*)&data[priv->sreg_proto_min].data[0];
> >>  		mr.range[0].max.all = (__force __be16)
> >> -					data[priv->sreg_proto_max].data[0];
> >> +					*(__be16*)&data[priv->sreg_proto_max].data[0];
> >>  		mr.range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> >>  	}
> >
> >It seems userspace was generating the wrong bytecode, so your
> >workaround was reversing the again the port values.
> >
> >Please, test the userspace fix I sent you and get back to us.
> 
> I actually think this is exactly what needs to be done since it also
> matches what we're doing for runtime gathered data.

Sure, I just sent a new kernel patch to rectify.
