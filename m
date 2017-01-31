From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH] audit: normalize NETFILTER_PKT
Date: Tue, 31 Jan 2017 17:13:26 +0100
Message-ID: <20170131171326.55d414bf@ivy-bridge>
References: <e3af1eaaf566af375dbc79abd4535e86f2fc8a6d.1485522479.git.rgb@redhat.com>
        <20170130155330.55a91c7d@ivy-bridge>
        <20170130151355.GS3087@madcap2.tricolour.ca>
        <20170131125723.GA27141@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdAaQNZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2017 11:13:25 -0500
In-Reply-To: <20170131125723.GA27141@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 31 Jan 2017 07:57:23 -0500
Richard Guy Briggs <rgb@redhat.com> wrote:

> On 2017-01-30 10:13, Richard Guy Briggs wrote:
> > On 2017-01-30 15:53, Steve Grubb wrote:  
> > > On Fri, 27 Jan 2017 08:11:06 -0500
> > > Richard Guy Briggs <rgb@redhat.com> wrote:  
> > > > Eliminate flipping in and out of message fields.
> > > > 
> > > > https://github.com/linux-audit/audit-kernel/issues/11  
> > > 
> > > Do you have sample events that shows how this changes the record
> > > format? I like to review how the event looks when a patch changes
> > > or adds a record.  
> > 
> > I used the format that was proposed.  Here are several samples from
> > running this RFC patch through the RFC test script:
> > 
> > 	ausearch --start 01/27/2017 -i -m netfilter_pkt
> > ----
> > type=NETFILTER_PKT msg=audit(01/27/2017 08:03:35.649:183) :
> > action=ACCEPT hook=OUTPUT len=84 inif=? outif=lo mark=0xa044a1d4
> > smac=? dmac=? macproto=UNKNOWN trunc=-1 saddr=127.0.0.1
> > daddr=127.0.0.1 ipid=26581 proto=icmp frag=255 trunc=-1 sport=65535
> > dport=65535 icmptype=echo icmpcode=0 ---- type=NETFILTER_PKT
> > msg=audit(01/27/2017 08:03:35.649:184) : action=ACCEPT hook=INPUT
> > len=84 inif=lo outif=? mark=0xbadeac28 smac=? dmac=?
> > macproto=UNKNOWN trunc=-1 saddr=127.0.0.1 daddr=127.0.0.1
> > ipid=26581 proto=icmp frag=255 trunc=-1 sport=65535 dport=65535
> > icmptype=echo icmpcode=0 ---- type=NETFILTER_PKT
> > msg=audit(01/27/2017 08:03:35.652:185) : action=ACCEPT hook=INPUT
> > len=104 inif=lo outif=? mark=0xb404724 smac=? dmac=?
> > macproto=UNKNOWN trunc=-1 saddr=::1 daddr=::1 ipid=-1
> > proto=ipv6-icmp frag=-1 trunc=-1 sport=65535 dport=65535
> > icmptype=unknown icmp type (128) icmpcode=0 ---- type=NETFILTER_PKT
> > msg=audit(01/27/2017 08:03:35.655:186) : action=ACCEPT hook=INPUT
> > len=60 inif=lo outif=? mark=0xe2bd8098 smac=? dmac=?
> > macproto=UNKNOWN trunc=-1 saddr=127.0.0.1 daddr=127.0.0.1
> > ipid=29381 proto=tcp frag=255 trunc=-1 sport=51064 dport=42424
> > icmptype=unknown icmp type (255) icmpcode=255 ----
> > type=NETFILTER_PKT msg=audit(01/27/2017 08:03:35.657:187) :
> > action=ACCEPT hook=INPUT len=80 inif=lo outif=? mark=0xf80a9dd7
> > smac=? dmac=? macproto=UNKNOWN trunc=-1 saddr=::1 daddr=::1 ipid=-1
> > proto=tcp frag=-1 trunc=-1 sport=38188 dport=42424 icmptype=unknown
> > icmp type (255) icmpcode=255 ---- type=NETFILTER_PKT
> > msg=audit(01/27/2017 08:03:35.659:188) : action=ACCEPT hook=INPUT
> > len=31 inif=lo outif=? mark=0xa6d8d4ac smac=? dmac=?
> > macproto=UNKNOWN trunc=-1 saddr=127.0.0.1 daddr=127.0.0.1
> > ipid=46304 proto=udp frag=255 trunc=-1 sport=60095 dport=42424
> > icmptype=unknown icmp type (255) icmpcode=255 ----
> > type=NETFILTER_PKT msg=audit(01/27/2017 08:03:35.661:189) :
> > action=ACCEPT hook=INPUT len=51 inif=lo outif=? mark=0x3f0d6054
> > smac=? dmac=? macproto=UNKNOWN trunc=-1 saddr=::1 daddr=::1 ipid=-1
> > proto=udp frag=-1 trunc=-1 sport=43818 dport=42424 icmptype=unknown
> > icmp type (255) icmpcode=255 ----  
> 
> Here are the raw messages:
> 
> ----
> time->Fri Jan 27 08:03:35 2017
> type=NETFILTER_PKT msg=audit(1485522215.649:183): action=0 hook=3
> len=84 inif=? outif=lo mark=0xa044a1d4 smac=? dmac=? macproto=0xffff
> trunc=-1 saddr=127.0.0.1 daddr=127.0.0.1 ipid=26581 proto=1 frag=255
> trunc=-1 sport=65535 dport=65535 icmptype=8 icmpcode=0 ---- time->Fri
> Jan 27 08:03:35 2017 type=NETFILTER_PKT
> msg=audit(1485522215.649:184): action=0 hook=1 len=84 inif=lo outif=?
> mark=0xbadeac28 smac=? dmac=? macproto=0xffff trunc=-1
> saddr=127.0.0.1 daddr=127.0.0.1 ipid=26581 proto=1 frag=255 trunc=-1
> sport=65535 dport=65535 icmptype=8 icmpcode=0 ---- time->Fri Jan 27
> 08:03:35 2017 type=NETFILTER_PKT msg=audit(1485522215.652:185):
> action=0 hook=1 len=104 inif=lo outif=? mark=0xb404724 smac=? dmac=?
> macproto=0xffff trunc=-1 saddr=::1 daddr=::1 ipid=-1 proto=58 frag=-1
> trunc=-1 sport=65535 dport=65535 icmptype=128 icmpcode=0 ----
> time->Fri Jan 27 08:03:35 2017 type=NETFILTER_PKT
> msg=audit(1485522215.655:186): action=0 hook=1 len=60 inif=lo outif=?
> mark=0xe2bd8098 smac=? dmac=? macproto=0xffff trunc=-1
> saddr=127.0.0.1 daddr=127.0.0.1 ipid=29381 proto=6 frag=255 trunc=-1
> sport=51064 dport=42424 icmptype=255 icmpcode=255 ---- time->Fri Jan
> 27 08:03:35 2017 type=NETFILTER_PKT msg=audit(1485522215.657:187):
> action=0 hook=1 len=80 inif=lo outif=? mark=0xf80a9dd7 smac=? dmac=?
> macproto=0xffff trunc=-1 saddr=::1 daddr=::1 ipid=-1 proto=6 frag=-1
> trunc=-1 sport=38188 dport=42424 icmptype=255 icmpcode=255 ----
> time->Fri Jan 27 08:03:35 2017 type=NETFILTER_PKT
> msg=audit(1485522215.659:188): action=0 hook=1 len=31 inif=lo outif=?
> mark=0xa6d8d4ac smac=? dmac=? macproto=0xffff trunc=-1
> saddr=127.0.0.1 daddr=127.0.0.1 ipid=46304 proto=17 frag=255 trunc=-1
> sport=60095 dport=42424 icmptype=255 icmpcode=255 ---- time->Fri Jan
> 27 08:03:35 2017 type=NETFILTER_PKT msg=audit(1485522215.661:189):
> action=0 hook=1 len=51 inif=lo outif=? mark=0x3f0d6054 smac=? dmac=?
> macproto=0xffff trunc=-1 saddr=::1 daddr=::1 ipid=-1 proto=17 frag=-1
> trunc=-1 sport=43818 dport=42424 icmptype=255 icmpcode=255 ----

