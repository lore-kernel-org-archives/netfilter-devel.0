From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Netfilter/IPVS fixes for net
Date: Wed, 13 Feb 2019 16:15:03 -0800 (PST)
Message-ID: <20190213.161503.1495015240575901084.davem@davemloft.net>
References: <20190213174758.17275-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213174758.17275-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 13 Feb 2019 18:47:55 +0100

> The following patchset contains Netfilter/IPVS fixes for net:
> 
> 1) Missing structure initialization in ebtables causes splat with
>    32-bit user level on a 64-bit kernel, from Francesco Ruggeri.
> 
> 2) Missing dependency on nf_defrag in IPVS IPv6 codebase, from
>    Andrea Claudi.
> 
> 3) Fix possible use-after-free from release path of target extensions.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
