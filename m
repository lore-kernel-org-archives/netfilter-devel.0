From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: i don't know whether it is a bug?
Date: Mon, 19 May 2008 18:00:56 +0200
Message-ID: <4831A438.4030907@netfilter.org>
References: <48316799.01FDFE.05405@m5-82.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50835 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755472AbYESPxU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 11:53:20 -0400
In-Reply-To: <48316799.01FDFE.05405@m5-82.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fenglg wrote:
> void build_netpld(struct nf_conntrack *ct, struct netpld *pld, int query)
> {
> 	if (nfct_attr_is_set(ct, ATTR_IPV4_SRC))
> 		__build_pointer_be(ct, pld, ATTR_IPV4_SRC, sizeof(uint32_t));
> 	........
> 	/* setup the master conntrack */
> 	if (nfct_attr_is_set(ct, ATTR_MASTER_IPV4_SRC))
> 		__build_u32(ct, pld, ATTR_MASTER_IPV4_SRC);
> 	........
> }
>     The __build_u32 will use get_attr_array[type](ct) which is in libnetfilter_conntrack-0.0.89/src/conntrack/api.c. But the defination of get_attr_array has not ATTR_MASTER_IPV4_SRC.

This bug was reported by Max Wilhelm some weeks ago. It is already fixed
in Netfilter's git repository. I'll release a new version soon.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
