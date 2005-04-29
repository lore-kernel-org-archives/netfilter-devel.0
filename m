From: Amin Azez <azez@ufomechanic.net>
Subject: wow, why does everything presume ethernet? Re: skb->mac.raw, when
 is does it point to ethhdr
Date: Fri, 29 Apr 2005 16:54:39 +0100
Message-ID: <427258BF.7080405@ufomechanic.net>
References: <d4r2n4$o39$1@sea.gmane.org>
	<Pine.LNX.4.61.0504290113360.26003@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504290113360.26003@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> On Thu, 28 Apr 2005, Amin Azez wrote:
>
>> So the question comes up, how do we tell when skb->mac.raw is 
>> pointing to an ethernet frame header and when it is pointing to 
>> something else?
>
> IIRC You need to look at the link type of the device the packet came 
> from.

I was trying to do that but when I looked again after your hint I found 
it, thanks.

I notice most netfilter stuff that uses mac.raw seems to presume an 
ethernet link layer.

e.g.
net/ipv4/netfilter/ipt_mac.c - although it takes "in" and "out" devices 
as parameters it presumes ethernet:
static int
match(const struct sk_buff *skb,
const struct net_device *in,
const struct net_device *out,
const void *matchinfo,
int offset,
int *hotdrop)
{
const struct ipt_mac_info *info = matchinfo;

/* Is mac pointer valid? */
return (skb->mac.raw >= skb->head
&& (skb->mac.raw + ETH_HLEN) <= skb->data
/* If so, compare... */
&& ((memcmp(eth_hdr(skb)->h_source, info->srcaddr, ETH_ALEN)
== 0) ^ info->invert));
}

in net/bridge/br_stp_bpdu.c, br_send_bpdu has:
memcpy(skb->mac.raw, bridge_ula, ETH_ALEN);
memcpy(skb->mac.raw+ETH_ALEN, dev->dev_addr, ETH_ALEN);

are only ethernet bridges supported? I guess so... even the bluetooth 
stuff presumes ETH_ALEN
All I can say is "wow"


I was planning to do things "properly" and use skb->input_dev (or do I 
need skb->dev or skb->realdev?)

skb->input_dev->type
will refer (strangely to) one of the ARP types in linux/if_arp.h with me 
being interested in ARPHRD_ETHER among others.

Mac address length will be
skb->input_dev->addr_len

However, to get at a source mac address is still uncertain, maybe I need 
to dispatch to a different routine or different offsets based on 
input_dev->type ?
There doesn't seem to be a standard way to access mac addresses from 
link layer packets (arp stuff must know how to) which perhaps is why I 
can't find one, and everyone is doing what I did at first and presuming 
ethernet.

For ethernet, skb->mac.raw points to:
struct ethhdr {
unsigned char h_dest[ETH_ALEN]; /* destination eth addr */
unsigned char h_source[ETH_ALEN]; /* source ether addr */
unsigned short h_proto; /* packet type ID field */
} __attribute__((packed));

and the source address is had from 
(skb->mac.raw)+(skb->input_dev->addr_len), but does it follow that the 
same rules work for token ring or other network types. For ethernet it 
comes straight from the headers.

Does anyone know without looking how "ifconfig" works out how to format 
the mac address? (Not that it will help me work out what the source mac 
address is for a given skb, but I'm looking for how to generate a 
standard textual representation based on dev->addr_len and skb->mac.raw).

Amin
