From: Pablo Cingolani <pcingola@uolsinectis.com>
Subject: Re: when/how is the packet forwarded?
Date: Fri, 21 Nov 2003 15:11:57 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031121151157.5f78a5c8.pcingola@uolsinectis.com>
References: <20031120205611.69144.qmail@web60708.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Zeeshan Ali <zeelists@yahoo.com>
In-Reply-To: <20031120205611.69144.qmail@web60708.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



I'm not an expert but I think you should change 
sk_buff's route entry, may be using something like:

       if( ip_route_me_harder( skb ) ) {
		printk("Error routing\n");
            return NF_DROP;
        }

Yours 
   Pablo



On Thu, 20 Nov 2003 12:56:11 -0800 (PST)
Zeeshan Ali <zeelists@yahoo.com> wrote:

> Hello everyone,
>   I am having problem in understanding that when/how
> is the packet forwarded. I mean if i alter the daddr
> in the packets comming from eth0 to contain an addr
> that belongs to the network connected to another
> interface (e.g ppp0) in my NF_IP_PRE_ROUTING hook then
> should'nt this packet be next seen by my NF_IP_FORWARD
> hook instead of NF_IP_LOCAL_IN hook? I am attaching
> the source code with this email.
> 
> __________________________________
> Do you Yahoo!?
> Protect your identity with Yahoo! Mail AddressGuard
> http://antispam.yahoo.com/whatsnewfree
