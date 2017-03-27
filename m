From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/4] netfilter: amanda: Correct the return value comparison of the func nf_nat_mangle_udp_packet
Date: Mon, 27 Mar 2017 20:48:57 +0800
Message-ID: <000801d2a6f8$80709dd0$8151d970$@foxmail.com>
References: <cover.1489726438.git.fgao@ikuai8.com> <fdfd3853391d136ba390dfdc4dc6884f552e540e.1489726438.git.fgao@ikuai8.com> <20170327121232.GA15713@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <gfree.wind@gmail.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg302.qq.com ([184.105.206.27]:58164 "EHLO smtpbg302.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbdC0MtI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 08:49:08 -0400
In-Reply-To: <20170327121232.GA15713@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Monday, March 27, 2017 8:13 PM
> To: fgao@ikuai8.com
> Cc: netfilter-devel@vger.kernel.org; gfree.wind@gmail.com
> Subject: Re: [PATCH nf-next 1/4] netfilter: amanda: Correct the return
value
> comparison of the func nf_nat_mangle_udp_packet
> 
> On Fri, Mar 17, 2017 at 02:47:19PM +0800, fgao@ikuai8.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > The return value of nf_nat_mangle_udp_packet actually is 1 and 0 as
> > bool type. But the amanda codes compare it with NF_ACCEPT.
> >
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  net/netfilter/nf_nat_amanda.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/netfilter/nf_nat_amanda.c
> > b/net/netfilter/nf_nat_amanda.c index eb77238..e4d61a7 100644
> > --- a/net/netfilter/nf_nat_amanda.c
> > +++ b/net/netfilter/nf_nat_amanda.c
> > @@ -33,7 +33,6 @@ static unsigned int help(struct sk_buff *skb,  {
> >  	char buffer[sizeof("65535")];
> >  	u_int16_t port;
> > -	unsigned int ret;
> >
> >  	/* Connection comes from client. */
> >  	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port; @@ -63,14
> > +62,14 @@ static unsigned int help(struct sk_buff *skb,
> >  	}
> >
> >  	sprintf(buffer, "%u", port);
> > -	ret = nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
> > -				       protoff, matchoff, matchlen,
> > -				       buffer, strlen(buffer));
> > -	if (ret != NF_ACCEPT) {
> > +	if (!nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
> > +				      protoff, matchoff, matchlen,
> > +				      buffer, strlen(buffer))) {
> >  		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
> >  		nf_ct_unexpect_related(exp);
> > +		return NF_DROP;
> >  	}
> > -	return ret;
> > +	return NF_ACCEPT;
> 
> This cleanup patches are a bit oversplit.
> 
> Better, send one patch where you update nf_nat_mangle_udp_packet() and
> nf_nat_mangle_tcp_packet() to return boolean and update *all of the
netfilter
> spots* where we use them accordingly.
> 
> Please be careful on this...
Ok, I would merge them into one patch.
I already checked them before, but I would check it again after merge.

Regards
Feng



