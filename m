From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH v2] netfilter: xt_hashlimit: Fix link error in 32bit arch
 because of 64bit division
Date: Wed, 28 Sep 2016 11:32:02 +0900
Message-ID: <CANP3RGeJbCf=1Y+R-3NiZx+QWbXX14fxp+41AAG0NWd73S8bfg@mail.gmail.com>
References: <20160927135718.GA31297@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, johunt@akamai.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Linux NetDev <netdev@vger.kernel.org>, pai.vishwain@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, zlpnobody@gmail.com,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:33113 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756481AbcI1CcM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2016 22:32:12 -0400
Received: by mail-yb0-f173.google.com with SMTP id 2so11796398ybv.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2016 19:32:11 -0700 (PDT)
In-Reply-To: <20160927135718.GA31297@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I don't think you actually need the backslashes since this ain't in a
MACRO definition context.
