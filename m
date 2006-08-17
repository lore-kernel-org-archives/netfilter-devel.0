From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Boyer Moore textsearch bug fix
Date: Thu, 17 Aug 2006 15:39:14 +0200
Message-ID: <44E47182.7010901@trash.net>
References: <20060817031607.GA7484@minastirith>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.org>
In-Reply-To: <20060817031607.GA7484@minastirith>
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

Michael Rash wrote:
> --- linux-2.6.17.8/lib/ts_bm.c.orig	2006-08-16 21:17:38.000000000 -0400
> +++ linux-2.6.17.8/lib/ts_bm.c	2006-08-16 21:17:56.000000000 -0400
> @@ -151,8 +151,8 @@
>  	bm = ts_config_priv(conf);
>  	bm->patlen = len;
>  	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
> -	compute_prefix_tbl(bm, pattern, len);
>  	memcpy(bm->pattern, pattern, len);
> +	compute_prefix_tbl(bm, pattern, len);


Good catch, thanks. But since both pattern and len are also passed
to compute_prefix_tbl as arguments, I think we should either make
it use only those arguments, or remove those arguments and use only
the values from struct ts_bm.

Please send a new patch and add a Signed-off-by line so I can
apply it. Thanks.
