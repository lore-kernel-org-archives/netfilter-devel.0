From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH] nft: Header inclusion missing
Date: Thu, 3 Oct 2013 15:00:28 +0200
Message-ID: <20131003130028.GB17594@localhost>
References: <1380800362-11290-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3JCNAd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:00:33 -0400
Content-Disposition: inline
In-Reply-To: <1380800362-11290-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 02:39:22PM +0300, Tomasz Bursztyka wrote:
> Fixes:
> nft-shared.c: In function =E2=80=98nft_ipv46_rule_find=E2=80=99:
> nft-shared.c:725:2: warning: implicit declaration of function =E2=80=98=
nft_rule_print_save=E2=80=99 [-Wimplicit-function-declaration]
> nft-shared.c:725:32: error: =E2=80=98NFT_RULE_APPEND=E2=80=99 undecla=
red (first use in this function)
> nft-shared.c:725:32: note: each undeclared identifier is reported onl=
y once for each function it appears in

Also applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
