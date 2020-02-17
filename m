Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA58EC34021
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 15:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1DC5208C4
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 15:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsbU2ccb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBQPmw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 10:42:52 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:45580 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgBQPmw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 10:42:52 -0500
Received: by mail-qt1-f173.google.com with SMTP id d9so12282694qte.12
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 07:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=qWKcvzhTL4aBLQngRJsRXnfQRSJguk8/XIb+SCmlzvo=;
        b=YsbU2ccbVsV/pmJewNAFBuN4YN/f19JbuPP0A15+X55qU7WUa9TaiocsEHIOuJp+46
         DAKq/nfDrlBwv6DUE2b5GEzTWTTl2nU05FfmB/vYFKLgMJkkJlYVQHnF+cfkXEXYt5BM
         toDH5j+mgwoHDP4bKtkM1VtQl4UyvKC+Ql/w4suatP7y5TJVrNM9fI2knkPYu0D9TE7b
         IfId0miGzKqy6NQHh/bQAPRV7A5fM21SMTiDhP7jHfg7BstwjeizoddBlcN72Ld4dkaK
         FToi51CfWh8gwYpIHZjmcfdCdX3JWU9rhEHaUvSrwSPYGMwk0ouiZ+JTBeK29upZnz0W
         xXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=qWKcvzhTL4aBLQngRJsRXnfQRSJguk8/XIb+SCmlzvo=;
        b=sQmVHgLq83YvVvif//QSh8xYgCfbEHVhdAXNTAE6rU9bxGkKPkmnp+MoVJ3kOwm+9f
         nm/QbMDPTbSsuHy/ePgspcTbipl9EiPhEZRrJu5I3WkZWHJSjVfkv+MY1k9NhtB8F17C
         7sOnplaKzXzV0CV+TeP6cRbiJjMxe00bS6B3nh2JXD09dTexvQjHnG48fq7GbQz5NCii
         vXckzqSgTzThceyutS7whsyLlWH3P1buvx5k7g7XfzNodvqr/SSwGqknsjKffVYVs7Qe
         Wt1isw7kmLs/5Ua/CFtV5vQWpspx4WPSIWGdlaGJwCqR1PrBpsvBzUbLv/ENyqysrHCK
         Iddw==
X-Gm-Message-State: APjAAAXnSUcYwfhNsUTCCtKevj9IkYBp222eGOGfMfTLNC6BpMAHuKE4
        XUA+Kn2wfBdXuh7SdX+Tg/O30mDUybM=
X-Google-Smtp-Source: APXvYqwUtkGMS58b+MOFbrIjQfkuQ45kctbppugC3KwLtCb3B9qWDxpA2nEVhro2FiyAwEN4/smW1Q==
X-Received: by 2002:ac8:3946:: with SMTP id t6mr13759927qtb.278.1581954170182;
        Mon, 17 Feb 2020 07:42:50 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.65])
        by smtp.gmail.com with ESMTPSA id x22sm345087qtq.30.2020.02.17.07.42.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 07:42:49 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.22.0.200209
Date:   Mon, 17 Feb 2020 10:42:48 -0500
Subject: Re: Proposing to add a structure to UserData
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <A1C979C6-C703-4013-A536-47758175E8A8@gmail.com>
Thread-Topic: Proposing to add a structure to UserData
References: <169CDFEB-A792-4063-AEC5-05B1714AED91@gmail.com>
 <20200217144034.GC19559@breakpoint.cc>
In-Reply-To: <20200217144034.GC19559@breakpoint.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

Thank you for letting me know, I checked golang unix package and I did not =
find definition for NFTNL_UDATA_RULE_COMMENT.  That explains why I did not u=
se it.
Could you please point me where UDATA relate types and subtypes are defined=
, so I could replicate them in go.

Thank you
Serguei


=EF=BB=BFOn 2020-02-17, 9:40 AM, "Florian Westphal" <fw@strlen.de> wrote:

    sbezverk <sbezverk@gmail.com> wrote:
    > I would like to propose to add some structure to UserData. Currently =
nft tool uses UserData to carry comments and it prints out whatever is store=
d in it without much of processing. Since UserData is the only available mec=
hanism to store some metadata for a rule, if it is used, then comments in nf=
t cli get totally screwed up.
   =20
    Then you are using it wrong :-)
   =20
    Userdata is structured, its not used only for comments.
    Which userdata are you referring to?  We have this for
    rules, sets, and elements.
   =20
    > If we could add attributes to UserData indicating type NFT_USERDATA_C=
OMMENT with length, then we could preserve nft comments and at the same time=
 allow to use UserData for other things.
    > What do you think?
   =20
    As far as I can see what you want is already implemented, for example
    rule comments live in NFTNL_UDATA_RULE_COMMENT sub-type.
   =20


