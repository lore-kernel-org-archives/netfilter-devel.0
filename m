From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
Date: Tue, 17 Jul 2007 17:07:12 +0200
Message-ID: <469CDB20.8090806@trash.net>
References: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934001AbXGQPHe@vger.kernel.org>
In-Reply-To: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cornelia Huck wrote:
> With NF_CONNTRACK=n, NETFILTER_XT_MATCH_CONNLIMIT=m I get the
> following errors on current git:
> 
>   CC [M]  net/netfilter/xt_connlimit.o
>   In file included from net/netfilter/xt_connlimit.c:27:
>   include/net/netfilter/nf_conntrack.h:100: error: field 'ct_general' has incomplete type
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>   include/net/netfilter/nf_conntrack.h:164: error: 'const struct sk_buff' has no member named 'nfct'
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
>   include/net/netfilter/nf_conntrack.h:171: warning: implicit declaration of function 'nf_conntrack_put'
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_is_untracked':
>   include/net/netfilter/nf_conntrack.h:253: error: 'const struct sk_buff' has no member named 'nfct'
>   In file included from net/netfilter/xt_connlimit.c:28:
>   include/net/netfilter/nf_conntrack_core.h: In function 'nf_conntrack_confirm':
>   include/net/netfilter/nf_conntrack_core.h:68: error: 'struct sk_buff' has no member named 'nfct'
> 
> Adding a dependency in Kconfig fixes this.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Applied, thanks.
