From: Patrick McHardy <kaber@trash.net>
Subject: Re: tcpmss match for IPv6 ?
Date: Fri, 13 Jul 2007 15:13:23 +0200
Message-ID: <46977A73.5040200@trash.net>
References: <4696A0C6.6040905@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4696A0C6.6040905@plouf.fr.eu.org>
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

Pascal Hambourg wrote:
> Hello,
> 
> I hope this is the right list for my question.
> Support of the TCPMSS target for IPv6 was recently added in the kernel
> and ip6tables. It can help fixing some MTU blackhole issues, so thanks.
> However there is currently no support of the tcpmss match for IPv6 yet,
> although xt_tcpmss.c in the kernel seems to be IPv6 compatible.
> 
> Has anyone already submitted a patch to add support for an IPv6 tcpmss
> match in ip6tables ? It seems trivial to derive from the existing IPv4
> tcpmss match for iptables. I believe I could even do it although I am
> not a software developper and don't know how to submit a patch.


The latest iptables release should contain an IPv6 capable TCPMSS target.
