From: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: adding data fields to netfilter_conntrack / conntrack events
Date: Wed, 23 Aug 2006 14:47:06 +0200
Message-ID: <echin1$ark$1@sea.gmane.org>
References: <34ABBC54-DD57-407D-86CF-C4FB5FB24AEA@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <34ABBC54-DD57-407D-86CF-C4FB5FB24AEA@presinet.com>
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

On 23-08-2006 00:41, Stuart Zilm wrote:
> I'm trying to add some more data to that which gets passed across the 
> netlink socket for conntrack events, but can't seem to get the data from 
> the kernel to arrive in userspace.
> 
> I've added the following to net/ipv4/netfilter/ip_conntrack_netlink.c:
> 
> static inline int
> ctnetlink_dump_foo(struct sk_buff *skb, const struct ip_conntrack *ct)
> {
>     char dummy[sizeof(struct timeval)] = {0xde, 0xad, 0xde, 0xad, 0xde, 
> 0xad, 0xde, 0xad};
> 
>     NFA_PUT(skb, CTA_FOO, sizeof(struct timeval), dummy);
>     
>     return 0;
> 
> nfattr_failure:
>         printk("<6>ctnetlink_dump_foo: nfattr_failure\n");
>         return -1;
> }
> 
> // note that CTA_FOO = 13

I didn't check this but: did you see this change status 
function's processing with CTA_NAT_DST (13)?

Jarek P.
