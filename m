From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
Date: Wed, 18 Jul 2007 02:39:23 -0700 (PDT)
Message-ID: <20070718.023923.124552237.davem@davemloft.net>
References: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@lists.netfilter.org,
	linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	jengelh@linux01.gwdg.de
To: cornelia.huck@de.ibm.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
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

From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Mon, 16 Jul 2007 12:53:52 +0200

> Subject: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> To: <linux-netdev@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>, netfilter-devel@lists.netfilter.org,
>         "David S. Miller" <davem@davemloft.net>,
>         Jan Engelhardt <jengelh@linux01.gwdg.de>,
>         Patrick McHardy <kaber@trash.net>
> Date: Mon, 16 Jul 2007 12:53:52 +0200
> X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
> Organization: IBM Deutschland Entwicklung GmbH
> 
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
