From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] 2.6.20-rc6-git2: error: 'struct nf_conn' has no member
 named 'mark'
Date: Fri, 02 Feb 2007 14:38:30 +0100
Message-ID: <45C33ED6.1070108@trash.net>
References: <20070131103351.GA7248@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070131103351.GA7248@roonstrasse.net>
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

Max Kellermann wrote:
> Hi,
> 
> on 2.6.20-rc6-git2, compilation fails when CONFIG_NF_CONNTRACK_MARK is
> not enabled:
> 
>   CC      net/netfilter/nf_conntrack_netlink.o
> net/netfilter/nf_conntrack_netlink.c: In function
> 'ctnetlink_conntrack_event':
> net/netfilter/nf_conntrack_netlink.c:392: error: 'struct nf_conn' has
> no member named 'mark'
> make[3]: *** [net/netfilter/nf_conntrack_netlink.o] Error 1
> 
> My patch adds the proper #ifdef.

Applied and fixed ip_conntrack_netlink as well, thanks.
But please remember to sign off your patches.
