From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: when/how is the packet forwarded?
Date: Fri, 21 Nov 2003 13:10:49 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031121211049.70734.qmail@web60710.mail.yahoo.com>
References: <20031121151157.5f78a5c8.pcingola@uolsinectis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031121151157.5f78a5c8.pcingola@uolsinectis.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> I'm not an expert 
    NP, the important thing is that you are willing to
help. Thanks.

> but I think you should change 
> sk_buff's route entry, may be using something like:
> 
>        if( ip_route_me_harder( skb ) ) {
> 		printk("Error routing\n");
>             return NF_DROP;
>         }

   Not only did i do that but also changed the saddr.
Here is the new code for my NF_IP_PRE_ROUTING hook:
 
  struct iphdr *ip;
  __u8 ourip[] = {203, 175, 73, 128}; // my IP on ppp0
  __u8 otherip[] = {203, 175, 73, 239};

  ip = (*skb)->nh.iph;

  if (strcmp (in->name, "lo") == 0) {
    memcpy (&(ip->saddr), ourip, 4);
    memcpy (&(ip->daddr), otherip, 4);
    (*skb)->nfcache |= NFC_ALTERED;

    if (ip_route_me_harder (skb)) {
 	printk ("Error routing\n");
        return NF_DROP;
    }

    else {
 	printk ("altered & routed\n");
    }
  }

  return NF_ACCEPT;

   OK, Now atleast the packet is not going into the
hands of NF_IP_LOCAL_IN hook but its still not being
given to my NF_IP_FORWARD hook. dmesg |tail does'nt
show any routing error but the "altered & routed\n".
Any clue? Thanks again. Bye.

__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
