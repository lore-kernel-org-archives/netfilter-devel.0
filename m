From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc4-mm1
Date: Mon, 20 Feb 2006 15:11:36 +0100
Message-ID: <43F9CE18.10709@trash.net>
References: <20060220042615.5af1bddc.akpm@osdl.org> <43F9BDDA.1060508@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, dccp@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964930AbWBTOLj@vger.kernel.org>
To: Reuben Farrelly <reuben-lkml@reub.net>
In-Reply-To: <43F9BDDA.1060508@reub.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Reuben Farrelly wrote:
> Minor dependency issue:
> 
> My compile failed with this..
> 
>   CC [M]  net/netfilter/xt_dccp.o
> In file included from net/netfilter/xt_dccp.c:15:
> include/linux/dccp.h:341:2: error: #error "At least one CCID must be
> built as the default"
> make[2]: *** [net/netfilter/xt_dccp.o] Error 1
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2
> [root@tornado linux-2.6-mm]#
> 
> [I have no idea what a CCID is]
> 
> But it was caused by this:
> 
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> 
> and maybe this below had an impact:
> 
> #
> # DCCP Configuration (EXPERIMENTAL)
> #
> # CONFIG_IP_DCCP is not set
> 
> After unsetting the option to build the DCCP Netfilter module, I was
> able to compile through to completion.

Ideally this dependency should be enforced by Kconfig. I'm not sure
if it is possible to express something like "IP_DCCP_CCID2 and
IP_DCCP_CCID3 depend on DCCP, DCCP requires at least one of both
to be enabled". Can someone more familiar with Kconfig than me
comment on this? Otherwise the #error should be moved to
net/dccp/options.c to keep dccp.h usable without dccp enabled.
