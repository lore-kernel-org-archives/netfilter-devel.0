Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA7DC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 06:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5338218AE
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 06:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCtDurub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfCUG12 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 02:27:28 -0400
Received: from mail-it1-f171.google.com ([209.85.166.171]:52223 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCUG12 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 02:27:28 -0400
Received: by mail-it1-f171.google.com with SMTP id e24so2743883itl.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 23:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qhjozmuYeA9euRZvh/sKpGqakCtpZHyBGmj4VuVxIxo=;
        b=jCtDurubwFIDTieBHB5RT6sG6N449lgwAjTi+/jKPoA8pARoeEBiOSXHC2Yughl9Q4
         rPB+KEgVa/UhcvvIgQfZhez4SUdbK5Y8wmTkJwbSVMH8Rm5KX3yd94I1rBXQy0vHbfb8
         ofbuO4Jof961TlPcW6wWCkW3yFG8UacSiAPWbfBMZ6YBcVN9JWdB1yRZcDQASh98WYa7
         kSki6a4D2g4THPl/0DnFBq9m/zHJrlmgMezByP2+kRpsTPsL6JUHWE423WMb1dHlOclN
         hYJfqalio+3LUDzh0o7xVux5KM5lSI87OpVMC+OhXl/zf6nGgraMDGXLYuvVH3CllJai
         Fl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qhjozmuYeA9euRZvh/sKpGqakCtpZHyBGmj4VuVxIxo=;
        b=hNZb4szx+I7XPcMcPuKAEUhJcrPICuNAfHJg5pTquio7HMwscpkSRd8HQ7Cm13zsUQ
         rmoTcCxuOsiOnbeYiMaN5E7DBL49kpvNK0TcOh5xIn4/0fXOcMYr9sDOAJw7IhoiiAY3
         fO6KiMqbzAPp6Z141RsxpIR9SkPziOO8mpeR3xSykDac5fHeQNnC+ozPWL0mE9/AzVH/
         LSQzwAmg8Cm19Y8yAz0eetFsCxHRhDvp6++7f6QXsuph6r0DFm/OBQA0+EX0v0Cwt9k9
         HBg0O9T50KwZDz072ChCN4I+cYKnxgaQubySGfDRk+rf7ncjeomPGuVU8+QGH+GV5TEl
         mwNA==
X-Gm-Message-State: APjAAAVv8cTz1K6kPCvlKeb6FU6N3kj6phx3MHJyAvdtS0McslGafTDM
        71fAb3MVAZDr8jO2Q2IxjC+8U6vYnsTL1JmzlUIsTw==
X-Google-Smtp-Source: APXvYqxVSpDqfqX+jUYUzjhBzu4SatDIcWBG8khkD0YcW0HzLs/Ly/Oa7SgOsbximOwawGh3xY1cNJZu3+S49cE2IWw=
X-Received: by 2002:a02:8c17:: with SMTP id l23mr1616246jak.20.1553149647073;
 Wed, 20 Mar 2019 23:27:27 -0700 (PDT)
MIME-Version: 1.0
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Thu, 21 Mar 2019 11:57:15 +0530
Message-ID: <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
Subject: Implementing Deletion of Set Elements in Rulesets
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
I'm trying to implement  "deletion of set elements in ruleset". For
which I wanted to understand the way existing set operations are
implemented.
While grepping through the code I have noticed that the implementation
has some parts in the kernel, libnftnl 's dynset and the userspace's
netlink_(de)linearize .
I'm unable to get  a clear view of how the control flow goes from the
userspace's `evaluate` to the kernel's `nft_dynset.c`  in case of the
set operations.
Can someone please share some pointers in this direction?
Also how does the `set_stmt_alloc` in nftables's statement.c relate to
the `set_evaluate` in evaluate.c ?
Best Regards,
Karuna
