From: Davide Guerri <tato.net@tin.it>
Subject: Re: nf_conntrack
Date: Sun, 22 Feb 2004 11:10:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402221110.28339.tato.net@tin.it>
References: <200402200942.13265.tato.net@tin.it> <200402201258.VAA29529@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200402201258.VAA29529@toshiba.co.jp>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 20 February 2004 13:58, you wrote:
> Hi,
>
> From: Davide Guerri <tato.net@tin.it>
> Date: Fri, 20 Feb 2004 09:42:13 +0100
>
> > Hi, and sorry for my poor English.
>
> Don't worry. me too.
>
> > I'm very interested in this project since I'm writing a NA(P)T-PT (as
> > described in RFC 2766) implementation for Linux. Actually I'm a student
> > (computer science, in Rome) and this will be my PhD thesis.
>
> Great.
>
> > What happened to your code? I've downloaded USAGI Linux kernel, but I've
> > found only your previous IPv6 conntrack. (very good work however!)
>
> nf_conntrack is not in USAGI linux26. Of cause, I'll commit it to USAGI
> tree.
>
> After I sent nf_conntrack, Mr. Harald Welte, who is a member of Netfilter
> Core Team, suggested that L3 part of conntrack (tuple, too) should be
> allocated dynamically.
>
> Then I wrote "dynamic version" and sent it last year (December), but I
> suspend this work due to other work for a while. Fortunately, I could
> resume to this work. I'll evaluate 2 implementations, and decide which
> implementation is adopted.
>
> After that, I'll commit nf_conntrack to USAGI tree.

That's a great news.
I've tryed the second version of your nf_conntrack. It seems to work very 
well!

> > Is there some documentation on conntrack? I'm reading the existing NAT
> > code, but it's quite difficult to understand. It's difficult for me
> > because I don't yet completely understand the general behaviour of
> > netfilter conntrack and the role of its tricky data structures.
>
> Unfortunately, there isn't documentation about nf_conntrack.
> But its scheme is mostly same as ip_conntrack. The differences are tuple,
> new functions and arguments for Layer 3 header handling, and new module
> for Layer 3 protocols.
>
> BTW, do you read Documentations at Netfilter Project web page ?
>
> 	http://www.netfilter.org/documentation/index.html
>
> "Netfilter Hacking HOWTO" may help you.

In the (very good) "Netfilter Hacking HOWTO" there are some infos on NAT, but 
I would need more detail.
However there is no problem, I'll study the netfilter code. ;)

> > I've also downloaded the nf_conntrack patch included in your post on
> > netfilter-devel, I've applied it to a vanilla 2.6.0 Kernel and I'm going
> > to try it. Prior to read that code, I would ask you if it can handle
> > mixed IPv6-IPv4 tuples.
>
> Thank you for using nf_conntrack. But you cannot handle mixed tuples
> (ex. src = IPv6, dst = IPv4) in now.

Sorry, I've expressed myself badly! What I need is to change the expected 
reply of the conntrack from an IPv4 tuple to an IPv6 tuple and vice versa. 
Hence what I would to know is if nf_conntrack can handles original-direction 
tuples of one type and reply-direction tuple of the other type (so that it 
will be possible to track a "NA(P)T-PT'ed connection").

> You need to write NA(P)T-PT code based on nf_conntrack. Maybe IPv4 NAT
> codes help you. The biggest issue is how pass packets from IPv4 stack to
> IPv6 stack and vice versa. I imagine that addresses in packets are mangled
> at only NF_IP{6}_PRE_ROUNTING, and then called netif_rx().

That was my first idea. But I've seen some code that makes use 
ip_route_me_harder() + ip_output() for injecting IPv4 packets, and 
ip6_route_me_harder() + ip6_output for IPv6 packets.
I fear that with netif_rx() traslated packet would be tracked again, and this 
is not what I need. (I'm sorry but I'm still studying netfilter and conntrack 
(and English too ;) ) so it's likely that I'm wrong).

> BTW, if allowed, could you Cc to netfilter-devel for other folks who
> interested in this area ?

I've just done it ;)

> Regards,
>
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

Thank you very much Yasuyuki for your work and for your quick reply!

Best regards,
Davide Guerri.

-- 
T@1t
