From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH -stable] netfilter: Zero the tuple in nfnl_cthelper_parse_tuple()
Date: Tue, 19 May 2015 13:31:21 +0200
Message-ID: <555B1F09.7010300@suse.cz>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org> <1431802251-4781-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>, stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34398 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbbESLbZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 May 2015 07:31:25 -0400
In-Reply-To: <1431802251-4781-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/16/2015, 08:50 PM, Pablo Neira Ayuso wrote:
> From: Ian Wilson <iwilson@brocade.com>
> 
> [ upstream commit 78146572b9cd20452da47951812f35b1ad4906be ]
> 
> nfnl_cthelper_parse_tuple() is called from nfnl_cthelper_new(),
> nfnl_cthelper_get() and nfnl_cthelper_del().  In each case they pass
> a pointer to an nf_conntrack_tuple data structure local variable:
> 
>     struct nf_conntrack_tuple tuple;
>     ...
>     ret = nfnl_cthelper_parse_tuple(&tuple, tb[NFCTH_TUPLE]);
> 
> The problem is that this local variable is not initialized, and
> nfnl_cthelper_parse_tuple() only initializes two fields: src.l3num and
> dst.protonum.  This leaves all other fields with undefined values
> based on whatever is on the stack:
> 
>     tuple->src.l3num = ntohs(nla_get_be16(tb[NFCTH_TUPLE_L3PROTONUM]));
>     tuple->dst.protonum = nla_get_u8(tb[NFCTH_TUPLE_L4PROTONUM]);
> 
> The symptom observed was that when the rpc and tns helpers were added
> then traffic to port 1536 was being sent to user-space.
> 
> Cc: <stable@vger.kernel.org> # 3.10.x
> Cc: <stable@vger.kernel.org> # 3.12.x

Applied only this one to 3.12 (others are not marked as such). Thanks.

> Cc: <stable@vger.kernel.org> # 3.14.x
> Cc: <stable@vger.kernel.org> # 3.18.x
> Cc: <stable@vger.kernel.org> # 3.19.x
> Signed-off-by: Ian Wilson <iwilson@brocade.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nfnetlink_cthelper.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
> index a5599fc..54330fb 100644
> --- a/net/netfilter/nfnetlink_cthelper.c
> +++ b/net/netfilter/nfnetlink_cthelper.c
> @@ -77,6 +77,9 @@ nfnl_cthelper_parse_tuple(struct nf_conntrack_tuple *tuple,
>  	if (!tb[NFCTH_TUPLE_L3PROTONUM] || !tb[NFCTH_TUPLE_L4PROTONUM])
>  		return -EINVAL;
>  
> +	/* Not all fields are initialized so first zero the tuple */
> +	memset(tuple, 0, sizeof(struct nf_conntrack_tuple));
> +
>  	tuple->src.l3num = ntohs(nla_get_be16(tb[NFCTH_TUPLE_L3PROTONUM]));
>  	tuple->dst.protonum = nla_get_u8(tb[NFCTH_TUPLE_L4PROTONUM]);
>  
> 


-- 
js
suse labs
