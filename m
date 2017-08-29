From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] examples: Fix memory leaks detected by Valgrind
Date: Tue, 29 Aug 2017 23:39:59 +0200
Message-ID: <CAOkSjBj1bFkszY+HAOJP+tkU08pXJJGPgY6ZXn43OPaxw0O4=w@mail.gmail.com>
References: <1504010976-13897-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35792 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdH2VkV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2017 17:40:21 -0400
Received: by mail-wm0-f49.google.com with SMTP id a80so4945881wma.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2017 14:40:20 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com. [74.125.82.43])
        by smtp.gmail.com with ESMTPSA id g35sm1663786edd.34.2017.08.29.14.40.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Aug 2017 14:40:20 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id u26so5729773wma.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2017 14:40:20 -0700 (PDT)
In-Reply-To: <1504010976-13897-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Shyam,

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

in the future, please add a tag to the [PATCH] header, like "[PATCH
libnftnl]" so we can easily know to which tree this patch should be
applied to.
