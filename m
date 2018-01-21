From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/32] Netfilter/IPVS updates for net-next
Date: Sun, 21 Jan 2018 12:08:26 -0500 (EST)
Message-ID: <20180121.120826.509070241425880764.davem@davemloft.net>
References: <20180119191041.25804-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 19 Jan 2018 20:10:09 +0100

> The following patchset contains Netfilter/IPVS updates for your net-next
> tree. Basically, a new extension for ip6tables, simplification work of
> nf_tables that saves us 500 LoC, allow raw table registration before
> defragmentation, conversion of the SNMP helper to use the ASN.1 code
> generator, unique 64-bit handle for all nf_tables objects and fixes to
> address fallout from previous nf-next batch.  More specifically, they
> are:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
