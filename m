Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C16EB64D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 14:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjFVOvm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 10:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjFVOvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 10:51:22 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E181F2682;
        Thu, 22 Jun 2023 07:50:55 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-57083a06b71so63479497b3.1;
        Thu, 22 Jun 2023 07:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687445455; x=1690037455;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h8i9k7iv1RVJET/Cr/juNPiq2j0xcHXuSj+X6Emo+kQ=;
        b=TR6LpoiLpjDe4ONbyiH/m3qEgmQB3C8zRmRRQZUq3ZyMsIWg9cr1iem7vnC6S8DsFS
         dIxVIm3xtHjWFOKe5Z7/UUHd5LEYQbXeeQ+DDxb6aIGtp2ZhQAcjs7nXDg1DMc6P1O/5
         QPpkFNsEWP60Zg1JJdJqlCPYOqCUncsMySfoR1jkuh3O6Wnmpc5ff5WQsKhuRnctC4Sq
         hLKBxrPheccHBRGUlEAytiJa4mzHz7m6ZRUWr8srJS2xCi/HRVJUfK9DC4kNWE2dRXDt
         u7qNtBv/IuEKEtIONF8psmei4YIYstPhxF3srTq6/VQRqW70/MkBLvuCg8+eXRULXYQP
         uIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687445455; x=1690037455;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h8i9k7iv1RVJET/Cr/juNPiq2j0xcHXuSj+X6Emo+kQ=;
        b=ShsdvulG0kHmR7t3oB4R0aCrnomvHNSApOcvo0WFCazG6I9prK42WT9q4lSJlgpICA
         dJjAuQ5Ds+pZ5OmFJqeyfl0vBzlCeM7AE11lqFqwTVF32OjATdFg5BkBfJTiGtw5MbY5
         tz8ISHoV+YVzHcYE7DMvHdZwqBOBYuvqZaxV12eijZikA9YCj2QOhkVPb+z8eXxPuIwN
         n1yQY7ukGOfiD+u0zPqgh94/W+2Kg4evT66eVWVZQSmEG90h1W2bzgZhv1sju8hgQ3P1
         YnkUES4ZEylfXnwlCCNTopP9qHXg0z2lDQUCnwmb3lWGoyUz9kLl1d5dSl66Z5n6Oh9Z
         Po1A==
X-Gm-Message-State: AC+VfDxeLkKlLib+MjHg4LVl5RlRdTK+HjGjejyp2WV2Q2DigjaZ3WLG
        jS6H3ewTINOIAyAuEWL/7nu2S8mKs3U2bVfEBco=
X-Google-Smtp-Source: ACHHUZ5cZlyOFoP4CshYPHdGbrklMJMXRSZWHKv63RSFljlHi/JKlu6SZOMEdd3E/yhHrK8AQbv4hpSULI8CaAWSorQ=
X-Received: by 2002:a81:8492:0:b0:56f:f7f6:52d8 with SMTP id
 u140-20020a818492000000b0056ff7f652d8mr17840914ywf.5.1687445454810; Thu, 22
 Jun 2023 07:50:54 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Date:   Thu, 22 Jun 2023 17:50:43 +0300
Message-ID: <CAEmTpZGTbHcd84vA5VL6FfDc8+n+E0VMt+GpPkVLw5Vijp5iLA@mail.gmail.com>
Subject: ipset hash:net:port:net
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kadlecsik.jozsef@wigner.hu, kadlec@sunserv.kfki.hu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi everyone.

1. In the latest ipset, adding "1.2.3.4/0,tcp:0,1.2.3.0/24" is not
allowed. I would like it to be allowed. It should match on any TCP
traffic that matches source and destination.
2. The same for protocol number 0. I want  "1.2.3.4/0,0:0,1.2.3.0/24"
to match all traffic that matches source and destination.

These requirements come from the real cases, where an administrator
adds rules to control access to his networks.

Is it possible to make such changes? TCP port 0 is not real thing, as
well as IP protocol 0. So we can give them special meaning in IPSets.

although icmp:0 is not so clear in this case. Possibly allow to set -1
? as protocol or port for matching any ?

-- 
Segmentation fault
