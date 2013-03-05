From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfacct: correct regressions in v1.0.1
Date: Tue, 5 Mar 2013 14:59:43 +0100
Message-ID: <20130305135943.GA4369@localhost>
References: <5135E977.1000905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57438 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab3CEN7v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:59:51 -0500
Content-Disposition: inline
In-Reply-To: <5135E977.1000905@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 05, 2013 at 12:47:51PM +0000, Mr Dash Four wrote:
> This patch fixes regressions present in v1.0.1, introduced as a result of
> commit d17c772c98057b2cc0118274605d292809ff6b1e.
> 
> Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
> ---
>  src/nfacct.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/src/nfacct.c b/src/nfacct.c
> index 4ce817d..21d4df8 100644
> --- a/src/nfacct.c
> +++ b/src/nfacct.c
> @@ -218,7 +218,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
>  	return 0;
>  }
> 
> -static int _nfacct_cmd_add(char *name, int pkts, int bytes)
> +static int _nfacct_cmd_add(char *name,
> +			   long long unsigned pkts, long long unsigned bytes)

those are still signed, should be unsigned.

>  {
>  	struct mnl_socket *nl;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
> @@ -536,7 +537,7 @@ static int nfacct_cmd_restore(int argc, char *argv[])
>  			return -1;
>  		}
>  		*semicolon = 0;
> -		ret = sscanf(buffer, "{ pkts = %lu, bytes = %lu } = %s",
> +		ret = sscanf(buffer, "{ pkts = %llu, bytes = %llu } = %s",

Better use %"PRIu64" given that we're using uint64_t.

I have applied a patch based on yours.

Thanks.