I was curious about something. Auparse is trying to interpret the
icmptype field for every event. This is not good. Which fields are
valid for each kind of packet? Are there fields valid for all packets?
Is the icmptype/code the only ones that don't apply in all cases?

Thanks,
-Steve


> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  net/netfilter/xt_AUDIT.c |   92
> > > > +++++++++++++++++++++++++++++++++------------- 1 files changed,
> > > > 66 insertions(+), 26 deletions(-)
> > > > 
> > > > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> > > > index 4973cbd..8089ec2 100644
> > > > --- a/net/netfilter/xt_AUDIT.c
> > > > +++ b/net/netfilter/xt_AUDIT.c
> > > > @@ -31,24 +31,41 @@ MODULE_ALIAS("ip6t_AUDIT");
> > > >  MODULE_ALIAS("ebt_AUDIT");
> > > >  MODULE_ALIAS("arpt_AUDIT");
> > > >  
> > > > +struct nfpkt_par {
> > > > +	int ipv;
> > > > +	int iptrunc;
> > > > +	const void *saddr;
> > > > +	const void *daddr;
> > > > +	u16 ipid;
> > > > +	u8 proto;
> > > > +	u8 frag;
> > > > +	int ptrunc;
> > > > +	u16 sport;
> > > > +	u16 dport;
> > > > +	u8 icmpt;
> > > > +	u8 icmpc;
> > > > +};
> > > > +
> > > >  static void audit_proto(struct audit_buffer *ab, struct
> > > > sk_buff *skb,
> > > > -			unsigned int proto, unsigned int
> > > > offset)
> > > > +			unsigned int proto, unsigned int
> > > > offset, struct nfpkt_par *apar) {
> > > >  	switch (proto) {
> > > >  	case IPPROTO_TCP:
> > > >  	case IPPROTO_UDP:
> > > > -	case IPPROTO_UDPLITE: {
> > > > +	case IPPROTO_UDPLITE:
> > > > +	case IPPROTO_DCCP:
> > > > +	case IPPROTO_SCTP: {
> > > >  		const __be16 *pptr;
> > > >  		__be16 _ports[2];
> > > >  
> > > >  		pptr = skb_header_pointer(skb, offset,
> > > > sizeof(_ports), _ports); if (pptr == NULL) {
> > > > -			audit_log_format(ab, " truncated=1");
> > > > +			apar->ptrunc = 1;
> > > >  			return;
> > > >  		}
> > > > +		apar->sport = ntohs(pptr[0]);
> > > > +		apar->dport = ntohs(pptr[1]);
> > > >  
> > > > -		audit_log_format(ab, " sport=%hu dport=%hu",
> > > > -				 ntohs(pptr[0]),
> > > > ntohs(pptr[1])); }
> > > >  		break;
> > > >  
> > > > @@ -59,41 +76,43 @@ static void audit_proto(struct audit_buffer
> > > > *ab, struct sk_buff *skb, 
> > > >  		iptr = skb_header_pointer(skb, offset,
> > > > sizeof(_ih), &_ih); if (iptr == NULL) {
> > > > -			audit_log_format(ab, " truncated=1");
> > > > +			apar->ptrunc = 1;
> > > >  			return;
> > > >  		}
> > > > -
> > > > -		audit_log_format(ab, " icmptype=%hhu
> > > > icmpcode=%hhu",
> > > > -				 iptr[0], iptr[1]);
> > > > +		apar->icmpt = iptr[0];
> > > > +		apar->icmpc = iptr[1];
> > > >  
> > > >  		}
> > > >  		break;
> > > >  	}
> > > >  }
> > > >  
> > > > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff
> > > > *skb) +static void audit_ip4(struct audit_buffer *ab, struct
> > > > sk_buff *skb, struct nfpkt_par *apar) {
> > > >  	struct iphdr _iph;
> > > >  	const struct iphdr *ih;
> > > >  
> > > > +	apar->ipv = 4;
> > > >  	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> > > >  	if (!ih) {
> > > > -		audit_log_format(ab, " truncated=1");
> > > > +		apar->iptrunc = 1;
> > > >  		return;
> > > >  	}
> > > >  
> > > > -	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu
> > > > proto=%hhu",
> > > > -		&ih->saddr, &ih->daddr, ntohs(ih->id),
> > > > ih->protocol);
> > > > +	apar->saddr = &ih->saddr;
> > > > +	apar->daddr = &ih->daddr;
> > > > +	apar->ipid = ntohs(ih->id);
> > > > +	apar->proto = ih->protocol;
> > > >  
> > > >  	if (ntohs(ih->frag_off) & IP_OFFSET) {
> > > > -		audit_log_format(ab, " frag=1");
> > > > +		apar->frag = 1;
> > > >  		return;
> > > >  	}
> > > >  
> > > > -	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
> > > > +	audit_proto(ab, skb, ih->protocol, ih->ihl * 4, apar);
> > > >  }
> > > >  
> > > > -static void audit_ip6(struct audit_buffer *ab, struct sk_buff
> > > > *skb) +static void audit_ip6(struct audit_buffer *ab, struct
> > > > sk_buff *skb, struct nfpkt_par *apar) {
> > > >  	struct ipv6hdr _ip6h;
> > > >  	const struct ipv6hdr *ih;
> > > > @@ -101,9 +120,10 @@ static void audit_ip6(struct audit_buffer
> > > > *ab, struct sk_buff *skb) __be16 frag_off;
> > > >  	int offset;
> > > >  
> > > > +	apar->ipv = 6;
> > > >  	ih = skb_header_pointer(skb, skb_network_offset(skb),
> > > > sizeof(_ip6h), &_ip6h); if (!ih) {
> > > > -		audit_log_format(ab, " truncated=1");
> > > > +		apar->iptrunc = 1;
> > > >  		return;
> > > >  	}
> > > >  
> > > > @@ -111,11 +131,12 @@ static void audit_ip6(struct audit_buffer
> > > > *ab, struct sk_buff *skb) offset = ipv6_skip_exthdr(skb,
> > > > skb_network_offset(skb) + sizeof(_ip6h), &nexthdr, &frag_off);
> > > >  
> > > > -	audit_log_format(ab, " saddr=%pI6c daddr=%pI6c
> > > > proto=%hhu",
> > > > -			 &ih->saddr, &ih->daddr, nexthdr);
> > > > +	apar->saddr = &ih->saddr;
> > > > +	apar->daddr = &ih->daddr;
> > > > +	apar->proto = nexthdr;
> > > >  
> > > >  	if (offset)
> > > > -		audit_proto(ab, skb, nexthdr, offset);
> > > > +		audit_proto(ab, skb, nexthdr, offset, apar);
> > > >  }
> > > >  
> > > >  static unsigned int
> > > > @@ -123,6 +144,9 @@ audit_tg(struct sk_buff *skb, const struct
> > > > xt_action_param *par) {
> > > >  	const struct xt_audit_info *info = par->targinfo;
> > > >  	struct audit_buffer *ab;
> > > > +	struct nfpkt_par apar = {
> > > > +		-1, -1, NULL, NULL, -1, -1, -1, -1, -1, -1,
> > > > -1, -1
> > > > +	};
> > > >  
> > > >  	if (audit_enabled == 0)
> > > >  		goto errout;
> > > > @@ -136,8 +160,7 @@ audit_tg(struct sk_buff *skb, const struct
> > > > xt_action_param *par) par->in ? par->in->name : "?",
> > > >  			 par->out ? par->out->name : "?");
> > > >  
> > > > -	if (skb->mark)
> > > > -		audit_log_format(ab, " mark=%#x", skb->mark);
> > > > +	audit_log_format(ab, " mark=%#x", skb->mark ?: -1);
> > > >  
> > > >  	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> > > >  		audit_log_format(ab, " smac=%pM dmac=%pM
> > > > macproto=0x%04x", @@ -147,25 +170,42 @@ audit_tg(struct sk_buff
> > > > *skb, const struct xt_action_param *par) if (par->family ==
> > > > NFPROTO_BRIDGE) { switch (eth_hdr(skb)->h_proto) {
> > > >  			case htons(ETH_P_IP):
> > > > -				audit_ip4(ab, skb);
> > > > +				audit_ip4(ab, skb, &apar);
> > > >  				break;
> > > >  
> > > >  			case htons(ETH_P_IPV6):
> > > > -				audit_ip6(ab, skb);
> > > > +				audit_ip6(ab, skb, &apar);
> > > >  				break;
> > > >  			}
> > > >  		}
> > > > +	} else {
> > > > +		audit_log_format(ab, " smac=? dmac=?
> > > > macproto=0xffff"); }
> > > >  
> > > >  	switch (par->family) {
> > > >  	case NFPROTO_IPV4:
> > > > -		audit_ip4(ab, skb);
> > > > +		audit_ip4(ab, skb, &apar);
> > > >  		break;
> > > >  
> > > >  	case NFPROTO_IPV6:
> > > > -		audit_ip6(ab, skb);
> > > > +		audit_ip6(ab, skb, &apar);
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	switch (apar.ipv) {
> > > > +	case 4:
> > > > +		audit_log_format(ab, " trunc=%d saddr=%pI4
> > > > daddr=%pI4 ipid=%hu proto=%hhu frag=%d",
> > > > +			 apar.iptrunc, apar.saddr, apar.daddr,
> > > > apar.ipid, apar.proto, apar.frag);
> > > > +		break;
> > > > +	case 6:
> > > > +		audit_log_format(ab, " trunc=%d saddr=%pI6c
> > > > daddr=%pI6c ipid=-1 proto=%hhu frag=-1",
> > > > +			 apar.iptrunc, apar.saddr, apar.daddr,
> > > > apar.proto); break;
> > > > +	default:
> > > > +		audit_log_format(ab, " trunc=-1 saddr=? daddr=?
> > > > ipid=-1 proto=-1 frag=-1"); }
> > > > +	audit_log_format(ab, " trunc=%d sport=%hu dport=%hu
> > > > icmptype=%hhu icmpcode=%hhu",
> > > > +		apar.ptrunc, apar.sport, apar.dport,
> > > > apar.icmpt, apar.icmpc); 
> > > >  #ifdef CONFIG_NETWORK_SECMARK
> > > >  	if (skb->secmark)  
> > >   
> > 
> > - RGB
> > 
> > --
> > Richard Guy Briggs <rgb@redhat.com>
> > Kernel Security Engineering, Base Operating Systems, Red Hat
> > Remote, Ottawa, Canada
> > Voice: +1.647.777.2635, Internal: (81) 32635  
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Kernel Security Engineering, Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635

