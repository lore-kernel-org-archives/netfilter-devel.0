From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] x_tables: unify IPv4/IPv6 multiport match
Date: Fri, 24 Mar 2006 17:22:12 +0100
Message-ID: <44241CB4.1030108@trash.net>
References: <200603240626.k2O6Qwr5015882@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200603240626.k2O6Qwr5015882@toshiba.co.jp>
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
> [NETFILTER] x_tables: unify IPv4/IPv6 multiport match
> 
> This unifies ipt_multiport and ip6t_multiport to xt_multiport.
> As a result, this addes support for inversion and port range match
> to IPv6 packets.

I see it also restores the checks for IPv4 which got lost when
revisioning support was introduced. Both patches applied, thanks
Yasuyuki.
