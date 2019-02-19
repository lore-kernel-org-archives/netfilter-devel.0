From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Netfilter/IPVS fixes for net
Date: Mon, 18 Feb 2019 17:56:46 -0800 (PST)
Message-ID: <20190218.175646.1731967864749489486.davem@davemloft.net>
References: <20190218230823.8114-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190218230823.8114-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 19 Feb 2019 00:08:21 +0100

> The following patchset contains Netfilter/IPVS fixes for net:
> 
> 1) Follow up patch to fix a compilation warning in a recent IPVS fix:
>    098e13f5b21d ("ipvs: fix dependency on nf_defrag_ipv6").
> 
> 2) Bogus ENOENT error on flush after rule deletion in the same batch,
>    reported by Phil Sutter.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Series applied, thanks.
