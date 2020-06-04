Return-Path: <SRS0=RJ5t=7R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0510AC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jun 2020 18:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBBD207D3
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jun 2020 18:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H4EqOuwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgFDSwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 14:52:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37458 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728982AbgFDSwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 14:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591296731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsOiww58zMB8TiRbvx8d+FF7JBDwRx5PHUOX+iIdx7A=;
        b=H4EqOuwMlzTTQOZiHyrCKurV8/G3aODqswWQ2FBOGQG0D5fOX64Zdqr5Qw6rxXxckxbSAh
        0viFLd72sgitOH0xW56Z0XaC43mVsigIiIcGa+tau/M6a7CiC/8WNSBeDQyGGir7khjPoW
        ab/xBpCVo6NMwl8Uz1ocXpH0O86hf7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-11_TenfrO4GLK4lbkdXN-A-1; Thu, 04 Jun 2020 14:52:08 -0400
X-MC-Unique: 11_TenfrO4GLK4lbkdXN-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F9008DFFD0;
        Thu,  4 Jun 2020 18:52:07 +0000 (UTC)
Received: from x2.localnet (ovpn-112-220.phx2.redhat.com [10.3.112.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 170915D9D3;
        Thu,  4 Jun 2020 18:51:56 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change events
Date:   Thu, 04 Jun 2020 14:51:54 -0400
Message-ID: <2190308.cDvYnDs5iT@x2>
Organization: Red Hat
In-Reply-To: <20200604175756.d3x5fy4k4urilgbp@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com> <530434533.t1QJnzVmUA@x2> <20200604175756.d3x5fy4k4urilgbp@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday, June 4, 2020 1:57:56 PM EDT Richard Guy Briggs wrote:
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index 468a23390457..3a9100e95fda 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -75,6 +75,7 @@
> > > #include <linux/uaccess.h>
> > > #include <linux/fsnotify_backend.h>
> > > #include <uapi/linux/limits.h>
> > > +#include <uapi/linux/netfilter/nf_tables.h>
> > > 
> > > #include "audit.h"
> > > 
> > > @@ -136,9 +137,26 @@ struct audit_nfcfgop_tab {
> > > };
> > > 
> > > static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
> > > -       { AUDIT_XT_OP_REGISTER,         "register"      },
> > > -       { AUDIT_XT_OP_REPLACE,          "replace"       },
> > > -       { AUDIT_XT_OP_UNREGISTER,       "unregister"    },
> > > +       { AUDIT_XT_OP_REGISTER,                 "xt_register"
> > 
> > },
> > 
> > > +       { AUDIT_XT_OP_REPLACE,                  "xt_replace"           
> > >    }, +       { AUDIT_XT_OP_UNREGISTER,               "xt_unregister" 
> > >           }, +       { AUDIT_NFT_OP_TABLE_REGISTER,         
> > > "nft_register_table"> 
> > },
> > 
> > > +       { AUDIT_NFT_OP_TABLE_UNREGISTER,        "nft_unregister_table" 
> > >    }, +       { AUDIT_NFT_OP_CHAIN_REGISTER,         
> > > "nft_register_chain"> 
> > },
> > 
> > > +       { AUDIT_NFT_OP_CHAIN_UNREGISTER,        "nft_unregister_chain" 
> > >    }, +       { AUDIT_NFT_OP_RULE_REGISTER,          
> > > "nft_register_rule"> 
> > },
> > 
> > > +       { AUDIT_NFT_OP_RULE_UNREGISTER,         "nft_unregister_rule"
> > 
> > },
> > 
> > > +       { AUDIT_NFT_OP_SET_REGISTER,            "nft_register_set"
> > 
> > },
> > 
> > > +       { AUDIT_NFT_OP_SET_UNREGISTER,          "nft_unregister_set"
> > 
> > },
> > 
> > > +       { AUDIT_NFT_OP_SETELEM_REGISTER,        "nft_register_setelem" 
> > >    }, +       { AUDIT_NFT_OP_SETELEM_UNREGISTER,     
> > > "nft_unregister_setelem"   }, +       { AUDIT_NFT_OP_GEN_REGISTER,    
> > >        "nft_register_gen"         }, +       {
> > > AUDIT_NFT_OP_OBJ_REGISTER,            "nft_register_obj"         }, + 
> > >      { AUDIT_NFT_OP_OBJ_UNREGISTER,          "nft_unregister_obj"     
> > >  }, +       { AUDIT_NFT_OP_OBJ_RESET,               "nft_reset_obj"   
> > >         }, +       { AUDIT_NFT_OP_FLOWTABLE_REGISTER,     
> > > "nft_register_flowtable"   }, +       {
> > > AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,    "nft_unregister_flowtable" }, + 
> > >      { AUDIT_NFT_OP_INVALID,                 "nft_invalid"
> > 
> > },
> > 
> > > };
> > 
> > I still don't like the event format because it doesn't give complete
> > subject information. However, I thought I'd comment on this string
> > table. Usually it's sufficient to log the number and then have the
> > string table in user space which looks it up during interpretation.
> 
> That is a good idea that would help reduce kernel cycles and netlink
> bandwidth, but the format was set in 2011 so it is a bit late to change
> that now:
>         fbabf31e4d48 ("netfilter: create audit records for x_tables
> replaces")

Nothing searches/interprets that field name. So, you can redefine it by 
renaming it. Or just go with what you have. My preference is push that to 
user space. But not a showstopper "as is".

-Steve


