From: Patrick McHardy <kaber@trash.net>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Thu, 15 Jan 2004 03:15:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4005F7D6.5080402@trash.net>
References: <Pine.LNX.4.44.0401150128190.4927-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401150128190.4927-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> I.e. why not use something like the following to find the source address 
> in MASQUERADE:
> 
>     ((struct rtable*)skb->dst)->rt_src

AFAICS in case of a input routed packet rt_src is the source ip of the
packet.

Best regards,
Patrick


> 
> Only worry is if there is POSTROUTING cases where skb->dst is not an
> rtable (superset of dst_entry).
> 
> Regards
> Henrik
> 
