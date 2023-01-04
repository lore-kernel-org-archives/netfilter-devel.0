Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6649C4708E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Jan 2023 09:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjADJwJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 04:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbjADJv5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 04:51:57 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBA1186C6
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Jan 2023 01:51:57 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d17so12636620wrs.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jan 2023 01:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHNwy9YdwCF+kIUHQZa1WGm6NwlGw1SW3A8v1+xToHk=;
        b=Fal5mE8y1TecfZsbbK/hVp+n1X1ISNe7wTuYyWUXIRoJNvzghckJd0iz3/by22WKLJ
         IrwtJEN2JUuhyHhwEKTcpRQH7RGhjxPEnzDFByb7Qd7CkDpIj4M9EB8JczxWgj03d/fW
         aY0pAZJHjKooVvMgj+uNPc55ALDgu3cbFkMnfZ4HSQ99lPQaxOvFlMmwrJBM7QOOykmA
         lm8IsuVT1rtz39Ccb60rzDjr8S6O/iGQhs4Uuy2EPk+541BgEYANzpUswyo73MoZi+Qx
         sJsqnOXDpHXP3togK+nD+07nW8/4OJUKXLINJJ59vNJA4toJGUT5EzI/lEVOhLi9O4RU
         2gLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHNwy9YdwCF+kIUHQZa1WGm6NwlGw1SW3A8v1+xToHk=;
        b=TWG1vg8JwVawowqpnRXnuKvxq8nQiOWqid2F/sbqzLGn0dhPCZ0BRqaVsLNIYJ8lvi
         R82oRdxUxZt1/nJ3pknRsiw2Fs9Xo3aLcuxy1bpzZSC6evn8TJ3Rd2lIxXINy3MGXjIS
         obGhCffDqH0LJxLYpsUtOqDvGO+34TQ2mwMeq92hIYq1ADN9kv8FuSb9ohmBbqdFmHts
         bY3Gevp8Y162LxCbFzIzKm1paz8+nHqgcBHv2k3+kpOcWv8sf2gpaZOSYDrrPj2yHUhB
         +R28z8G5ofGhgmhDkdsaWg4WOBCkvB2LMNXr0EKcQHO9hFPkoaT8cf+WdhWcIYvHRlV5
         4Rdg==
X-Gm-Message-State: AFqh2kr48a8Oys82zRfcH1z3Hsv9C8qdmBH0vIcBUuol5mWjckxLF0P/
        RzhuGiwoOahKYJBHJaDLmGyCxg==
X-Google-Smtp-Source: AMrXdXs3oHaphRMZI3GWPUAhS9F31Li6G/YOpeh6h59dTJ9wrkoD8M8gmzNvkJbGTsY/NcMVuk2j8Q==
X-Received: by 2002:adf:e901:0:b0:24f:b819:f4c0 with SMTP id f1-20020adfe901000000b0024fb819f4c0mr33207491wrm.6.1672825915694;
        Wed, 04 Jan 2023 01:51:55 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id a6-20020adfed06000000b0028e8693bb75sm18230396wro.63.2023.01.04.01.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 01:51:55 -0800 (PST)
Date:   Wed, 4 Jan 2023 10:51:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next 04/14] netlink: add macro for checking dump ctx
 size
Message-ID: <Y7VMOhZLZDLAzo3m@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:26AM CET, kuba@kernel.org wrote:
>We encourage casting struct netlink_callback::ctx to a local
>struct (in a comment above the field). Provide a convenience
>macro for checking if the local struct fits into the ctx.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
