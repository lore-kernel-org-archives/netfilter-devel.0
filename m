From: Patrick McHardy <kaber@trash.net>
Subject: Re: problems with netlink_broadcast
Date: Tue, 13 Jan 2004 18:03:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400424F7.9040508@trash.net>
References: <4003DCD7.6040602@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
In-Reply-To: <4003DCD7.6040602@fokus.fraunhofer.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Are you using GFP_ATOMIC for netlink_broadcast and alloc_skb ?

Regards,
Patrick

John Williams Floroiu wrote:
> 
> hi,
> 
> I am trying to send data to userspace from a kernel module each time a 
> kernel timer expires. so I basically call
> skb_alloc followed by netlink_broadcast.
> 
> the funny part is that if I call netlink_broadcast from the timer 
> handler (which, according to my understanding, is a
> softirq), I get a crash. on the other hand, if I dispatch a tasklet from 
> the timer handler and call skb_alloc from the
> tasklet, then I get a crash too.
> 
> the only combination that appears to work is calling skb_alloc in the 
> timer handler (pass 'skb' to the tasklet) and
> netlink_broadcast from the tasklet. this looks quite strange to me 
> because ipt_ULOG and other kernel modules doing
> similar things don't appear to hint at the existence of such 
> restrictions. could anybody figure out what could be wrong?
> 
> thanks in advance.
> 
> cheers,
> John.
> 
