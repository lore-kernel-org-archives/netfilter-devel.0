From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] bridge: netfilter: checkpatch whitespace fixes
Date: Tue, 7 Jun 2016 17:14:58 +0200
Message-ID: <20160607151458.GA18008@salvia>
References: <1462843618-21914-1-git-send-email-me@tobin.cc>
 <1462843618-21914-2-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
To: tcharding <me@tobin.cc>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462843618-21914-2-git-send-email-me@tobin.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, May 10, 2016 at 11:26:56AM +1000, tcharding wrote:
> From: Tobin C Harding <me@tobin.cc>
> 
> checkpatch produces various white space 'checks'.
> 
> This patch amends them.
> 
> Signed-off-by: Tobin C Harding <me@tobin.cc>
> ---
> This is my second linux kernel patch. Unsure if I was meant to cc multiple mailing lists?
> 
> thanks
> 
>  net/bridge/netfilter/ebt_stp.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
> index 6b731e1..26a0859 100644
> --- a/net/bridge/netfilter/ebt_stp.c
> +++ b/net/bridge/netfilter/ebt_stp.c
> @@ -55,65 +55,65 @@ static bool ebt_filter_config(const struct ebt_stp_info *info,
>  	if (info->bitmask & EBT_STP_ROOTPRIO) {
>  		v16 = NR16(stpc->root);
>  		if (FWINV(v16 < c->root_priol ||
> -		    v16 > c->root_priou, EBT_STP_ROOTPRIO))
> +			  v16 > c->root_priou, EBT_STP_ROOTPRIO))

I don't think this coding style is right. This is a common approach
(to align the condition when split in several lines) in other 'net' code.
