Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FCEC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0BA206D5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO9s2GNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEFLo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFLoY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 07:44:24 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EADC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 04:44:24 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id w4so1763140ioc.6
        for <netfilter-devel@vger.kernel.org>; Wed, 06 May 2020 04:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jtzU0sZOPdX5FbgdAAINvzrzWTLzUqccHXXnkXVokz0=;
        b=FO9s2GNWdWCaTfPpJixFUWXlchdMP9aXU0gYV802rp6/UBiUibzsXmU4VP26rciezl
         I0qsMjjAJs1tP+qvbZwQxEWByH6O9ZMsF+vgCAc7jgPDb1jzDC/APbLVF9/MULfjuLrV
         z33mfGSD6Iue2rdzIA5b0CDvCVl/yLgUteamsLdBJji4w5Kg+pkRaP9imR7s3AJTVtx+
         E3SmYxxQJlKC35sJuqBLSxJ1RndOQOTauBxBX3fzrk5VVbK0laYI7F49SOymTF4mUFWa
         wqZsxT+3hm3mrybgXDWQOsnQuHRE8UsbWSeuj3BA39beZbpcxyCxhioIU0o7JPvRLQj/
         O9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jtzU0sZOPdX5FbgdAAINvzrzWTLzUqccHXXnkXVokz0=;
        b=in9jQgycxkBeoXZCTYZifQpN45lgPelJFirvlf0FcXuZq0lAFo4yw5CRNyR/tjo1oh
         Y0tssyH0fi8OlWcpOuMlBsT9cp4fsKaTTwmXUE7dK6GlkYvBkGz1s7tFz4pwbP+JMwb7
         eTmPZ82M8M+MWI/82GfHa5kSJUcLs8yO3T3XsEdlxGYI8GkvpY45n+GSqng6xC9VvApk
         R76QG698e2WtWGz/hSrKpWLEtB6PxQNndp4g9OlYkLnKiP4rss5C6SmCTbsve676v0nJ
         MlMnmnDLMTmM2M5+gApvKQreU25Sefe0OCiAQ5MS7hAY2mewJoATh2jgviAewKXMfMs7
         U41g==
X-Gm-Message-State: AGi0PuaGGe/Urlqo9yl63jBSNTD5u0h+ymJoDo2eejZXQ8TdgIVAYLiX
        +BRc8JMWwrU4SHhayWXWm7Quc1cRfcNVIzx/5DGfOFfBJLs=
X-Google-Smtp-Source: APiQypICQsoQ6Pe/nus5scKinpZPUYzigYeiudjUi/234G5wdSj/aP/Q7Mc4PdgjE8DfJQSl//D+O56rlEtdFRbAAEU=
X-Received: by 2002:a05:6638:44f:: with SMTP id r15mr4401493jap.84.1588765463573;
 Wed, 06 May 2020 04:44:23 -0700 (PDT)
MIME-Version: 1.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Wed, 6 May 2020 07:44:12 -0400
Message-ID: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
Subject: iptables 1.8.5 ETA ?
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi All,

Pablo told me 3 weeks ago that "It might take a few weeks to make the
new release."
(https://bugzilla.netfilter.org/show_bug.cgi?id=1422#c13)

I'm sure it'll be release when it's ready :) but do you see an
iptables release happening this month ? (to know if I should just wait
or go ask maintainers for backports)

Thanks
Etienne
