Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDE6C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107FB20575
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biv4X5KR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgEFMlL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 08:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727874AbgEFMlL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 08:41:11 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04209C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 05:41:10 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e8so1553115ilm.7
        for <netfilter-devel@vger.kernel.org>; Wed, 06 May 2020 05:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oj09OU5LAsjYZu7sSsNIadnHwtGvB4kCFVCfprJgU6g=;
        b=biv4X5KR4oSdRYvQPvQ9Zlbp1k5CGgNI0BfVST8tIrBBwvI/ziizUK/yy+UxGRGP/3
         8zY4Tt2wlbNlsVHCn2gTLrKpMBsbECfbDPZkuTpNvA0+mUfnxK+QjHrkD5lWblVYV481
         q81716J0G5qlseGwJzgEu/5xGUdDKkOtkaU8fZe6HQz6fv4JR5aAhDaOnrC2h/FsycVk
         h+rnhnVVQ7+FJA30MobkSEMKpwULZ/GbTPagkZgq7OxbK9NGKMalkOk3rmHq26GKO559
         ceqACMgiZG20xKmY3LDyTXbqAlbUEbzQCHimia3JlwJIGWomVr9VrIagP4QZGziny9CK
         Gong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=oj09OU5LAsjYZu7sSsNIadnHwtGvB4kCFVCfprJgU6g=;
        b=n1xcXwAbiOdypI4Q/QHdUXjqJPbytYJXwKSBycOLNonQUOAYOy8p+K69nnVX9RN4XV
         L6Qn2QeDZ/j00/mlte+pg+bZgm9PcHwICnriAMvgdnBF+ag5zlga+ZFldfRFQodGnRpB
         MTc/wY9/ebgv+xBk5dYtnD4/WbwovY1k2JMErlxAJCfYJA/YDveym+u4FxEa4MAleQzN
         NCzo0Fq/FXkGrP9SDTNHhbGb7evuHQVJrwrh/U1U7tWC7W6UzGuAM9/KwhSF0vlFUQ42
         sqWBXhsByMiTGhkLZmCacoFDPQGw3TCqTRckJ2hZSSmNo+e/94983aj3P13YbVruaLF3
         uIWw==
X-Gm-Message-State: AGi0PuYK+Q3ICNuE3V2e2627VapINwwj6xwrH8InOybrhOWlL7QMvWNV
        2JKKnyE5tPMhG4cDa+7C6DZzI3UcYa6x7VwI9ZY=
X-Google-Smtp-Source: APiQypKvye9YOXRZorF6J6zwI+JlC1xjlS41tGc8sc/3T7sJPiD+gBovZbAmbAcC5R9VIHBViAx95EEVZg6Q4Vvq9PM=
X-Received: by 2002:a92:985d:: with SMTP id l90mr8945893ili.108.1588768870155;
 Wed, 06 May 2020 05:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
 <20200506120012.GA21153@salvia> <20200506120909.GA10344@orbyte.nwl.cc>
In-Reply-To: <20200506120909.GA10344@orbyte.nwl.cc>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Wed, 6 May 2020 08:40:58 -0400
Message-ID: <CAOdf3gr+7SoqF-hzpccqAsN4ejpn+5K_kDP-2bkaqpqh+CLV7Q@mail.gmail.com>
Subject: Re: iptables 1.8.5 ETA ?
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Etienne Champetier <champetier.etienne@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le mer. 6 mai 2020 =C3=A0 08:09, Phil Sutter <phil@nwl.cc> a =C3=A9crit :
[...]
>
> If above goes well, maybe release next week to leave at least a small
> margin for any fallout to show up?

Sounds perfect, I can wait for more fixes :)
Thanks

> Cheers, Phil
