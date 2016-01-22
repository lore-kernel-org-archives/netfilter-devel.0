From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl v2] Add support for masq port selection
Date: Fri, 22 Jan 2016 20:01:09 +0100
Message-ID: <20160122190109.GA1374@salvia>
References: <20160122162907.GA5750@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35302 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbcAVTBO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2016 14:01:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A8A3E131CAA
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 20:01:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92D15DA85C
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 20:01:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B5CCDA85C
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2016 20:01:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160122162907.GA5750@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani, this looks good, only one comment below.

On Fri, Jan 22, 2016 at 09:59:07PM +0530, Shivani Bhardwaj wrote:
> @@ -51,6 +57,8 @@ int main(int argc, char *argv[])
>  		print_err("OOM");
>  
>  	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_FLAGS, 0x1234568);
> +	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MIN, 0x1234568);
> +	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MAX, 0x1234568);

I think the tests are more effective if you set different values, ie.

        nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_FLAGS, 0x12345678);
        nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MIN, 0x45671234);
        nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MAX, 0x87654321);

Beware that my kernel patch is only compile tested.

And please follow up with the nftables patch, let me know if you have
questions with it.

Thanks.
