From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch -mainline] netfilter: ipset: small potential read beyond
 the end of buffer
Date: Mon, 10 Nov 2014 15:24:46 +0100
Message-ID: <20141110142446.GA29586@salvia>
References: <20141107062140.GA10905@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Masanari Iida <standby24x7@gmail.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernddel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38489 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaKJOW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:22:57 -0500
Content-Disposition: inline
In-Reply-To: <20141107062140.GA10905@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 07, 2014 at 09:21:40AM +0300, Dan Carpenter wrote:
> We could be reading 8 bytes into a 4 byte buffer here.  It seems
> harmless but adding a check is the right thing to do and it silences a
> static checker warning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 86f9d76..ac08a3f 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1863,7 +1863,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
>  	if (*op < IP_SET_OP_VERSION) {
>  		/* Check the version at the beginning of operations */
>  		struct ip_set_req_version *req_version = data;
> -		if (req_version->version != IPSET_PROTOCOL) {
> +		if (*len < sizeof(struct ip_set_req_version) ||
> +		    req_version->version != IPSET_PROTOCOL) {
>  			ret = -EPROTO;
>  			goto done;

Thanks for catching up this.

>From other similar code in that location, I can see Jozsef is using
this pattern:

                if (*len != sizeof(struct ip_set_req_version)) {
                        ret = -EINVAL;
                        goto done;
                }

I think it would be good to stick to that for consistency. Thanks.
