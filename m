From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/2] examples: use new nft_*_build_msg()
 functions
Date: Mon, 12 May 2014 18:15:08 +0200
Message-ID: <20140512161508.GB13099@localhost>
References: <20140506201936.18158.83354.stgit@nfdev.cica.es>
 <20140506201941.18158.46054.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44449 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaELQPR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:15:17 -0400
Content-Disposition: inline
In-Reply-To: <20140506201941.18158.46054.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 06, 2014 at 10:19:41PM +0200, Arturo Borrero Gonzalez wrote:
> Let's use these new functions in the examples.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  examples/nft-rule-add.c |    9 ++-------
>  examples/nft-rule-del.c |   13 +++++--------
>  2 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
> index 6961d0d..32302c5 100644
> --- a/examples/nft-rule-add.c
> +++ b/examples/nft-rule-add.c
> @@ -137,7 +137,6 @@ int main(int argc, char *argv[])
>  {
>  	struct mnl_socket *nl;
>  	struct nft_rule *r;
> -	struct nlmsghdr *nlh;
>  	struct mnl_nlmsg_batch *batch;
>  	uint8_t family;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
> @@ -180,12 +179,8 @@ int main(int argc, char *argv[])
>  			  NFNL_MSG_BATCH_BEGIN, seq++);
>  	mnl_nlmsg_batch_next(batch);
>  
> -	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> -			NFT_MSG_NEWRULE,
> -			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
> -			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
> -
> -	nft_rule_nlmsg_build_payload(nlh, r);
> +	nft_rule_build_msg(r, mnl_nlmsg_batch_current(batch), NFT_MSG_NEWRULE,
> +			   NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);

Is this the only potential user of this new _build_ function? If so,
I'd prefer to keep this back until we have more clients, I don't want
to prematurely increase the size of the library with code that we
don't need yet.

Let me know,
Thanks.
