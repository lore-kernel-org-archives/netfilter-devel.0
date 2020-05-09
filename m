Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BD8C54E4A
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 21:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5678D2083B
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 21:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rWXeKbbA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgEIVba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 17:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIVb3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 17:31:29 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CE1C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 14:31:29 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c16so4837379ilr.3
        for <netfilter-devel@vger.kernel.org>; Sat, 09 May 2020 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJ7z4VAJSx+xm7FsCX5ABKX2tbQO8xkYPxQslY9d7K0=;
        b=rWXeKbbANOWUUwP7lpX8Cf9DypzTSTus6AtVqPLXV/44YtFHj5dLS43e4UxvJdWVry
         gwleo1nb3nWjzEjj9K3w/eKzcAiNBlaqAtRX9yIXuOtxAocr3na/utdf6mExMDCvNdmM
         d7DK+79H5yESiqkR8KA/BALWvVCPgho//KlswpCxh08D/Ll90Ka/PzACPfpx5feJsrSd
         UcQjfBzYV7mYxN4rxPdH+WfIs6U3L+3kpZijJdaBG/vRoRMSmJTfk6pVz2PxTo1h4XsN
         zDMohhkIQ5vFvqUk19hlU1mgcfk4ntA++fv6c/7twKf647EPBqgO/iMVtIRgWNXSTMtj
         XqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJ7z4VAJSx+xm7FsCX5ABKX2tbQO8xkYPxQslY9d7K0=;
        b=DW83yaZhbNXKBZckbGIpp3j6lvxR8cZYnFaUy2bWfTX+hzCOtu2prI/yAHGzfIgxmQ
         rQN3RC3YDgt/yS+OI1Sxpl3wJ3nq1XU7T29iDNp1MPO4aZEVvcbD5BYW2y9ROrGoGf38
         YwBuQjOrM09fmQ1g9vypYUuaP/kkOHrUqqpcztM6bT23JHDN9eEvpeoTEA8n0Fhw3Va9
         t3EwSI8EHlnM1D+9H+xTEsQRXqFUV+eoA9viGYHCH+PWFi4LCk/LnfVfKPD6Q9zVv5jc
         tJyKnWEhu8mmhwci1S9NUSzxHsWZcjxFORnJqIePLQXX0R8SRAR48EniiaxtT65qFqFK
         SdGg==
X-Gm-Message-State: AGi0Pua8IyTwNZC0PzasVndbCue0cmuT+PKtBat/hP2ng/yQ35fw8v8Y
        l06uy9Ewmei8j/OA71wRU8ODZ+5kVPyOPiHHgAcP4g==
X-Google-Smtp-Source: APiQypKcAQjRZAeKQxjwrnh8OcxFNef9L1axiqwOy9aJfYL/oi19NkpaLm+EZzvOr9D2wLBWlSM9GkX0opkLZaeBXcE=
X-Received: by 2002:a05:6e02:544:: with SMTP id i4mr9590534ils.145.1589059888556;
 Sat, 09 May 2020 14:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
 <20200509211744.8363-1-jengelh@inai.de> <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
In-Reply-To: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 14:31:16 -0700
Message-ID: <CANP3RGcae5giBntjaXwU+EpuvayW+_S6mmHJ2H-xqtf1caVktA@mail.gmail.com>
Subject: Re: [PATCH] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also maybe the example should be:

instead of just:
-A INPUT ... -j REJECT
do:
-A INPUT ... -m conntrack --ctstate INVALID -j DROP
-A INPUT ... -j REJECT
