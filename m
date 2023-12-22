Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1971426C;
	Fri, 22 Dec 2023 10:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.43.141] (port=43930 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rGd5c-005cXN-IK; Fri, 22 Dec 2023 11:49:14 +0100
Date: Fri, 22 Dec 2023 11:49:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net 0/2] Netfilter fixes for net
Message-ID: <ZYVppydK2qxJz9lc@calendula>
References: <20231222104205.354606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231222104205.354606-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Fri, Dec 22, 2023 at 11:42:03AM +0100, Pablo Neira Ayuso wrote:
> [ resent, apparently this was only posted to netfilter-devel@vger.kernel.org,
>   not to netdev@vger.kernel.org ]

For the record, previous is still in patchwork:

https://patchwork.kernel.org/project/netdevbpf/patch/20231220151544.270214-1-pablo@netfilter.org/

> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Skip set commit for deleted/destroyed sets, this might trigger
>    double deactivation of expired elements.
> 
> 2) Fix packet mangling from egress, set transport offset from
>    mac header for netdev/egress.
> 
> Both fixes address bugs already present in several releases.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-12-20
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 8353c2abc02cf8302d5e6177b706c1879e7b833c:
> 
>   Merge branch 'check-vlan-filter-feature-in-vlan_vids_add_by_dev-and-vlan_vids_del_by_dev' (2023-12-19 13:13:59 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-12-20
> 
> for you to fetch changes up to 7315dc1e122c85ffdfc8defffbb8f8b616c2eb1a:
> 
>   netfilter: nf_tables: skip set commit for deleted/destroyed sets (2023-12-20 13:48:00 +0100)
> 
> ----------------------------------------------------------------
> netfilter pull request 23-12-20
> 
> ----------------------------------------------------------------
> Pablo Neira Ayuso (2):
>       netfilter: nf_tables: set transport offset from mac header for netdev/egress
>       netfilter: nf_tables: skip set commit for deleted/destroyed sets
> 
>  include/net/netfilter/nf_tables_ipv4.h | 2 +-
>  net/netfilter/nf_tables_api.c          | 2 +-
>  net/netfilter/nf_tables_core.c         | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
