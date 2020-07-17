Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A0FC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E5620768
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WxtlzqDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQKMU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:12:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgGQKMU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 06:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594980739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8XZzL0mwa4c7nUL0a2Kj1egE81SEcJS5mBzL34saJvg=;
        b=WxtlzqDy1Chei/wrLxv54Zm85d99dK6CJdgU2iCsSUmghyhgMUSkH9pq66pyh9JmcZtDwh
        EeVB2xMK8qNwprprvM/kr89FajoxA0noj9GZNGRZp+cnMi6dQoh9tBf3i6EgEDPmmZADbB
        tniQa8cYRsTiGYBC98GipmnN75YCv90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-q7xfilAsMIGqCfycv6-nqw-1; Fri, 17 Jul 2020 06:12:15 -0400
X-MC-Unique: q7xfilAsMIGqCfycv6-nqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E4480183C;
        Fri, 17 Jul 2020 10:12:13 +0000 (UTC)
Received: from localhost (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCED5710B1;
        Fri, 17 Jul 2020 10:12:12 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v3] iptables: accept lock file name at runtime
References: <20200717083940.618618-1-gscrivan@redhat.com>
        <20200717092744.GA17027@salvia>
Date:   Fri, 17 Jul 2020 12:12:10 +0200
In-Reply-To: <20200717092744.GA17027@salvia> (Pablo Neira Ayuso's message of
        "Fri, 17 Jul 2020 11:27:44 +0200")
Message-ID: <87wo32v4at.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Probably remove the check for lock_file[0] == '\0'
>
> Or is this intentional?

I've added it intentionally as I think it is safer to ignore an empty
string.  The programs I've checked, GNU coreutils and GNU grep, have the
same check.

The empty string will likely fail on open(2), at least on tmpfs
it does with ENOENT.  If you want though, I can drop the check.

> git grep getenv in iptables does not show any similar handling for
> getenv().

not sure if that is the desired behaviour as it will be processed as
an empty string.

Regards,
Giuseppe

