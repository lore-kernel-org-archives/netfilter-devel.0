From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipv6 conntrack status?
Date: Sat, 04 Mar 2006 10:03:56 +0100
Message-ID: <440957FC.6050506@trash.net>
References: <20060225111316.GA13280@mx.ytti.net>	<200603021741.k22Hf8Hr013260@toshiba.co.jp>
	<20060302175854.GA741@mx.ytti.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Saku Ytti <saku@ytti.fi>
In-Reply-To: <20060302175854.GA741@mx.ytti.net>
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

Saku Ytti wrote:
> On (2006-03-03 02:41 +0900), Yasuyuki KOZAKAI wrote:
> 
> 
>>You can use nf_conntrack_ipv6 in mainline kernel, not ip6_conntrack.
>>To build it, please disable IP_NF_CONNTRACK, enable NF_CONNTRACK and
>>NF_CONNTRACK_IPV6. NF_CONNTRACK is in the menu "Core Netfilter Configuration",
>>and NF_CONNTRACK_IPV6 in the menu "IPv6: Netfilter Configuration
>>(EXPERIMENTAL)".
> 
> 
> Indeed menuconfig hides the new conntrack if old one is chosen,
> as was my case.

Maybe we can find a better way to choose between the two conntrack
implementations. Right now its really confusing, IP_NF_CONNTRACK
hides NF_CONNTRACK, but if NF_CONNTRACK is selected I can still
choose IP_NF_CONNTRACK even though it won't work. Maybe a
"choice" option?
