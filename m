Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6E1C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 05:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCGF2B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCGF15 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 00:27:57 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127BF57084
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2023 21:27:51 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p26so6995721wmc.4
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2023 21:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678166869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8M/ZNHm41J+Clg6mlxXrqT98RL27ba318OGQ7b+J+Q=;
        b=AXz8IE3BfGxvgHWARVu3cvmOd6P97RlW9noY25nWVCy6dXQ2vvPVZ9Py6kBKTNXlj3
         RGGCQe8dv+KR7SlUXWeg4O/QW8LuIHTN3sz2+J49IWOWaWZSnqHG+zwdQuVY+H/pQVAu
         F9xnuSl0vF/CiPxxoqZdBY5As2d0bOFPf01iGsYIwKPrv+7UuMKjhKDUTJ/CjAuIkHqe
         QiF24XnHbg6mgGw/2JMNF1CRC89YDDxSsVTPSCGpyM4sMgyw3xMrNYXJ+P/6jUxfQQGo
         zYkZjnrGLZrVFDSGBEFopoY1j+UVtcWWTiIotD6oCoQoVZsBz60ZhyC3s+t5/o19HC0v
         rNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678166869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8M/ZNHm41J+Clg6mlxXrqT98RL27ba318OGQ7b+J+Q=;
        b=XCxe6ceHbc21pXTjS0b9xGLogmsATJr99vCcMYZ+8eGxh9YJLWQsTpUyomisI95szW
         gyp3OI0O5eGtYF4b/WCg8cTQwmFZWrTwDXp1CB3k6v0hAzL64Mch7aeE3Mr37I3xm8k+
         zbgkzO62doJmLoQUvjcg+YRzTZAs/+YxUpptkUMkxIpUn2sjbpsMig5J9WG1iNoj8AYr
         4rm2CcVGeJRbnUBfnEVvftkdJrYbVUtqv2nXsxF6+07PqfeMBOsp1p21b0OCkDF36w8X
         rxWuAMZ4CUFmBB/d7uOAcCQ4ew0d9TY8m/478tWL2yRQ3qfpijE7LCY8/tiNkjWce+Iv
         Sc+w==
X-Gm-Message-State: AO0yUKXsx1FsYZV8ga8Z2xIW9xDeNzjkFDHcDxz/KDeqpgKPlfVsC4u/
        VBhkKMZPyQ/s5SviO96VST1IAM64pYPYy+2Adxm+1Q==
X-Google-Smtp-Source: AK7set+xWDoE/FuWr9saZhwuqb1gnA/rnnySOj/6SiypapxLJrV26Ug57td0Fc5DRpB4SqTyaxspNyemmIW2im9XebY=
X-Received: by 2002:a05:600c:688:b0:3e1:eaca:db25 with SMTP id
 a8-20020a05600c068800b003e1eacadb25mr2801113wmn.6.1678166869199; Mon, 06 Mar
 2023 21:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20230307052254.198305-1-edumazet@google.com>
In-Reply-To: <20230307052254.198305-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Mar 2023 06:27:37 +0100
Message-ID: <CANn89i+sfROgQUaNR+eMc2BWxtOjMmLgqsv52A1iLGhyydrBbg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: conntrack:
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 7, 2023 at 6:22=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> Customers using GKE 1.25 and 1.26 are facing conntrack issues
> root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
> max chain length random").
>
> Even if we assume Uniform Hashing, a bucket often reachs 8 chained
> items while the load factor of the hash table is smaller than 0.5
>

Sorry for the messed patch title.

This should have been:

netfilter: conntrack: adopt safer max chain length

Florian, Pablo, let me know if you want me to send a v2, thanks !
