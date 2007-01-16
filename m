From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: fix xt_state compile failure
Date: Mon, 15 Jan 2007 17:16:39 -0800 (PST)
Message-ID: <20070115.171639.78713967.davem@davemloft.net>
References: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
	<20070115092253.22775.93499.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20070115092253.22775.93499.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 15 Jan 2007 10:22:54 +0100 (MET)

> [NETFILTER]: fix xt_state compile failure
> 
> In file included from net/netfilter/xt_state.c:13:
> include/net/netfilter/nf_conntrack_compat.h: In function 'nf_ct_l3proto_try_module_get':
> include/net/netfilter/nf_conntrack_compat.h:70: error: 'PF_INET' undeclared (first use in this function)
> include/net/netfilter/nf_conntrack_compat.h:70: error: (Each undeclared identifier is reported only once
> include/net/netfilter/nf_conntrack_compat.h:70: error: for each function it appears in.)
> include/net/netfilter/nf_conntrack_compat.h:71: warning: control reaches end of non-void function
> make[2]: *** [net/netfilter/xt_state.o] Error 1
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2
> 
> A simple fix is to have nf_conntrack_compat.h #include <linux/socket.h>.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
