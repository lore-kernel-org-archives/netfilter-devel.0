Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9468AC35246
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 00:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B39420CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 00:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMgtAbTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgAaAYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 19:24:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727598AbgAaAYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 19:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580430275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yce3RzcRj3/knjHHok9NbXtjPYcgNWKvZz8mmZTolms=;
        b=HMgtAbTpRcM0UtZk1S7aW8D+SCDo4EBZAXwQKuXpN4nlYttE2Y838HoE23HnoS8BnEtHxa
        8ISozK01LAlOtN42aT3PDX6L3Oq6tSDdBWAoHDOxRCk4CUMwnTyrgvNwRt3XSVvna4xcib
        +t+7hpddUBnAeMkocWu78EHJRKg/5/E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-QgCWFxi5NVSM0Em-ClY79A-1; Thu, 30 Jan 2020 19:24:33 -0500
X-MC-Unique: QgCWFxi5NVSM0Em-ClY79A-1
Received: by mail-ed1-f71.google.com with SMTP id d21so3554271edy.3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2020 16:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yce3RzcRj3/knjHHok9NbXtjPYcgNWKvZz8mmZTolms=;
        b=W4S0tjSJsJyQZjt+JhIsIySUYjNkqco3tXoCOo0ezReWtSVXYaV1gPffx4FCv2zvP7
         a/AMzvqqJYE0cyZHKBNv4UhW8kgmpS2sKZLOAawqh79tC6OGW7G4vpSlnQq3hrVRykmX
         TyIAlRpLaXCUOr0BNtaY+A3gNKDwohtRg6J9Xs4Uj/ZG7T+gW5G4m4Ip9v5jQs8Yo26x
         JwnIiCLi3rWPSaiDpJO8+gs5pIMijYSurKYuZbqt49ju9njZ9MyysDNkaVRKVv5Mz1j7
         ma+IPEdZL61R0dKpg+nhwdNmb0WQeCWiE7UMIh3dYILqCdZ2yBvdLiEzKKzPtbXCW20+
         fguA==
X-Gm-Message-State: APjAAAWwX2pyhY+YWPECCZyEka53u+LyMUrIOw+ul2iYwW/lfvnqsrDu
        P0CAxRhbbsbIXj3yDKJS/h4kaRk01TUTYpiYzkmk1gYZVuJWYiPSBKsu1Lsn8IZAzxlMbZo/Cc2
        sdOb6E0HPJIfVjXSMb/pwGSpUpSmWIEepCAGIK15smlr3
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr6377960edk.366.1580430272323;
        Thu, 30 Jan 2020 16:24:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfns7Ipz2OMXE7rsuvi11JkWCkrY9gHsHVLdpY40duyr/etkHlFPDUanfpd7IpDQXFGEdFBuoEY3X8zi7kwNg=
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr6377950edk.366.1580430272088;
 Thu, 30 Jan 2020 16:24:32 -0800 (PST)
MIME-Version: 1.0
References: <20200130191019.19440-1-mcroce@redhat.com> <20200130141448.27fa32aa@cakuba>
In-Reply-To: <20200130141448.27fa32aa@cakuba>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 31 Jan 2020 01:23:56 +0100
Message-ID: <CAGnkfhzHqHFiqje3_ruSFvz09QKv3M8dqvOqzN_kau6ZpKzWOw@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_flowtable: fix documentation
To:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev <netdev@vger.kernel.org>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 30, 2020 at 11:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Jan 2020 20:10:19 +0100, Matteo Croce wrote:
> > In the flowtable documentation there is a missing semicolon, the command
> > as is would give this error:
> >
> >     nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
> >                     hook ingress priority 0 devices = { br0, pppoe-data };
> >                                             ^^^^^^^
> >     nftables.conf:4:12-13: Error: invalid hook (null)
> >             flowtable ft {
> >                       ^^
> >
> > Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> This is netfilter so even though it's tagged as net, I'm expecting
> Pablo (or Jon) to take it. Please LMK if I'm wrong.
>

You're right.
As get_maintainers.pl didn't list netfilter-devel@vger.kernel.org I missed it.

-- 
Matteo Croce
per aspera ad upstream

