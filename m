Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0BEC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A37321721
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEgnQjrI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfE1QPW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:15:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42949 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfE1QPW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:15:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id i2so18281074otr.9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 09:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=WAFLQ2PDZjzRWQPzEu6g2JSrl9fP+TtyJsst6vBFWWM=;
        b=YEgnQjrIXisV9ycxX9KKv5t63PjnuOottJhT5LO9BckUbORF3he2gMCUFy11+tZXP4
         LW2Q6+mk9XpY0Q7RG8MJ7ofMbGXSRMveRpm+P5vZCNkZQGioA0/BHueMH6mlv3XeBSPm
         kvFYV4CxsqjM0cIIu67gLT9IeAX320HusEdf/eXQsfCIwgwBHVzBIzJCfsaOnOt+OPOi
         NgfV00jpRgR9k7hse948yUmkC51f2ATSAiFpWbDLo9XSKxkZ0co6gvfOc+S7bx+0yA8U
         UJPvY+OlumDJ/Ty9zBXi+8BvP26GJUlkkageNzJBre1mePp6QYOpQWl8/7S4bAZooyd4
         fG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=WAFLQ2PDZjzRWQPzEu6g2JSrl9fP+TtyJsst6vBFWWM=;
        b=K8WAcv/gesOvQz4P6OgZMUrlrxfJHF9uhTAdxTTqIlXrZAg9Bq9lrQs946KC7PVkov
         Tu+dIffjkDPfdY8YZUQhHlNNEZBe9sIARSlKWqqU2D71ILC8cQpXvdzAYEMBKOwVOIm/
         QssLhvKn+oQXnZvsTYIacrzK8dvDhXtpGsjKlM81xOEtZV43qh7VfNY6Hj95UoUfYi86
         rN5GcskTm7Qfr5z2CR3eK268VQpQMhQVhT4PaqNFuEJn4JEoPoXOarcLpSGF4TaNp7T+
         VMnVqOZ1C8BR3AAOu8sJqoWgw4BTPt0xzL5HMDS3S339qoZZZikn/PJxPBClLob3K9uw
         pfhA==
X-Gm-Message-State: APjAAAUszGimO9hdrS4I3rCNDCGGLPOvX8oqAgoq5QHgQz4HNZOqzaSO
        pIOypzIqt4IJuH0phW8/cJ7vjGQNn5mNsg+SexE=
X-Google-Smtp-Source: APXvYqwPT4fpe/9eMbKrrwydP2yJSNXDpI0/ynahYoLgvoL3Ryzc1jbqqb4qjTedfAeZML7igBkbtABPdSTeyFmldz4=
X-Received: by 2002:a9d:6c89:: with SMTP id c9mr26268562otr.52.1559060121191;
 Tue, 28 May 2019 09:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190528002113.7233-1-shekhar250198@gmail.com> <20190528160917.GC21440@orbyte.nwl.cc>
In-Reply-To: <20190528160917.GC21440@orbyte.nwl.cc>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 21:45:09 +0530
Message-ID: <CAN9XX2q5ttjtatWQ-PjrHzOUiyAyVatLMKdN4fhpVpKh+autxw@mail.gmail.com>
Subject: Re: [PATCH nft v3]tests: py: add netns feature
To:     Phil Sutter <phil@nwl.cc>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 9:39 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Tue, May 28, 2019 at 05:51:13AM +0530, Shekhar Sharma wrote:
> > This patch adds the netns feature to the 'nft-test.py' file.
>
> This patch does more than that. It seems you've mixed the netns support
> enhancement with Python3 compatibility enablement. Could you please
> split these into two patches for easier review? Being able to clearly
> see what has been done to enable netns support will be helpful later
> when scrolling through git history, too.
>
> Thanks, Phil

Sure, will do that and post the patch again.

Thanks!
Shekhar
