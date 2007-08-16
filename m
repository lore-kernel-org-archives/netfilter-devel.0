From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] Re: drivers/infiniband/mlx/mad.c misplaced ;
Date: Thu, 16 Aug 2007 12:21:57 +0200
Message-ID: <46C42545.3000509@trash.net>
References: <20070815235825.GB17004@redhat.com>	<1187224811.5906.55.camel@localhost>  <46C3B428.4000003@intel.com> <1187234225.5906.73.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933363AbXHPKWh@vger.kernel.org>
In-Reply-To: <1187234225.5906.73.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Joe Perches wrote:
> diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
> index 74f9b14..bec4279 100644
> --- a/net/netfilter/xt_u32.c
> +++ b/net/netfilter/xt_u32.c
> @@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
>  		at  = 0;
>  		pos = ct->location[0].number;
>  
> -		if (skb->len < 4 || pos > skb->len - 4);
> +		if (skb->len < 4 || pos > skb->len - 4)
>  			return false;
>  

Thanks, I already sent the same patch upstream one or two days ago.
