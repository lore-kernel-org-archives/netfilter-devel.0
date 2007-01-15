From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20-rc5] netfilter: xt_state compile failure
Date: Mon, 15 Jan 2007 09:31:22 +0100
Message-ID: <45AB3BDA.6050300@trash.net>
References: <17835.13603.658813.332230@alkaid.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932096AbXAOIbZ@vger.kernel.org>
To: Mikael Pettersson <mikpe@it.uu.se>
In-Reply-To: <17835.13603.658813.332230@alkaid.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mikael Pettersson wrote:
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

Applied, thanks Mikael.
