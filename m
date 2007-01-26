From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Fri, 26 Jan 2007 15:26:06 +0100
Message-ID: <45BA0F7E.70206@trash.net>
References: <200701260953.l0Q9rvV8006278@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200701260953.l0Q9rvV8006278@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi, Patrick and all,
> 
> This introduces match for Mobility Header (MH) described by Mobile IPv6
> specification (RFC3775). User can specify the MH type or its range to be
> matched.
> 
> MH is defined as extention header in RFC3775, but this patch handles it
> as layer 4 protocol header like ICMPv6 header.
> 
> The reasons are
> - The reason why it's defined as extentin header is mainly for
>   'piggy back'. But that feature was not specified in RFC3775 after all.
> - No header follow MH. RFC3775 says
> 	Implementations conforming to this specification SHOULD set
> 	the payload protocol type to IPPROTO_NONE (59 decimal).  
> - Many parts in RFCs assume that it's like layer 4 protocol header.
> - Actually Linux IPv6 stack, XFRM, setkey, iproute2... handle it as if
>   it's layer4 protocol.
> 
> So we concludes people expect to do 'ip6tables -p mh ...', not
> 'ip6tables -m mh ...'.
> 
> Please consider to apply this. If no objection, I'll commit
> attached the patch for ip6tables as well.

Looks good, I've queued it for 2.6.21. Thanks.
