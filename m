From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] xt_connlimit rev 1
Date: Tue, 11 Dec 2007 11:19:49 +0100
Message-ID: <475E6445.4090202@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXLKKTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:19:51 -0500
In-Reply-To: <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Make xt_connlimit use the new union nf_inet_addr in revision 1.


> +struct xt_connlimit_match_info_v1 {
> +	union nf_inet_addr mask;
> +	u_int32_t limit;
> +	u_int8_t invert;
> +
> +	struct xt_connlimit_data *data __attribute__((aligned(8)));
> +};
> +


No way I'm adding patches to intoduce new revisions for this,
the layout is exactly the same as before :) There must be
a better way, like an anonymous union:

struct xt_connlimit_info { 

         union {
		union nf_inet_addr mask;
		union {
			__be32 v4_mask;
			__be32 v6_mask[4];
		}
	};
	...
};

