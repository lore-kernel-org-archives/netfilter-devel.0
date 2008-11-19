From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] state: report spaces in the state list parsing
Date: Wed, 19 Nov 2008 10:29:23 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811191029090.30388@fbirervta.pbzchgretzou.qr>
References: <20081118234311.15750.80335.stgit@Decadence> <20081118234336.15750.52780.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46623 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbYKSJ3Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:29:24 -0500
In-Reply-To: <20081118234336.15750.52780.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-19 00:43, Pablo Neira Ayuso wrote:

>Now this returns:
>
>iptables v1.4.2-rc1: `--state' requires a list of states with no
>spaces, e.g. ESTABLISHED,RELATED
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>
> extensions/libxt_state.c |    5 ++++-
> 1 files changed, 4 insertions(+), 1 deletions(-)

This also needs to be done for libxt_conntrack.c I guess.
