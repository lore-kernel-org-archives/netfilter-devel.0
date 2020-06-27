Return-Path: <SRS0=mL34=AI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94749C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jun 2020 17:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B20920781
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jun 2020 17:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdUOFosK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgF0RgA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Jun 2020 13:36:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbgF0RgA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jun 2020 13:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593279358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mDDqDNrCYWn3A/GE763yXUtoyIO3ut/0qQZyVMGsIa8=;
        b=TdUOFosKaI3eGJNg5bwL9NkV45EdOipfETH8TT6Jv8SJlFRWkT5iszQ23bQ9OvFFuUN1vP
        Cgt7nwKkkTuq5chpCLNK/7v3CxZU8Eq01/c1vFeSjySI7rs4JFf6TtVlssdBPtlGuVK39M
        ITO+jbZQcFQPWOOlOxD747hImfqlJ7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-2fXGuuXTPSai4ys0eTT23g-1; Sat, 27 Jun 2020 13:35:45 -0400
X-MC-Unique: 2fXGuuXTPSai4ys0eTT23g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 162D0DC25;
        Sat, 27 Jun 2020 17:35:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 527BE60BF1;
        Sat, 27 Jun 2020 17:35:36 +0000 (UTC)
Date:   Sat, 27 Jun 2020 13:35:33 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [bug report] audit: log nftables configuration change events
Message-ID: <20200627173533.aqh4p2nbr33ea3eu@madcap2.tricolour.ca>
References: <20200626102242.GA313925@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626102242.GA313925@mwanda>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-26 13:22, Dan Carpenter wrote:
> Hello Richard Guy Briggs,
> 
> The patch 8e6cf365e1d5: "audit: log nftables configuration change
> events" from Jun 4, 2020, leads to the following static checker
> warning:
> 
> 	net/netfilter/nf_tables_api.c:6160 nft_obj_notify()
> 	warn: use 'gfp' here instead of GFP_XXX?
> 
> net/netfilter/nf_tables_api.c
>   6153  void nft_obj_notify(struct net *net, const struct nft_table *table,
>   6154                      struct nft_object *obj, u32 portid, u32 seq, int event,
>   6155                      int family, int report, gfp_t gfp)
>                                                     ^^^^^^^^^
>   6156  {
>   6157          struct sk_buff *skb;
>   6158          int err;
>   6159          char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
>                                       ^^^^^^^^^^
> This should probably be "gfp".

Agreed, nice catch.  Checking other similar uses from that patch
leads me to another bug and the need to extend audit_log_nfcfg() to
accept a GFP flag.  Patch coming...

>   6160                                table->name, table->handle);
>   6161  
>   6162          audit_log_nfcfg(buf,
>   6163                          family,
>   6164                          obj->handle,
>   6165                          event == NFT_MSG_NEWOBJ ?
>   6166                                  AUDIT_NFT_OP_OBJ_REGISTER :
>   6167                                  AUDIT_NFT_OP_OBJ_UNREGISTER);
>   6168          kfree(buf);
>   6169  
>   6170          if (!report &&
>   6171              !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
>   6172                  return;
>   6173  
>   6174          skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
>                                                 ^^^
> 
>   6175          if (skb == NULL)
>   6176                  goto err;
>   6177  
>   6178          err = nf_tables_fill_obj_info(skb, net, portid, seq, event, 0, family,
>   6179                                        table, obj, false);
>   6180          if (err < 0) {
>   6181                  kfree_skb(skb);
>   6182                  goto err;
>   6183          }
>   6184  
>   6185          nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
>   6186          return;
>   6187  err:
>   6188          nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
>   6189  }
> 
> regards,
> dan carpenter

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

