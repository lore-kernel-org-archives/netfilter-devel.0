From: Chee Yong TAN <chee_yong_tan@hotmail.com>
Subject: Re: Sending back out A TCP Packet from netfilter
Date: Tue, 24 Feb 2004 10:18:10 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403AB462.6080404@hotmail.com>
References: <Pine.LNX.4.44.0402231518470.1686-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402231518470.1686-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

> On Mon, 23 Feb 2004, Chee Yong TAN wrote:
> 
> 
>>I have tried to follow the codes closely but seems that it kills the 
>>interrupt handler. I keep getting Oops with that dread Aiyee killing the 
>>interrupt handler
> 
> 
> Then show us what you have done and maybe we can help spotting the error?

OK The aiyee was due to memory leak.
I resolve that but it does not work on loop back now :(
Code As Follows

static inline void tcp_checksum(struct iphdr *ip, struct tcphdr *tcp)
{
	tcp->check=0;
	tcp->check = (csum_tcpudp_magic(ip->saddr,
			ip->daddr,
			ntohs(ip->tot_len) - (ip->ihl<<2),
			IPPROTO_TCP,
			csum_partial((u_char *)tcp,
				ntohs(ip->tot_len) - (ip->ihl<<2),0)));
	return;
}
static void connection_attach(struct sk_buff *new_skb, struct nf_ct_info 
*nfct)
{
	void (*attach)(struct sk_buff *, struct nf_ct_info *);
	
	/* Avoid module unload race with ip_ct_attach being NULLed out */
	if (nfct && (attach = ip_ct_attach) != NULL)
		attach(new_skb, nfct);
}
static inline void rewrite_packet(struct sk_buff *sb)
{
struct iphdr	*ip = sb->nh.iph;
struct tcphdr	*tcp = (struct tcphdr *)((sb->data) + (ip->ihl * 4));
unsigned int	len = (ntohs(ip->tot_len) - ((ip->ihl * 4) + (tcp->doff *4)));	
u32		tmp_long;
u16		tmp_short;
unsigned char				tmp_ether[ETH_ALEN];
sb->pkt_type = PACKET_OUTGOING;

memset(tmp_ether,0x0,ETH_ALEN);
memcpy(tmp_ether,sb->mac.ethernet->h_dest,ETH_ALEN);
memcpy(sb->mac.ethernet->h_dest,sb->mac.ethernet->h_source,ETH_ALEN);
memcpy(sb->mac.ethernet->h_source,tmp_ether,ETH_ALEN);
tmp_long = ip->saddr;
ip->saddr = ip->daddr;
ip->daddr = tmp_long;
tmp_short = tcp->source;
tcp->source = tcp->dest;
tcp->dest = tmp_short;
tmp_long= tcp->ack_seq;
tcp->ack_seq = htons(ntohs(tcp->seq) + len);
tcp->seq = tmp_long;
tcp->ack = 1;
tcp->psh = 1;
tcp->rst = 0;
tcp->syn = 0;
tcp->urg = 0;
tcp->fin = 0;
tcp->window = 0;
tcp->urg_ptr = 0;
sb->nh.iph->ttl = MAXTTL;
	/* Set DF, id = 0 */
sb->nh.iph->frag_off = htons(IP_DF);
sb->nh.iph->id = 0;		
}
static inline struct rtable *route_packet(struct sk_buff *skb, int hook)
{
	struct iphdr *iph = skb->nh.iph;
	struct dst_entry *odst;
	struct rt_key key = {};
	struct rtable *rt;
	
	if (hook != NF_IP_FORWARD)
	{
		key.dst = iph->saddr;
		if (hook == NF_IP_LOCAL_IN)
			key.src = iph->daddr;
		key.tos = RT_TOS(iph->tos);
		
		if (ip_route_output_key(&rt, &key) != 0)
			return NULL;
	}
	else
	{
		/* non-local src, find valid iif to satisfy
		* rp-filter when calling ip_route_input. */
		key.dst = iph->daddr;
		if (ip_route_output_key(&rt, &key) != 0)
			return NULL;
	
		odst = skb->dst;
		if (ip_route_input(skb, iph->saddr, iph->daddr,
			RT_TOS(iph->tos), rt->u.dst.dev) != 0)
		{
			dst_release(&rt->u.dst);
			return NULL;
		}
		dst_release(&rt->u.dst);
		rt = (struct rtable *)skb->dst;
		skb->dst = odst;
	}
	
	if (rt->u.dst.error)
	{
		dst_release(&rt->u.dst);
		rt = NULL;
	}
	
	return rt;
}
/* The following code is part of the hook function */
if ((rt = route_packet(sb, hook)) == NULL)
	return NF_DROP;
hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
nskb = skb_copy_expand(sb, hh_len, skb_tailroom(sb),GFP_ATOMIC);
if (!nskb)
{
	dst_release(&rt->u.dst);
	return NF_DROP;
}
dst_release(nskb->dst);
nskb->dst = &rt->u.dst;
/* This packet will not be the same as the other: clear nf fields */
#ifdef CONFIG_NETFILTER
nf_conntrack_put(nskb->nfct);
nskb->nfct = NULL;
nskb->nfmark=0;
nskb->nfcache = 0;
#ifdef CONFIG_NETFILTER_DEBUG
nskb->nf_debug=0;
#endif
#endif /*CONFIG_NETFILTER*/	
nip = nskb->nh.iph;
ntcp = (struct tcphdr *)((nskb->data) + (nip->ihl * 4));
ndata = (unsigned char *)((nskb->data) + (nip->ihl * 4) + 
(ntcp->doff *4));		
memcpy(&ndata[sizeof(__u32)],&cmd,sizeof(cmd));
memset(&ndata[sizeof(__u32)+ sizeof(cmd)],0x0,sizeof(struct 
pf_rules_record));
memcpy(&ndata[sizeof(__u32)+ sizeof(cmd)],userinfo,sizeof(struct 
pf_rules_record));
rewrite_packet(nskb);
				
tcp_checksum(nip,ntcp);
nskb->nh.iph->check = 0;
nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
nskb->nh.iph->ihl);
if (nskb->len > nskb->dst->pmtu)
{
	kfree_skb(nskb);
	return NF_DROP;
}

connection_attach(nskb, sb->nfct);
NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, 
nskb->dst->dev,ip_finish_output);               	
/*
  * Drop the Packet :p
  */
return NF_DROP;	


> 
> Regards
> Henrik
> 
