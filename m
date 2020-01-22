Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209E8C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6AD624676
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="VJNm7ixV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgAVV3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 16:29:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33478 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbgAVV3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 16:29:36 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so758526lfl.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 13:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T8dyZsx/1G1o4Km+D3AEjaFYjcDXoKwu76FXwqPPMog=;
        b=VJNm7ixVgyAguIeuR1pIXq0hv6ch7qgz5+W7axDIdGlhCNwpeyNJplyxY1npsTRa4q
         3AvFO2bN5r9I/mbrHMKFriPmjMXEUWYzS+PN/eLwCoaJhzX3jbPQJyRrX+O6IifhmS4t
         bAW5ztBvjxYTbpp9vIw4qcfvCMDSpuT8XuKqnlkWEusBikGN7eK6zxIwb+ANo0MusAUH
         y+2kEafA7mRzCvr0s6iDXqOBMqy0gyMtoVIoPF3UpKq+lYrO5MoIoGFloRBeyZfAnJAY
         cqsdx7KP8XS8YRJxgBSf+GmUDq5DSAoNnh1r2nnWw3k0ufdHWJw6q2xH0VYZhZTHi5df
         rQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T8dyZsx/1G1o4Km+D3AEjaFYjcDXoKwu76FXwqPPMog=;
        b=KsWiBnPvatP1ZVm+Bn/wfrgTHJgrx3UEEcAbUY85DBfirrVjn+01+I2yrfQ5sTAmDi
         MCxD+0pEpLq0lqHTgS7sz9gMa4Xgv4YvF3yq+RziRTp0fcFI3AfnbRBOUrRxoSytbGR+
         L5uAynWGi7U0KocqRk5jR1XaHTFCrFJzvPOVEFTDhhJURHE61QSTiKCwxmjyEu7kO7cv
         5BLhiaV2OpRj7UhH772OD7B47dtovbP1CifLzcijAfzyZ6g+cI3QfSlzjNJNcWt5fFr7
         bRp9lbdLNkGBrWFheA0//F6pJXWwBGcw9C0kLQem1KiXY3qLjiB7r8GoiM83UyccDZft
         HEng==
X-Gm-Message-State: APjAAAXEwLlyB/t/PSQ2Ui5GzqfalHSoCbmcFHcmjoCsBjK72ZVTQGqk
        AnsqepyaNuXxak2VhEMj8dAqWB/sk1mqK6UBMBYH
X-Google-Smtp-Source: APXvYqz71TZIg9MpEPSBX37Fh9pYf3NdlS4RNWJNnf5mBSZhvbWQtLxCouQ51G9Z/+VOzq252Xo+mwvfcQY+/hQ0B1U=
X-Received: by 2002:ac2:4422:: with SMTP id w2mr2853088lfl.178.1579728573496;
 Wed, 22 Jan 2020 13:29:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <28cf3e16f8440bcb852767d3ae13e1a56c19569c.1577736799.git.rgb@redhat.com>
In-Reply-To: <28cf3e16f8440bcb852767d3ae13e1a56c19569c.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:29:22 -0500
Message-ID: <CAHC9VhS5snVdRJ95ymCb0oX7dhM_6A5rdtKSRm4fo1xi0hA4NQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 14/16] audit: check contid depth and add limit
 config param
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
> Clamp the depth of audit container identifier nesting to limit the
> netlink and disk bandwidth used and to prevent losing information from
> record text size overflow in the contid field.
>
> Add a configuration parameter AUDIT_STATUS_CONTID_DEPTH_LIMIT (0x80) to
> set the audit container identifier depth limit.  This can be used to
> prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
> messages, losing information, and to limit bandwidth used by these
> messages.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  2 ++
>  3 files changed, 50 insertions(+)

Since setting an audit container ID, and hence acting as an
orchestrator and creating a new nested level of audit container IDs,
is a privileged operation I think we can equate this to the infamous
"shooting oneself in the foot" problem.  Let's leave this limitation
out of the patchset for now, if it becomes a problem in the future we
can consider restricting the nesting depth.

--
paul moore
www.paul-moore.com
