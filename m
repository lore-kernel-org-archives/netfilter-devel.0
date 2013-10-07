From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] man: update the manpage for cluster match
Date: Mon, 7 Oct 2013 11:33:57 +0200
Message-ID: <20131007093357.GA5755@localhost>
References: <1381134176-18168-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47687 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab3JGJeI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:34:08 -0400
Content-Disposition: inline
In-Reply-To: <1381134176-18168-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:22:56PM +0800, Gao feng wrote:
> --h-length,--mangle-mac-s,--mangle-mac-d,--destination-mac
> are not supported by arptables now,and the chain name is IN/OUT.

I guess you're using jf's arptables version. The syntax is correct for
mainstream version.

I think it's worth to add a comment in the manpage, many people may be
confused with this and believe that arptables is broken.

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  extensions/libxt_cluster.man | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
> index 62ad71c..808a4d7 100644
> --- a/extensions/libxt_cluster.man
> +++ b/extensions/libxt_cluster.man
> @@ -41,19 +41,19 @@ ip maddr add 01:00:5e:00:01:01 dev eth1
>  .IP
>  ip maddr add 01:00:5e:00:01:02 dev eth2
>  .IP
> -arptables \-A OUTPUT \-o eth1 \-\-h\-length 6
> -\-j mangle \-\-mangle-mac-s 01:00:5e:00:01:01
> +arptables \-A OUT \-o eth1 \-arhln 6
> +\-j mangle \-\-mangle-hw-s 01:00:5e:00:01:01
>  .IP
> -arptables \-A INPUT \-i eth1 \-\-h-length 6
> -\-\-destination-mac 01:00:5e:00:01:01
> -\-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
> +arptables \-A IN \-i eth1 \-arhln 6
> +\-\-target-hw 01:00:5e:00:01:01
> +\-j mangle \-\-mangle\-hw\-d 00:zz:yy:xx:5a:27
>  .IP
> -arptables \-A OUTPUT \-o eth2 \-\-h\-length 6
> -\-j mangle \-\-mangle\-mac\-s 01:00:5e:00:01:02
> +arptables \-A OUT \-o eth2 \-arhln 6
> +\-j mangle \-\-mangle\-hw\-s 01:00:5e:00:01:02
>  .IP
> -arptables \-A INPUT \-i eth2 \-\-h\-length 6
> -\-\-destination\-mac 01:00:5e:00:01:02
> -\-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
> +arptables \-A IN \-i eth2 \-arhln 6
> +\-\-target\-hw 01:00:5e:00:01:02
> +\-j mangle \-\-mangle\-hw\-d 00:zz:yy:xx:5a:27
>  .PP
>  In the case of TCP connections, pickup facility has to be disabled
>  to avoid marking TCP ACK packets coming in the reply direction as
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
