Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4675C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A859321721
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfWjYgnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfE1QOG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:14:06 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43281 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1QOG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:14:06 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so18274494oth.10
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=T4tRJZ0yu+PorxcRuKxY6pVOo4Vc7bh0iUW3quMCQtg=;
        b=GfWjYgnmmWEqvbN4FFM5T4nJgEybXQBo1NL8DUiFIo5mX1Ln3CUKPulBcUiXauqx0e
         lh6C4r2mQmigc/DY8Kol6EnycFWl5ZAbqJe3lym6P9FMzvmkPucog0lRI2PX6/G1T5Qd
         fji4NCaWVYnllBFst/ABjzj6jPTdqNLDbclUv1rSFFjjGZgs8HmfSfCJFng6B2BrCi+B
         5aw1et8fGVnfH0pjG4Us0TNVQ03lcvFDtCl3AqEGSka+TQBaad3VOMypwuV3gpZA2TRt
         jDpQdAe3y6p3T4a0KMvoMQBpdwA7RPHqrbKBfO79KO7sfbRK9S18oRzjK3WlqQchC50G
         Kacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=T4tRJZ0yu+PorxcRuKxY6pVOo4Vc7bh0iUW3quMCQtg=;
        b=hevx6uwM5MgH6aEMmmjX2s7zDpeBRFEI26kBUIWmgqrZ3ueJ9Wbw59v1udlrVJ5J/C
         JoQa8QarJ9dFNGoxhDOZj6fZL4lBRrbzgPzINUurwMC0z8OAOio+B3c4wQcOkfD/akew
         yIkd37LHVHCQX2+0/u3bw/luMYj40qfiR50a91rmKuQlFzxKaEbruy0fyBk9i3FnL4/a
         3UCVKfjFYfDu7iiAPDDZMIm3BWnydJ5f2ykhfw0sOQslNnpWLh2KrVkA14kE6g4tRgH1
         /EYJHDCTpcXt7KRbXp2Qe9+FX8bVvXRs5edKP2RuQ5xIA0DOJQoKIrSSJE8dHxB431iW
         z6lw==
X-Gm-Message-State: APjAAAWouPOPdwt/r5/+ZONB0eTrda6+6kE5rEm6XZnXM1dID1AsLKdI
        hxqeabf4cvxOjkAYzfiTRaqi5YDJvyGL+t17LbyYkg==
X-Google-Smtp-Source: APXvYqyDfTvipRIWQDD020a4RJdKsJ4jLB/8b5m5kopTGMJOHjURqs6a/p1N3Rx+psO7qcduvsZmURU26PmpMtxeRH8=
X-Received: by 2002:a05:6830:1d5:: with SMTP id r21mr22975536ota.155.1559060045051;
 Tue, 28 May 2019 09:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190528003653.7565-1-shekhar250198@gmail.com> <20190528160617.GB21440@orbyte.nwl.cc>
In-Reply-To: <20190528160617.GB21440@orbyte.nwl.cc>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 21:43:51 +0530
Message-ID: <CAN9XX2ronY=gBVbjZrL2_ytycDiYCTm7qRCqYeb-zbxgELzy0Q@mail.gmail.com>
Subject: Re: [PATCH nft v2]tests: json_echo: convert to py3
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019, 9:36 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Tue, May 28, 2019 at 06:06:53AM +0530, Shekhar Sharma wrote:
> > This patch converts the run-test.py file to run on both python3 and python2.
> > The version history of the patch is:
> > v1: modified print and other statments.
> > v2: updated the shebang and order of import statements.
>
> I personally prefer to keep the respin-changelog out of the commit
> message, again in a section between commit message and diffstat. My
> approach is to rather make sure the commit message itself is up to date
> and contains everything relevant worth keeping from the changelog. But
> the topic is rather controversial (David Miller e.g. prefers the
> changelog as part of the commit message), so you've just read a purely
> informational monologue. :)
>
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
>
> Acked-by: Phil Sutter <phil@nwl.cc>
>
> Thanks, Phil


Informational monologues like these are very useful to people like me. :-).
I very highly value suggestions like these.

With regards,
Shekhar
