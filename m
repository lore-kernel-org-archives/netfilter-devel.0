From: Amin Azez <azez@ufomechanic.net>
Subject: Re: development with queues
Date: Thu, 20 Apr 2006 10:44:55 +0100
Message-ID: <44475817.70100@ufomechanic.net>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>	<859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
	<a1f5b31e0604181231x69124db5qd6345d544cea9e44@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: miguel Angel Vazquez <mikinho21@gmail.com>
In-Reply-To: <a1f5b31e0604181231x69124db5qd6345d544cea9e44@mail.gmail.com>
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

James D. Nurmi wrote:
> It is indeed possible, as I've done it (but unfort cant release the
> code),  but you have to remember a few things while doing it:
> 
> 1) Performance, not a big deal w/ modern hardware and 100Mbps, but you
> will see a huge hit at Gbit speeds
> 2) You're going to be munging TCP on the fly, which requires you to
> change sequence numbers, as well as adjust the incoming ack's,
> otherwise you'll end up with odd retransmits.
> 3) If you're going for an adequate solution, you can probably work on
> single packets, and just delete what you need, but for a real
> solution, you may not be able to make a full determination on the data
> without queing up multiple packets, which in turn, requires a larger
> queue for nfnetlink_queue;
> 4)  Read TCP spec, it's got a few niggling details that you might not
> notice, like syn/fin getting incremented.
> 
> Anyhow, if you need some pointers, let me know off list, as it _is_
> possible, incredibly interesting, but certainly non-trivial.

I would echo James comment on the difficulties involved, and you suggest 
you look at the ftp NAT helper, as it has to add or remove bytes in an 
ftp command stream when it fixes up the port number for non-passive ftp.

I have seen an application protocol where packet data boundaries were 
significant, although I don't believe http has this problem; the 
suggestion for the general case would be to not combine packets; even 
though this is what ssh port forwarding does anyway...

As a special case for this problem you may prefer to use ipt_redirect 
and handle the http connection in a local http proxy (a la squid) where 
you can play with the headers to your hearts content and still recover 
the original target ip address for when you make the proxied connection. 
(Too many "transparent" proxies miss out that step and rely on the http 
host header, idiots!)

Further advantages would be that you will have split the connection into 
to parts, with reduced end-to-end packet latency which could be 
significant in cases of packet loss, as only one segment of the path 
needs to re-transmit. It would also de-fragment packets and possibly 
combine small packets in cases where the next segment was a bottle-neck 
thus reducing per-packet overhead in cases where this is needed.

You might also be able to apply gzip compression to the http response if 
the upstream server did not do this, greatly reducing downstream traffic 
in many cases.

To my mind (and without knowing your entire situation) the advantages 
and the ease of ipt_redirect and an http (non-caching) proxy far 
outweigh the coolness of doing it with NF_QUEUE

Sam
