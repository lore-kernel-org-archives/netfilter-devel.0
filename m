Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEAFEB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 10:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjFUKvR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjFUKus (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 06:50:48 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFEC19B4
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 03:50:02 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f9b4bf99c2so25458875e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 03:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687344600; x=1689936600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fSRkwHLFq+2I9Xiyi/hU6wMpRwozZdsPaoeIOTE25yg=;
        b=AIsj2vEdz+Fc9Jy19U2Q4+7jk5CdnnBRAq8EU0/qgIBKasDy/i9F7ZXwuxvu/FIk+V
         e/sUJHlgDgR4Qx2Oh1t5R17vdDFqF/9Ly0AVSK9zUVBFtxeRPEJfGRY1Ks9BJsa7NWkf
         GXQKQBgxImLcLHozIYWaaIqJ2GrVDZ8vDZMAG4ZNWlYOBv1zbniTnw6kcMxllyCdLRPM
         ZQ4LPyPa8TOuuqU/g5NEtzVey08OWckHaORybMu3dXpLsx3EAMUOJp98YetCTODsSvBK
         UGnxHZVFuD2xpLdXg7xgTBB0HXflRT1SIPGFL3SgcodXnvQYRGYsUcq+78aAj0lpxCAJ
         /6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687344601; x=1689936601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSRkwHLFq+2I9Xiyi/hU6wMpRwozZdsPaoeIOTE25yg=;
        b=Oe3tGU+UE8bZtYch44JCW+2JlJh5qo4rwfrsYe1POe9dQcEi61hBd61i0numal3o/p
         Ke1BzxiC/m5NGV5+EVBjwsSU64VqZ2E/TRtjrYWR63jx8ygivX+vzAgl5P+O1W0XeEFG
         ojPc4BgeE7pJEGGNc7KStSH+RLfptmADFZ6Dm+KAGLjGpcPBp77kKvX4gze/vD//reOq
         cfvVk9yldoILKZ/ljy57BQ3lGIxoyRJL6+fOIoMoEGPawny/zeFGv0S8bIrU5uR3R4x7
         KrkfZXNi/XXV077Kl8Gcvg+v99H/UqUi4WFp2Xwkpr/ujZu8t8lcn3ce/810lCIlOV53
         pCpg==
X-Gm-Message-State: AC+VfDxiMCumKpi0WWMODvYl9cOhPBn5neqeXiRQaj3wR50U8oCiWvep
        lDeT2t0AV4DDFdy5/6llUN1ChQ==
X-Google-Smtp-Source: ACHHUZ4kGH8qImQSxaCquFokOidLojUiduGNeN6yC7xlAN8t9enaJAidhtFzyKegekb0YEbNp5wSRg==
X-Received: by 2002:a05:600c:a39f:b0:3f9:8da:bb4b with SMTP id hn31-20020a05600ca39f00b003f908dabb4bmr8183476wmb.37.1687344600642;
        Wed, 21 Jun 2023 03:50:00 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c9-20020a05600c0ac900b003f7eeec829asm4670229wmr.10.2023.06.21.03.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 03:49:58 -0700 (PDT)
Date:   Wed, 21 Jun 2023 13:49:54 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Joel Granados <j.granados@samsung.com>
Cc:     mcgrof@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Martin Schiller <ms@dev.tdt.de>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
        mptcp@lists.linux.dev, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        linux-sctp@vger.kernel.org, linux-s390@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 06/11] sysctl: Add size to register_net_sysctl function
Message-ID: <f95b7489-8654-435c-bc74-da1eac479fba@kadam.mountain>
References: <20230621091000.424843-1-j.granados@samsung.com>
 <CGME20230621091022eucas1p1c097da50842b23e902e1a674e117e1aa@eucas1p1.samsung.com>
 <20230621091000.424843-7-j.granados@samsung.com>
 <dab06c20-f8b0-4e34-b885-f3537e442d54@kadam.mountain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZFMDZBc9cnLbyP1u"
Content-Disposition: inline
In-Reply-To: <dab06c20-f8b0-4e34-b885-f3537e442d54@kadam.mountain>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ZFMDZBc9cnLbyP1u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2023 at 12:47:30PM +0300, Dan Carpenter wrote:
> The patchset doesn't include the actual interesting changes, just a
> bunch of mechanical prep work.
> 

I was wrong here, the patchset just hadn't all hit the mailing lists.
I can't apply this patchset to anything.  I tried linux-next, net, and
net-next.  So it's hard to review.

It looks like ensure_safe_net_sysctl() never got update to use
table_size...

You could easily write a static checker test to print a warning any time
that ->procname is checked for NULL.  I have attached a Smatch check.
You would need to added to check_list.h and recompile.

net/sysctl_net.c:130 ensure_safe_net_sysctl() warn: checking ->procname 'ent->procname'

regards,
dan carpenter


--ZFMDZBc9cnLbyP1u
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="check_checking_procname.c"

#include "smatch.h"
#include "smatch_slist.h"

static int my_id;

static void match_condition(struct expression *expr)
{
	char *member_name;

	if (expr->type == EXPR_COMPARE)
		return;

	member_name = get_member_name(expr);
	if (!member_name)
		return;

	if (strcmp(member_name, "(struct ctl_table)->procname") == 0)
		sm_warning("checking ->procname '%s'", expr_to_str(expr));
}

void check_checking_procname(int id)
{
	my_id = id;

	add_hook(&match_condition, CONDITION_HOOK);
}

--ZFMDZBc9cnLbyP1u--
