Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E03C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 15:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBEA5205ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 15:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iqLAN5Gh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgEMPLu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 11:11:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgEMPLu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 11:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589382708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T0z0zIUU46135j1qNQ5RB+8B7XF37JnGsuwXcnwHJHE=;
        b=iqLAN5GhvM5N+OEbWXEjqrtzVxVrOxIZRwrF11J/S0PFsluPnGcLZLApxBl4OfJjbsyqkA
        LLYCZQhX3wh93Kf3OIBfMncZpIfyQ3owrHHIVulYKmkzW2S6yyBcomMFbqkR6xSBvckxWl
        jXu0r+4g7iZ6yFkG436gPBlqUrp4HC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-colpGaGsNz2exwcpsvMbBA-1; Wed, 13 May 2020 11:11:38 -0400
X-MC-Unique: colpGaGsNz2exwcpsvMbBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D65E8014C0;
        Wed, 13 May 2020 15:11:37 +0000 (UTC)
Received: from localhost (ovpn-113-211.phx2.redhat.com [10.3.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D12885D9C5;
        Wed, 13 May 2020 15:11:36 +0000 (UTC)
Date:   Wed, 13 May 2020 11:11:36 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] JSON: Improve performance of json_events_cb()
Message-ID: <20200513151136.72xyr56uuzmby2qo@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200513143803.25109-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513143803.25109-1-phil@nwl.cc>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 13, 2020 at 04:38:03PM +0200, Phil Sutter wrote:
> The function tries to insert handles into JSON input for echo option.
> Yet there may be nothing to do if the given netlink message doesn't
> contain a handle, e.g. if it is an 'add element' command. Calling
> seqnum_to_json() is pointless overhead in that case, and if input is
> large this overhead is significant. Better wait with that call until
> after checking if the message is relevant at all.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/parser_json.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 4468407b0ecd0..3a84bd96af31f 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -3847,12 +3847,15 @@ static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
>  }
>  int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
>  {
> -	json_t *tmp, *json = seqnum_to_json(nlh->nlmsg_seq);
>  	uint64_t handle = handle_from_nlmsg(nlh);
> +	json_t *tmp, *json;
>  	void *iter;
>  
> -	/* might be anonymous set, ignore message */
> -	if (!json || !handle)
> +	if (!handle)
> +		return MNL_CB_OK;
> +
> +	json = seqnum_to_json(nlh->nlmsg_seq);
> +	if (!json)
>  		return MNL_CB_OK;
>  
>  	tmp = json_object_get(json, "add");
> -- 
> 2.26.2

Acked-by: Eric Garver <eric@garver.life>

With this I see a 10x improvement when adding many (hundreds) set
elements [1].

Thanks Phil!

[1]: https://bugzilla.redhat.com/show_bug.cgi?id=1834853#c6


