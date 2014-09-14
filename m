From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/5] ipset: avoid duplicate command flags
Date: Sun, 14 Sep 2014 21:09:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409142108400.1020@blackhole.kfki.hu>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org> <20140908143038.16930.38790.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36085 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaINTIu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:08:50 -0400
In-Reply-To: <20140908143038.16930.38790.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 8 Sep 2014, Holger Eitzenberger wrote:

> NLM_F_DUMP is #defined as (NLM_F_ROOT | NLM_F_ACK), so specifying
> all of them is redundant.
> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> ---
>  lib/mnl.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/mnl.c b/lib/mnl.c
> index 786c9e5..a0fa66e 100644
> --- a/lib/mnl.c
> +++ b/lib/mnl.c
> @@ -38,10 +38,8 @@ static const uint16_t cmdflags[] = {
>  	[IPSET_CMD_FLUSH-1]	= NLM_F_REQUEST|NLM_F_ACK,
>  	[IPSET_CMD_RENAME-1]	= NLM_F_REQUEST|NLM_F_ACK,
>  	[IPSET_CMD_SWAP-1]	= NLM_F_REQUEST|NLM_F_ACK,
> -	[IPSET_CMD_LIST-1]	= NLM_F_REQUEST|NLM_F_ACK|
> -					NLM_F_ROOT|NLM_F_MATCH|NLM_F_DUMP,
> -	[IPSET_CMD_SAVE-1]	= NLM_F_REQUEST|NLM_F_ACK|
> -					NLM_F_ROOT|NLM_F_MATCH|NLM_F_DUMP,
> +	[IPSET_CMD_LIST-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
> +	[IPSET_CMD_SAVE-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
>  	[IPSET_CMD_ADD-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
>  	[IPSET_CMD_DEL-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
>  	[IPSET_CMD_TEST-1]	= NLM_F_REQUEST|NLM_F_ACK,
> 

Patch is applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
