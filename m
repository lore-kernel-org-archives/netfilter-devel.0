From: Andrei Popa <andrei.popa@i-neo.ro>
Subject: Re: [oops] in text matching
Date: Tue, 13 Nov 2007 08:51:59 +0200
Message-ID: <1194936719.10588.0.camel@ierdnac>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>
	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net>
Reply-To: andrei.popa@i-neo.ro
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [85.204.20.254] ([85.204.20.254]:52531 "EHLO megainternet.ro"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbXKMGwZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 01:52:25 -0500
In-Reply-To: <4735AAC6.7040605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sat, 2007-11-10 at 13:57 +0100, Patrick McHardy wrote:
> Andrei Popa wrote:
> > The oops is reproducible by this script (yyy are some IP addresses):
> > 
> > ...
> > #$IPT -I INPUT -p tcp --dport 80 -m string --algo bm --string "$MyNick"
> > -j DROP
> 
> 
> I could reproduce it with an empty string - is $MyNick defined?

it's not defined.

> Please try this patch.

it's ok now:

test ~ # iptables -I INPUT -p tcp --dport 80 -m string --algo bm
--string "$MyNick" -j DROP
iptables: Invalid argument
test ~ #               

> plain text document attachment (x)
> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> index d90822c..5adb3ff 100644
> --- a/lib/ts_bm.c
> +++ b/lib/ts_bm.c
> @@ -142,6 +142,9 @@ static struct ts_config *bm_init(const void *pattern, unsigned int len,
>  	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
>  	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
>  
> +	if (len == 0)
> +		return ERR_PTR(-EINVAL);
> +
>  	conf = alloc_ts_config(priv_size, gfp_mask);
>  	if (IS_ERR(conf))
>  		return conf;

