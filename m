Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61EBC10F14
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE12A2190F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Ebgr6hpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfJKAlM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45064 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbfJKAlM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:12 -0400
Received: by mail-lj1-f195.google.com with SMTP id q64so8010704ljb.12
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2019 17:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wNy6JFK5djKAuZbuRMlDS+XyW8tF2WH1HB98CJhwX4=;
        b=Ebgr6hpepFByF0DkP5utDnq8dgpXwryts91lmQkxebHKHDitPBleV83coxn3yI9W2o
         4bjKmKWCPPjMPhL8Nq/Rdml5kvyzOdaMmxDE1iIeADKjQ4B3ePZan8TAafgqsmoQqDBo
         DPSQq0Dom4ILIzKaOPRAGB6iBjZKCOwLqRUsFj6Doy+Ihf3ofxWf6aVnflJ+uXxgpKYc
         bbkJw50tNvEfHUPIhBMY1Zh/pD7QtrHNUoMxcmVpT5dFWXFUE49Oh+2y3HcTvrkmCGKi
         d1cVCQqj7IfTxrHF88A0gj3Twf8bqPV2nRUrW6tYaMCpO+AnG3VtKUhbnJoR6lVbp5wI
         hqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wNy6JFK5djKAuZbuRMlDS+XyW8tF2WH1HB98CJhwX4=;
        b=GIatYkkB1zgMK1R7mFqM8WF/VfSidVZ2VC2acDIrT+HgyHjhv+CywJer6V2h2qT3Jc
         jNkoqOpRnckflW0lTlbJjiHQqA7v9E4V/pf4ubaFJA+NHpXzQlskKz1tvDYyWwDK61HM
         GLDrFaHOlQJYOr3RhFJ0+xWMu6RkSBVylqZNQIANjqBmfLHiH223T1D42bQtj1+LBvwP
         PZ7FMwbIeVdKrv76shPW8+BMnVN2NGgeL1hDBJsBPdioaL+J4mOR9BPITV7219mjhRsY
         XxzGQRSU00ySO+i5vJWFfjfyHbef01eq2gKdxWfAEqEzesi1lI/O4VExDgino2rCD0vo
         P3RA==
X-Gm-Message-State: APjAAAWpL/cA094TYw+dxFK2ADl6FbTbXe9ujixvJg0+WYSl7+33dV9q
        BqbFV0PQ6t17WujMUaotE3XaVBGwXrlfpbRe7fCv
X-Google-Smtp-Source: APXvYqyMEnp+g0nirg0RbsN817lbDmHEIQg2bqDza4Lalp8B5gyrzCzWjpLPJS7tANwgfZue3U1+820n9L5ACEXWqxU=
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr7770213ljm.243.1570754469730;
 Thu, 10 Oct 2019 17:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <a6b00624ac746bc0df9dd0044311b8364374b25b.1568834525.git.rgb@redhat.com>
In-Reply-To: <a6b00624ac746bc0df9dd0044311b8364374b25b.1568834525.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:40:58 -0400
Message-ID: <CAHC9VhT3QNHxXCc_QsC5K5HadAv7AqwNw-Fk+yLECquE_dKmfQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 18/21] audit: track container nesting
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 18, 2019 at 9:27 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Track the parent container of a container to be able to filter and
> report nesting.
>
> Now that we have a way to track and check the parent container of a
> container, fixup other patches, or squash all nesting fixes together.
>
> fixup! audit: add container id
> fixup! audit: log drop of contid on exit of last task
> fixup! audit: log container info of syscalls
> fixup! audit: add containerid filtering
> fixup! audit: NETFILTER_PKT: record each container ID associated with a netNS
> fixup! audit: convert to contid list to check for orch/engine ownership softirq (for netfilter) audit: protect contid list lock from softirq
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h |  1 +
>  kernel/audit.c        | 67 ++++++++++++++++++++++++++++++++++++++++++---------
>  kernel/audit.h        |  3 +++
>  kernel/auditfilter.c  | 20 ++++++++++++++-
>  kernel/auditsc.c      |  2 +-
>  5 files changed, 79 insertions(+), 14 deletions(-)

This is my last comment of the patchset because this is where it
starts to get a little weird.  I know we've talked about fixup!
patches some in the past, but perhaps I didn't do a very good job
communicating my poin; let me try again.

Submitting a fixup patch is okay if you've already posted a (lengthy)
patchset and there was a small nit that someone uncovered that needed
to be fixed prior to merging, assuming everyone (this includes the
reviewer, the patch author, and the maintainer) is okay with the
author posting the fix as fixup! patch then go for it.  Done this way,
fixup patches can save a lot of development, testing, and review time.
However, in my opinion it is wrong to submit a patchset that has fixup
patches as part of the original posting.  In this case fixup patches
have the opposite effect: the patchset becomes more complicated,
reviews take longer, and the likelihood of missing important details
increases.

When in doubt, don't submit separate fixup patches, fold them into the
original patches instead.

--
paul moore
www.paul-moore.com
