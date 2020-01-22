Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF7BC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A83B21835
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="VG+pSGaQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAVV3n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 16:29:43 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40051 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbgAVV3m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 16:29:42 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18so710071ljo.7
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 13:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxPhh7N7fIA127zr04oMv8OimndCsehwtjANlH0ufAg=;
        b=VG+pSGaQEHZ01TdE6+inaGCl7YIbKV9BQclbGxGKMBuWJI1/IniG8OJQ/PmZgSAqRR
         8E8az/WCM9eetPppdm2WfrskxLGjsmff77/uc0ifBf4LCWMBMWgyB5A8y/pMa9fCtBkS
         iPAVZl36IuQJFXEK7CcgeOT5L0sv/ij6f/gHyxRD+QgVwSaFAk8HURScNnari2n6kEcI
         IVUqWDdrv97oGI7vkGBLqlZNOxueQ8DNFJaxgE8pWiVnqjpv93ZTkEm3y+GrS5vo9eh6
         mqxkeG5NAUIG65H1IVdlfGB6ZlFASVR9vEtQwZl+aYxBvcEIT5ACrAVI9oB6zVzvUnZp
         PAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxPhh7N7fIA127zr04oMv8OimndCsehwtjANlH0ufAg=;
        b=fba3nO4XEGtSCltd2JHOONB23EQLjmpbIP5lJ952NjWjsYsMM7xkGMVtIpUlREARO2
         edMt5q/j/jm2+AJ7UqAeeG/QU2Bo7hQ3eFiS+uEjzEGEnTMw4qu05mulqUiUn7mofKIo
         QUIZZqnxQpU4TUqwJ/mkn6sd3uYzwYUQln4e2J1RkhOjq0gbgKRQRypsVt9G37CrxOvx
         PsxrwzJLmKimZUfkLLuj0V+wjwCfhfPEIy4J44CKcdrHq2VirizaRfdLgs1HrVb+BrVI
         AdM0PY7OAFNlk+Xy6i+sKscVdFtzanwEeenlwjwUjk4exhLpLYXS8O4z8bj5o2PSdZWe
         MNjQ==
X-Gm-Message-State: APjAAAW19zxLpzWzwYXyUe4gJnFAm6u508urmeiPB8g9JqH2VPMxBCvX
        J0jtcD/aFOSLCfdHNHHPSxJyIU5JhDOqx0fFkGux
X-Google-Smtp-Source: APXvYqzeo+JIXOnTNsp8hlNCS0EhcIav6k16IWLVBCjbo48MM+ye9PmS2K9sFncvQx6VkvN1QXW6bcGPUW1n+S8axUk=
X-Received: by 2002:a2e:870b:: with SMTP id m11mr20503341lji.93.1579728580019;
 Wed, 22 Jan 2020 13:29:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <229a7be1f1136906a360a46e2cf8cdcd4c7c4b1b.1577736799.git.rgb@redhat.com>
In-Reply-To: <229a7be1f1136906a360a46e2cf8cdcd4c7c4b1b.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:29:29 -0500
Message-ID: <CAHC9VhS2h8LfYCZOkjmvSkJ5rXXJTEkRwrBMHZW=TYkpaKVUyA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 15/16] audit: check contid count per netns and
 add config param limit
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

On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Clamp the number of audit container identifiers associated with a
> network namespace to limit the netlink and disk bandwidth used and to
> prevent losing information from record text size overflow in the contid
> field.
>
> Add a configuration parameter AUDIT_STATUS_CONTID_NETNS_LIMIT (0x100)
> to set the audit container identifier netns limit.  This is used to
> prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
> messages, losing information, and to limit bandwidth used by these
> messages.
>
> This value must be balanced with the audit container identifier nesting
> depth limit to multiply out to no more than 400.  This is determined by
> the total audit message length less message overhead divided by the
> length of the text representation of an audit container identifier.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h      | 16 +++++++----
>  include/linux/nsproxy.h    |  2 +-
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 68 ++++++++++++++++++++++++++++++++++++++--------
>  kernel/audit.h             |  7 +++++
>  kernel/fork.c              | 10 +++++--
>  kernel/nsproxy.c           | 27 +++++++++++++++---
>  7 files changed, 107 insertions(+), 25 deletions(-)

Similar to my comments in patch 14, let's defer this to a later time
if we need to do this at all.

--
paul moore
www.paul-moore.com
