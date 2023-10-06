Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8845DE81E00
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Oct 2023 14:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjJFO1O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Oct 2023 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjJFO1O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2023 10:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BDBC6
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696602389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3TKA0uOO1V1NEECcTJXgvDOa0yXh9mtGuJE1Z9N4vM=;
        b=gm2zz1nEAP0678AGQbHQebeQImPNmFbRNJuqmpVOqsZwQoy73aKw0GhKbL/dJlkqMURYTt
        FkQM7RjEyp4XLE7bGIdFiJtyTjG100eZk0AuTsYV4cnRWmtQON8W9mdDiBXlApCJcqk9u/
        BNEBqXMaVHtc6hdQYU5tu2dIF5qkMkM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-1qcD8AmiM3K15VPUow6s8w-1; Fri, 06 Oct 2023 10:26:25 -0400
X-MC-Unique: 1qcD8AmiM3K15VPUow6s8w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b2d2d8f9e0so44240666b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Oct 2023 07:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696602378; x=1697207178;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3TKA0uOO1V1NEECcTJXgvDOa0yXh9mtGuJE1Z9N4vM=;
        b=gkFPYiR42FIKDfh09ZVTA7LnY7iRxJKmY4U2ON5cGCnpeCKBeIo0atMjaiq1qmcT4i
         q+wOQGGhY7QH+MiiWbQ6KNHhQ6QDtyeRzSLHnlyQNb5qh4wRACao4OIyiMLx0t6DFNEH
         KZs3sUpeQyWeYh88CSt31lY5kgwX/dif865hJltBySc808ZUmmJ4K0R0540LoSEecP4k
         gwZXcASDPpcPB7M7DHfT9sM6UL1Nca5jKq4sGs9BE+6ZpUJXzPCLMmQIYk3fWbWARoKz
         WStnXUxKI2t1TY36Vxvxhvo1NLuuCvlVz8AFneh3Cv0KPsaoUmWarXNxtNwFg67Jy+iU
         8OYQ==
X-Gm-Message-State: AOJu0YwtflUCAy0klZnqB00UMHbOSpRaRwp/CUZTDRDPUi5vzhLc+li8
        IywA6K1J5YcPpX5R/PR0TtazaQtuMW66A5DmpyAokskYUSV+AkUsEldsTKlplZq4wDPOeOIFkqC
        isdJNLL3wewVpqYxlfHDg0FMLmmUecSucUXNgQSY=
X-Received: by 2002:a17:906:2c9:b0:9a6:5340:c331 with SMTP id 9-20020a17090602c900b009a65340c331mr7115695ejk.2.1696602378557;
        Fri, 06 Oct 2023 07:26:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNtasIF+iu/1BBHGvsBhepruDTRGTUTvRd+gJQyCxWhy9ezr2oP6UW7yQG7VTfOuBfwoMyEw==
X-Received: by 2002:a17:906:2c9:b0:9a6:5340:c331 with SMTP id 9-20020a17090602c900b009a65340c331mr7115683ejk.2.1696602378157;
        Fri, 06 Oct 2023 07:26:18 -0700 (PDT)
Received: from [192.168.189.142] (rm-19-56-181.service.infuturo.it. [151.19.56.181])
        by smtp.gmail.com with ESMTPSA id rn18-20020a170906d93200b0098ec690e6d7sm2960128ejb.73.2023.10.06.07.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 07:26:17 -0700 (PDT)
Message-ID: <ce0f1edabc00a29d5d3d7a01b91f6c1fb11891d8.camel@redhat.com>
Subject: Re: [nft PATCH 1/3] tests/shell: mount all of "/var/run" in
 "test-wrapper.sh"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 06 Oct 2023 16:26:14 +0200
In-Reply-To: <ZR/01bpbTAQY5QPc@calendula>
References: <20231006094226.711628-1-thaller@redhat.com>
         <ZR/01bpbTAQY5QPc@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-10-06 at 13:51 +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 06, 2023 at 11:42:18AM +0200, Thomas Haller wrote:
> > After reboot, "/var/run/netns" does not exist before we run the
> > first
> > `ip netns add` command. Previously, "test-wrapper.sh" would mount a
> > tmpfs on that directory, but that fails, if the directory doesn't
> > exist.
> > You will notice this, by deleting /var/run/netns (which only root
> > can
> > delete or create, and which is wiped on reboot).
> >=20
> > Instead, mount all of "/var/run". Then we can also create
> > /var/run/netns
> > directory.
>=20
> Maybe create a specify mount point for this? This will be created
> once, then it will remain there for those that run tests?

Hi Pablo,

I don't understand. Could you please elaborate?

Note that the last commit adds a "--setup-host" option. I considered
whether that should also `mkdir -p /var/run/netns`, but I decided
against it, because Patch 1/3 solves it better (and makes it
unnecessary).

As tests run in parallel, they all should use their own private
/var/run/netns to not interfere with each other. Hence, they test-
wrapper.sh would still (at least) remount /var/run/netns. While at it,
Patch 1/3 remounting /var/run is even preferable, because there should
be nothing in /var/run that is required by tests or that should be
shared (or if we ever learn that there would be something, than special
action could be taken).


Thomas

