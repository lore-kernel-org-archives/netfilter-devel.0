From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][NETFILTER]: ip6_tables: fixed conflicted optname for
	getsockopt
Date: Fri, 03 Nov 2006 11:13:50 +0100
Message-ID: <454B165E.6080305@trash.net>
References: <200610311210.k9VCAmsu003163@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200610311210.k9VCAmsu003163@toshiba.co.jp>
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
> Hi all,
> 
> I've noticed that 66 and 67 for getsockopt on IPv6 socket are doubly used
> by IPv6 Advanced API and Netfilter ip6tables.
>
> The following patch changes numbers for Netfilter to 68 and 69.
> That doesn't change the behavior of old userland binary.
> 
> What do you think ?
> 
> In detail:
> 
> These numbers are defined in include/linux/in6.h and
> include/linux/netfilter_ipv6/ip6_tables.h
> (via include/linux/netfilter/x_tables).
> 
> 66:	IPV6_RECVTCLASS and IP6T_GET_REVISION_MATCH
> 67:	IPV6_TCLASS     and IP6T_GET_REVISION_TARGET
> 
> The current kernel always calls functions of Advanced API for them,
> and return 0 which means success for IP6T_GET_REVISION_{MATCH,TARGET}.
> Then userland tool might believe that newer revision of match/target is
> supported.
> 
> Currently I cannot see big problem on this because userland tools can
> use newer revision in kernel anyway. But clearly they should be fixed.

It might be a problem with binaries compiled against the new definitions
running with old kernels, they can't detect supported revisions anymore.
But we currently don't support revisions in ip6tables userspace anyway
unless I'm missing something.

> The following patch changes numbers for Netfilter to 68 and 69.
> An other possible solution is to distinguish them by something like
> optlen of getsockopt argument, but I'm not sure this is best.

I prefer this patch unless we break something badly. Do you want me
to apply it?
