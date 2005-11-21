From: Pablo Neira <pablo@eurodev.net>
Subject: Re: CTA_PROTO_NUM u_int8_t or u_int16_t
Date: Mon, 21 Nov 2005 15:53:43 +0100
Message-ID: <4381DF77.2030704@eurodev.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> AFAIK ip proto is u8 but I found that it is represented as u16 and used
> both as u_int16_t and u_int8_t:
> 
> include/linux/netfilter_ipv4/ipt_conntrack.h:           u16 protonum;
> 
> net/ipv4/netfilter/ip_conntrack_netlink.c:      NFA_PUT(skb,
> CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
> net/ipv4/netfilter/ip_conntrack_netlink.c:      [CTA_PROTO_NUM-1]      
> = sizeof(u_int16_t),
> net/ipv4/netfilter/ip_conntrack_netlink.c:      tuple->dst.protonum =
> *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> 
> Was this intentionally?

No :(, it has slipped through at some stage. I was aware of that, I
found it some days ago. The problem is that if we fix that we could
break backward compatibility for 2.6.14, so I'm still thinking about how
to fix it.

-- 
Pablo
