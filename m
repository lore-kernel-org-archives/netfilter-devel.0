From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/7] Netfilter/IPVS fixes for net
Date: Mon, 28 Jan 2019 10:52:07 -0800 (PST)
Message-ID: <20190128.105207.1557362159767695959.davem@davemloft.net>
References: <20190128140405.15020-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128140405.15020-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 28 Jan 2019 15:03:58 +0100

> The following patchset contains Netfilter/IPVS fixes for your net tree:
> 
> 1) The nftnl mutex is now per-netns, therefore use reference counter
>    for matches and targets to deal with concurrent updates from netns.
>    Moreover, place extensions in a pernet list. Patches from Florian Westphal.
> 
> 2) Bail out with EINVAL in case of negative timeouts via setsockopt()
>    through ip_vs_set_timeout(), from ZhangXiaoxu.
> 
> 3) Spurious EINVAL on ebtables 32bit binary with 64bit kernel, also
>    from Florian.
> 
> 4) Reset TCP option header parser in case of fingerprint mismatch,
>    otherwise follow up overlapping fingerprint definitions including
>    TCP options do not work, from Fernando Fernandez Mancera.
> 
> 5) Compilation warning in ipt_CLUSTER with CONFIG_PROC_FS unset.
>    From Anders Roxell.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
