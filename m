From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH 3/3] evaluate: make pointers in string
 arrays constant
Date: Wed, 4 Oct 2017 16:29:10 +0200
Message-ID: <20171004142910.GA22122@salvia>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
 <9b81cec687c3082f5fd762ece696f1272945e0ad.1506928244.git.harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9b81cec687c3082f5fd762ece696f1272945e0ad.1506928244.git.harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 02, 2017 at 01:02:50PM +0530, Harsha Sharma wrote:
> static const char * array should probably be static const char * const
> array
> as per linux-kernel coding style
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  src/evaluate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b783054..f48801a 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -33,7 +33,7 @@
>  static struct output_ctx octx_debug_dummy;
>  static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
>  
> -static const char *byteorder_names[] = {
> +static const char * const byteorder_names[] = {

I can see more string array that could use this in the nftables tree.
Please, fix all in one single patch.

Thanks.
