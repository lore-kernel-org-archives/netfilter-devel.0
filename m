From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
 services)
Date: Sun, 18 Apr 2004 01:49:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404180141470.24117-100000@filer.marasystems.com>
References: <40817D3E.3010202@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40817D3E.3010202@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, Friedrich Lobenstock wrote:

> What is the downside if that equation is not fullfilled by running
>    echo "xxxx" > /proc/sys/net/ipv4/ip_conntrack_max
> without setting the hashsize=yyyy parameter?

Overpopulated hash leading to poorer performance than if the hash size is 
tuned accordingly.

> > Depends a little on what conntrack & nat helpers etc you enabled when the
> > kernel is built. In my kernel each conntrack currently uses ca 384 bytes, 
> > most others probably use less..
> 
> Wouldn't it be good if ip_conntrack exports that size via /proc? Would help 
> the average user to estimate the influence of increasing ip_conntrack_max.

It isn't that hard to figure out how much memory conntrack is using by
reading the slab allocation statistics...

> > The amount of memory allocated based on the hash size is pretty marginal, 
> > what one needs to keep track of is the total number of connections as this 
> > is the bulk of the memory usage.
> 
> So the hash size also limits the amount of connections?

The hash size is only about performance.

The only down side of a oversized hash is somewhat greater memory usage
and a slight waste of cache space. The downside of a too small hash is 
higher CPU usage due to overly long hash chains. Nothing inherent to 
iptables but a general aspect of hashing.

The only thing limiting the amount of connections is ip_conntrack_max. 
This controls the maximum number of connections conntrack will track.

> > As for suggested defaults: If this is a general purpose server then the
> > automatic defaults. On a dedicated firewall scale the memory and conntrack
> > based on how many concurrent sessions you need to support but I would not
> > recommend to assign more than 50% of your memory to conntrack.
> 
> And why if I may ask? Management overhead, or what?

You do not want the kernel to run out of memory, and you want to be able 
to run some userspace processes..

> For example a machine with 1GB RAM router only, couldn't we assign eg. 
> 768MB to conntrack?

You could. And it would probably work.

> Another side question, can you add this information to the netfilter FAQ?

Probably. You are welcome to send an update. You have equal ability as me 
to update the FAQ.

Regards
Henrik
