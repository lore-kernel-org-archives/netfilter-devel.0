Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60705C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 20:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD1420782
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 20:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="atZUyL+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGCU0M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 16:26:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53073 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgGCU0L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 16:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593807970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PEKYLzk367tTswLsxH06yejo5bBazH5JcJIISwE0HOY=;
        b=atZUyL+NKl5hqeKZmQEQVDqDLhBCA3YPSDZcZF7ERb6Bh5Qcz10YX1zxfeZuA2pgjVBn1v
        /aB9baVCKLZRsWuSEiv4owyXOEjQR72WhkB4VoKsVRUgU5T1K6IXYwR6EfzDPWj4WUGMbn
        CCdHjlmyzkDNwzxBckMylcZDJtyKH/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-vilHhKrVN1quK0fQV7H9fg-1; Fri, 03 Jul 2020 16:26:09 -0400
X-MC-Unique: vilHhKrVN1quK0fQV7H9fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0596C800597;
        Fri,  3 Jul 2020 20:26:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A14F1002382;
        Fri,  3 Jul 2020 20:25:59 +0000 (UTC)
Date:   Fri, 3 Jul 2020 16:25:57 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-audit@redhat.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] audit: use the proper gfp flags in the audit_log_nfcfg()
 calls
Message-ID: <20200703202557.tm6o33uignjpmepa@madcap2.tricolour.ca>
References: <159378341669.5956.13490174029711421419.stgit@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159378341669.5956.13490174029711421419.stgit@sifl>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-07-03 09:36, Paul Moore wrote:
> Commit 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
> incorrectly passed gfp flags to audit_log_nfcfg() which were not
> consistent with the calling function, this commit fixes that.
> 
> Fixes: 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
> Reported-by: Jones Desougi <jones.desougi+netfilter@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Looks good to me.  For what it's worth:

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  net/netfilter/nf_tables_api.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f7ff91479647..886e64291f41 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5953,7 +5953,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  				goto cont;
>  
>  			if (reset) {
> -				char *buf = kasprintf(GFP_KERNEL,
> +				char *buf = kasprintf(GFP_ATOMIC,
>  						      "%s:%llu;?:0",
>  						      table->name,
>  						      table->handle);
> @@ -5962,7 +5962,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  						family,
>  						obj->handle,
>  						AUDIT_NFT_OP_OBJ_RESET,
> -						GFP_KERNEL);
> +						GFP_ATOMIC);
>  				kfree(buf);
>  			}
>  
> @@ -6084,7 +6084,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
>  				family,
>  				obj->handle,
>  				AUDIT_NFT_OP_OBJ_RESET,
> -				GFP_KERNEL);
> +				GFP_ATOMIC);
>  		kfree(buf);
>  	}
>  
> @@ -6172,7 +6172,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
>  			event == NFT_MSG_NEWOBJ ?
>  				AUDIT_NFT_OP_OBJ_REGISTER :
>  				AUDIT_NFT_OP_OBJ_UNREGISTER,
> -			GFP_KERNEL);
> +			gfp);
>  	kfree(buf);
>  
>  	if (!report &&
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

