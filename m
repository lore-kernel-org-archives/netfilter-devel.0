From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Tue, 28 Oct 2003 11:09:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9E406C.7050105@trash.net>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se> <3F9E292C.3020509@trash.net> <3F9E3E6C.C0CC5598@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
In-Reply-To: <3F9E3E6C.C0CC5598@fy.chalmers.se>
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

>As already mentioned in my last letter, note that 4th packet in
>fast.tcpdump is *not* actual wire traffic. On the wire [e.g. on server
>side] I see *two* packets with 1460 and 540 \n's as TCP payload.
>
>  
>
Sorry I forgot about this earlier, can you make the dumps again on
both sides of the firewall ? If possible sync the clocks of both
boxes so times are comparable.


>In either case it apparently has something[/everything?] to do with
>ip_refrag in ip_conntrack_standalone.c. At least if I comment out the
>"if ((*pskb)->len > dst_pmtu(&rt->u.dst)) { ... }" statement in this
>function, './head.pl some.host 2000' completes instantly even if I
>insmod the patched module. A.
>

Yes these lines are suspect nr. 1 ;) I wonder however how it keeps
working without refragmentation, this implies it's not necessary to
refragment here as the stack will do it anyways ..

Best regards,
Patrick
