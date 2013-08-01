From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: xt_TCPMSS: fix handling of malformed TCP
 header
Date: Thu, 1 Aug 2013 02:39:19 +0200
Message-ID: <20130801003919.GB19777@localhost>
References: <1375279852-4059-1-git-send-email-pablo@netfilter.org>
 <alpine.LFD.2.00.1307312236050.1863@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51918 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3HAAjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:39:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1307312236050.1863@ja.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Julian,

On Wed, Jul 31, 2013 at 10:54:16PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 31 Jul 2013, Pablo Neira Ayuso wrote:
> 
> > Make sure the packet has enough room for the TCP header and
> > that it is not malformed.
> > 
> > While at it, store tcph->doff*4 in a variable, as it is used
> > several times.
> > 
> > Reported-by: Julian Anastasov <ja@ssi.bg>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/xt_TCPMSS.c |   27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> > index 7011c71..2883c1c 100644
> > --- a/net/netfilter/xt_TCPMSS.c
> > +++ b/net/netfilter/xt_TCPMSS.c
> 
> > @@ -87,8 +91,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
> >  		newmss = info->mss;
> >  
> >  	opt = (u_int8_t *)tcph;
> > -	for (i = sizeof(struct tcphdr); i < tcph->doff*4; i += optlen(opt, i)) {
> > -		if (opt[i] == TCPOPT_MSS && tcph->doff*4 - i >= TCPOLEN_MSS &&
> > +	for (i = sizeof(struct tcphdr); i < tcp_hdrlen; i += optlen(opt, i)) {
> 
> 	If we also want to avoid the wrong access in optlen()
> we have 2 options for the above line:
> 
> 1. Use 'i < tcp_hdrlen - 1' or 'i <= tcp_hdrlen - 2'
> 
> 2. Use 'i <= tcp_hdrlen - TCPOLEN_MSS' and remove the
> below 'tcp_hdrlen - i >= TCPOLEN_MSS' check

Indeed. I fixed the optlen issue in xt_TCPOPTSTRIP but forgot to make
it here.

Will send a new version, thanks for reviewing.
