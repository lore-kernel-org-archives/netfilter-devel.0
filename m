From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Sun, 26 Sep 2004 21:43:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41571BCC.2050909@trash.net>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net>
	<20040921171857.2c720c8e.davem@redhat.com>
	<4150D880.70108@trash.net>
	<20040924154032.5a0c32e1.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20040924154032.5a0c32e1.davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:

>I think the scheme is a bit illogical.
>
>Until the actual TCP socket lookup call, you cannot say for sure
>what that lookup would result in.
>
>For example, let's say that between where the ipt_owner match
>is invoked on input, and the actual call to tcp_v4_rcv(), some
>filtering or other packet mangling scheme changes the IP address
>or ports.  You're going to get different results in ipt_owner()
>than TCP was going to achieve.
>
>It sounds like we want some kind of socket resolution policy check.
>It's starting to get rediculious, as we have two filters _already_
>in that code path, one for the per-socket BPF style filtering, and
>the other for IPSEC.
>
>The IPSEC check is available on output too.
>  
>

It's mainly a problem if the socket is closed or replaced between the
lookup in ipt_owner and the lookup in tcp, for the other cases you
can define the semantic as: the socket that the packet would be
delivered to if the packet is not dropped and none of the keys used
for the lookup are altered.

>I don't see how it's avoidable to add another condition there.
>So what if we had something like:
>
>	NF_SK_HOOK(PF_INET, NF_TCP_IN, sk, skb, skb->dev, NULL,
>		   tcp_v4_rcv_finish)
>
>or something along those lines?  Perhaps you can simplify the
>argument set even further.
>  
>
Unfortunately I have to agree with you, another set of hooks looks
like the only way to solve the race. Let me think some more about
the implications for iptables and ip_conntrack.

Regards
Patrick
