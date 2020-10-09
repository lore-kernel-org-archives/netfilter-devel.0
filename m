Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B47CC433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 05:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C49D2222F
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 05:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfcRmd/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgJIFqA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIFqA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 01:46:00 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE4C0613D2
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 22:46:00 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r10so3257550ilm.11
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2020 22:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=oxDTFUGUVHMU7Th8h65c2OQnmXugK+2hj8fa/LE+VCs=;
        b=OfcRmd/X6riUsXwXtjPOu1nEPr9BqFuPRuS3w0qQ5fPJOuguvjAvMBwSfOB0JtG3Sz
         r5Az/eV9PcuJ6lXXGXUaKXA51Q5F+6tDe7hEbI0cMBx6lWE+0nrI46Yi7HsAjcW/Or6o
         ouC6v71anKThUmM0hxm51wcA7xOOeuJsKo8S6UsxOUVHvrPg08WV0UuunmEP0Bzzx8WN
         lxGvS7SM9SrbLv3wuhZnUTVdc1XsuBsTINHFDg15DitcIPAlRTeG1trRSiC1cF4qG1o9
         fBe/cgyynUuOAI2Vl/zC8j+WOAbBcHCKAKC4AH17dFRbl84pSsMiUr9RWPST9Gszx8G1
         ZQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=oxDTFUGUVHMU7Th8h65c2OQnmXugK+2hj8fa/LE+VCs=;
        b=OLIG8VheVXiNL3OWFIBhXhI1QLY+T+7NaNwJvPQLGtW4Au5i2/Co36C8f3VKkolTJN
         A751oSglbbvJUXReNyvRZsfKGiQ/Lnc0rzOOT6TCV7m96LZ0vhSlR5z9tlwwZ7IEnJOL
         ip26Yve5HP3XqhreZoCKoz2lIqFAXVZoJZi2iF1Ufly9NXXSnrTIn9lHV7a2jcKonUx4
         1lOFP/vdtyEjcJpu0rJMPF8GSs56stsNBJS8kFHTcMZpFTo4hbX1DbSM8PIShtqiIHA3
         KXhrw2Mb0VtC1Rk6q+Kn/FIfod6SqmuSbd2E/8Yw+FfX6u9ALal29tYEE8Pc2smMOm3Q
         kj7w==
X-Gm-Message-State: AOAM531KtNAwN524tizX4GowiryWOCZENcZDUSlXEcCa4qE4/FJUAlE1
        RU5UEwPkFk36xabPz56Mjo+PHicCHLddkwu3KWHBxMzl0ws=
X-Google-Smtp-Source: ABdhPJwxgaO47yiCXf0J+cBLPmwUThfgT+AV2guYXjZUDyvldZavyNtSdneNCdbMqio8Tid32Fyq4lhuVv/8JaOBSlo=
X-Received: by 2002:a92:4142:: with SMTP id o63mr9610469ila.138.1602222359810;
 Thu, 08 Oct 2020 22:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20201007140337.21218-1-gopunop@gmail.com> <20201008170245.GC13016@orbyte.nwl.cc>
In-Reply-To: <20201008170245.GC13016@orbyte.nwl.cc>
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Fri, 9 Oct 2020 11:15:48 +0530
Message-ID: <CAAUOv8hXEA=2fM5UBN8xGkquO9EHMzCQ=kdEyFukDK7zPSeXow@mail.gmail.com>
Subject: Re: [PATCH v2] Solves Bug 1462 - `nft -j list set` does not show counters
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 8, 2020 at 10:32 PM Phil Sutter <phil@nwl.cc> wrote:
>
> On Wed, Oct 07, 2020 at 07:33:37PM +0530, Gopal Yadav wrote:
> > Solves Bug 1462 - `nft -j list set` does not show counters
> >
> > Signed-off-by: Gopal Yadav <gopunop@gmail.com>
>
> Added a comment about potential clashes (json_object_update_missing()
> hides those) and replaced the duplicate subject line by a commit
> message, then applied the result.

Any description of those potential clashes?
