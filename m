From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Tue, 28 Oct 2003 13:19:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9E5EE6.1090103@trash.net>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se> <3F9E292C.3020509@trash.net> <3F9E3E6C.C0CC5598@fy.chalmers.se> <3F9E406C.7050105@trash.net> <3F9E506A.BD4BA635@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
In-Reply-To: <3F9E506A.BD4BA635@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Andy Polyakov wrote:

>>Sorry I forgot about this earlier, can you make the dumps again on
>>both sides of the firewall ?
>>    
>>
>
>Can't you take my word for it? See my last letter from yesterday, first
>tcpdump snippet. You'll see that my server first ACKs 1460 bytes and
>then 540 extra. This alone proves that server got 2000 bytes in two
>packets, not one. But I can actually confirm that tcpdump does show two
>packets on server. I see no meaning to waste public bandwidth on
>attachment that does not actually add any extra information...
>
>  
>

Sure, it's not that I wouldn't believe you but I wanted to see if your
problems could be caused by de/refragmentation introducing higher rtt
variance and thus higher retransmit timeout, but after reading your
mails more carefully that seems really unlikely.


>Yes, it does [imply that]. But I rather wonder why did it assemble a TCP
>packet larger than MTU in first place. But in either case it looks like
>whomever who did that gives up after 3 seconds and generates two smaller
>instead. Normally I would also complain that one would expect tcpdump to
>show wire traffic even on the client side, but this is really bad
>opportunity to do so, as we probably wouldn't land on ip_refrag so
>soon:-) A.
>  
>

Yes you're right the stack should never generate tcp packets > mtu.

This is either a misconfiguration or a bug in TCP. I assume you
checked your configuration (btw: can you please post it ?) so we
need to find out why the stack generates these packets. Perhaps
you can check the pmtu by printing dst->pmtu in tcp_v4_connect
(rt->u.dst.pmtu). Unfortunately I'm busy ATM so I can't help
much right now.

Regards,
Patrick
