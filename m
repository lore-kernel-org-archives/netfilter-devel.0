Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4224BC3A59F
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 01:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0554421874
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 01:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="aBDiwEUf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfH3BzL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 21:55:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34730 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfH3BzL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 21:55:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id b24so3486742pfp.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2019 18:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=C/rIPqRnCxjehMrRZykfN2Pikoku80prbn4PQ3WrWxc=;
        b=aBDiwEUf9orIecXXiHqnS7IC8pUBV0Etw6SQZV7DJzHPGg/pt8PswixOFjaa8bwf8T
         1cqIbuwWE/5UbPNsKmOBBdYJDQrbxPrhDwmHO132AbwE2Hm47s92ieQari9fqdJWNCJs
         5NvA6+rcdwkYqNVchSiDh7CFtwkiLQHvlIuGqrpB7QJ/bZRA5iyjFEI6HWxvBzdzQkQ6
         qZm9vdfZtAoY7sW/NSHzPurEI6axHfFc4igBIMIl6cqHmIcIQ/VPGpPgn79Rz/uWZw+X
         mWaySGkxk1n/ki1fSZ4xQNp8F9pSkP7SpKIlbFAArvHyYvxDxSsbHHm7vmjmu/ISgFeL
         mfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C/rIPqRnCxjehMrRZykfN2Pikoku80prbn4PQ3WrWxc=;
        b=JPPQ9/P/p4kV0DR6vBtqbZjRI1Yxglf+yn26OOkRD3P4K00Oc1npYeqKJ5Uot7INKk
         AiO7o5TskjjQ1JUbW4aGV2Y+Yz4w3kt83txb2XusdZXZEcYM9YepSEzxOrgLZcpDm4bt
         PKmlsh73kujc4XhGzzC/uJKDxgenLLzW19LFM7M8fkOGSTljSS1oStOj1P3uA/WYly/Y
         QML/EOvJcwQ8iJ4aad02ahinvLwqpbd0MjSHDFsb8cJ/UG32c1xG69IR/eIeoLy51nSG
         y4/cWehJKNDBfalVVJcBgKWV3ClarKxbKyiSb/CQhSAofwMT8CCax6hjJ7T05DYynq2o
         fLfQ==
X-Gm-Message-State: APjAAAVcwfPAlmN3k0RvT1ww4q9/2s1p958SPcEA8e1cPVYE6yog4T1R
        bHOITkHkxhfoWOOTIxDnI6Qe4Q==
X-Google-Smtp-Source: APXvYqzUwCj01UDS+jNdtjarJp+Kqp1GKBmtVGAiF/Zp1EKlVuDOItf6c+d4TR6XBsictPqKO9GjWA==
X-Received: by 2002:a63:6c4:: with SMTP id 187mr10155470pgg.401.1567130110117;
        Thu, 29 Aug 2019 18:55:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v18sm7116927pgl.87.2019.08.29.18.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:55:09 -0700 (PDT)
Date:   Thu, 29 Aug 2019 18:54:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190829185448.0b502af8@cakuba.netronome.com>
In-Reply-To: <20190830005336.23604-1-pablo@netfilter.org>
References: <20190830005336.23604-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 30 Aug 2019 02:53:32 +0200, Pablo Neira Ayuso wrote:
> * Offsets do not need to be on the 32-bits boundaries anymore. This
>   patchset adds front-end code to adjust the offset and length coming
>   from the tc pedit representation, so drivers get an exact header field
>   offset and length.

But drivers use offsetof(start of field) to match headers, and I don't
see you changing that. So how does this work then?

Say - I want to change the second byte of an IPv4 address.

> * The front-end coalesces consecutive pedit actions into one single
>   word, so drivers can mangle IPv6 and ethernet address fields in one
>   single go.

You still only coalesce up to 16 bytes, no?

As I said previously drivers will continue to implement mangle action
merge code if that's the case. It'd be nice if core did the coalescing,
and mark down first and last action, in case there is a setup cost for
rewrite group.
