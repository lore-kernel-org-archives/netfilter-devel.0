From: Jonathan Wood <jonwood@speakeasy.net>
Subject: Re: netfilter6: ICMPv6 type 143 doesn't match
Date: Mon, 25 Apr 2005 11:09:17 -0700
Message-ID: <9b4f396a9c1c459fc8cbe349671c827e@speakeasy.net>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Has there been any progress on this issue? I am seeing it in 2.6.11.7,
and making the change suggested below fixes it for me.

Thanks

> On Sat, Jan 08, 2005 at 12:45:14PM +0100, Peter Bieringer wrote:
> > -               ptr = IPV6_HDR_LEN;
> > +               ptr = ((u8*)skb->nh.raw - skb->data) + IPV6_HDR_LEN;
> [...]
> > But it won't help :-((
>
> The following works for me on 2.6.8:
>
>                 ptr = ((char *) ipv6 - (char *) skb->data) + 
> IPV6_HDR_LEN;
>
> Older 2.6 kernels also do not call ipv6_skip_exthdr() in icmp6_match();
> more recent kernels fix this.
>
> Olaf
