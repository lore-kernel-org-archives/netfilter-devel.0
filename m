From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Tue, 28 Oct 2003 12:18:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9E506A.BD4BA635@fy.chalmers.se>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se> <3F9E292C.3020509@trash.net> <3F9E3E6C.C0CC5598@fy.chalmers.se> <3F9E406C.7050105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >As already mentioned in my last letter, note that 4th packet in
> >fast.tcpdump is *not* actual wire traffic. On the wire [e.g. on server
> >side] I see *two* packets with 1460 and 540 \n's as TCP payload.
> >
> Sorry I forgot about this earlier, can you make the dumps again on
> both sides of the firewall ?

Can't you take my word for it? See my last letter from yesterday, first
tcpdump snippet. You'll see that my server first ACKs 1460 bytes and
then 540 extra. This alone proves that server got 2000 bytes in two
packets, not one. But I can actually confirm that tcpdump does show two
packets on server. I see no meaning to waste public bandwidth on
attachment that does not actually add any extra information...

> >In either case it apparently has something[/everything?] to do with
> >ip_refrag in ip_conntrack_standalone.c. At least if I comment out the
> >"if ((*pskb)->len > dst_pmtu(&rt->u.dst)) { ... }" statement in this
> >function, './head.pl some.host 2000' completes instantly even if I
> >insmod the patched module. A.
> 
> Yes these lines are suspect nr. 1 ;) I wonder however how it keeps
> working without refragmentation, this implies it's not necessary to
> refragment here as the stack will do it anyways ..

Yes, it does [imply that]. But I rather wonder why did it assemble a TCP
packet larger than MTU in first place. But in either case it looks like
whomever who did that gives up after 3 seconds and generates two smaller
instead. Normally I would also complain that one would expect tcpdump to
show wire traffic even on the client side, but this is really bad
opportunity to do so, as we probably wouldn't land on ip_refrag so
soon:-) A.
