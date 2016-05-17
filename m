From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_conntrack PATCH 1/3] src: add support for IPv6 to
 struct __nfct_nat
Date: Tue, 17 May 2016 17:45:49 +0200
Message-ID: <20160517154549.GA1998@salvia>
References: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
 <146348943198.4910.10995009662328384564.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbcEQPp6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 11:45:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E24F4B0EF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:45:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4BB4DD1D8A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:45:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3B1E3D1D8A
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 17:45:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146348943198.4910.10995009662328384564.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 02:50:32PM +0200, Arturo Borrero Gonzalez wrote:
> @@ -114,18 +129,34 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
>  
>  static int getobjopt_is_snat(const struct nf_conntrack *ct)
>  {
> -	return ((test_bit(ATTR_STATUS, ct->head.set) ?
> -		ct->status & IPS_SRC_NAT_DONE : 1) &&
> -		ct->repl.dst.v4 != 
> -		ct->head.orig.src.v4);
> +	if (!(test_bit(ATTR_STATUS, ct->head.set) ?
> +		ct->status & IPS_SRC_NAT_DONE : 1))
> +		return 0;

Better untangle this code:

        if (!test_bit(ATTR_STATUS, ct->head.set))
                return 0;

        if (!(ct->status & IPS_SRC_NAT_DONE))
                return 0;

        switch (ct->head.orig.l3protonum) {
        case AF_INET:
                return ct->repl.dst.v4 != ct->head.orig.src.v4;
        default:
                return 0;
        }

> +	switch (ct->head.orig.l3protonum) {
> +	case AF_INET:
> +		return ct->repl.dst.v4 != ct->head.orig.src.v4;
> +	case AF_INET6:
> +		return 0;

It is a bit strange to me that you add in this patch all these:

        case AF_INET6:
                return 0;

I'd rather see you adding this in 2/3 when you implement IPv6 support.

> +	default:
> +		return 0;
> +	}
>  }
>  
