From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Move tcp_adjust to generic layer
Date: Wed, 09 Mar 2005 01:38:41 +0100
Message-ID: <422E4591.7080805@trash.net>
References: <422B86D6.8040905@eurodev.net> <422B8D98.3000501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <422B8D98.3000501@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>> Hi Patrick,
>>
>> This patch moves tcp_adjust to a generic layer. I sent something 
>> similar some time ago but it seems that it got lost.
> 
> 
> IIRC the argument against this patch was that it is entirely specific
> to TCP. Can't we simply move it all to TCP's manip_pkt() function ?

Thinking about it, this would also allow to solve a differnt issue
nicely. TCP packets contained in ICMP errors don't have their
sequence numbers adjusted backwards, theoretically this can cause
them to be discarded by the receipient. It would require an additional
argument to manip_pkt, for ICMP packets we can't simply apply the
adjustment of the reverse direction, but need to apply it inversely.
Perhaps it can also be deduced from iphdroff and skb->nh.iph.
What do you think ?

Regards
Patrick
