Return-Path: <SRS0=8NPN=5Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B84C2D0F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 20:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E911206F7
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 20:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1vUfl6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDHUUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Apr 2020 16:20:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726876AbgDHUUq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 16:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586377245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKNWFKamzoQq6v4EvO9EZCzMmxRhNH7pOekH+XL/dts=;
        b=R1vUfl6gPhhGVMctCWbm1KO4gs2sZ1WxIJ6zkfAcQMG9UKRBmvRz+QzBJ7NVeDYA+UwooG
        0ldca52EKvcFaSz01LXW4Q3Z0txcnvLoOQMPR+/AdxVETna0+BFf8LXue9LkO6UOD/5g4m
        D6qGfFulFVsbiNgk9l0mdywnfKRAY44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-gufHaMQ1N2G7EqsuR1pdQw-1; Wed, 08 Apr 2020 16:20:43 -0400
X-MC-Unique: gufHaMQ1N2G7EqsuR1pdQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44DB3DB2E;
        Wed,  8 Apr 2020 20:20:42 +0000 (UTC)
Received: from localhost (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75612953DD;
        Wed,  8 Apr 2020 20:20:35 +0000 (UTC)
Date:   Wed, 8 Apr 2020 22:20:11 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
Message-ID: <20200408222011.2ba3028b@redhat.com>
In-Reply-To: <alpine.DEB.2.21.2004082147410.23414@blackhole.kfki.hu>
References: <20200225094043.5a78337e@redhat.com>
        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>
        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
        <20200225215322.6fb5ecb0@redhat.com>
        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
        <20200228124039.00e5a343@redhat.com>
        <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu>
        <20200303231646.472e982e@elisabeth>
        <alpine.DEB.2.20.2003091059110.6217@blackhole.kfki.hu>
        <20200408160937.GI14051@orbyte.nwl.cc>
        <alpine.DEB.2.21.2004082147410.23414@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 8 Apr 2020 21:59:11 +0200 (CEST)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> The patch in the ipset git tree makes possible to choose :-)

J=C3=B3zsef, by the way, let me know what you want to do with the
iptables-extensions man patches I sent. I'm assuming you'd take care
of merging them or re-posting them "at the right time". :)

--=20
Stefano

