From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Thu, 18 May 2017 09:41:58 +0200
Message-ID: <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com> <20170516082128.GB16290@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:36599 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754814AbdERHl7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 03:41:59 -0400
Received: by mail-yw0-f177.google.com with SMTP id b68so17007037ywe.3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 00:41:59 -0700 (PDT)
In-Reply-To: <20170516082128.GB16290@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have seen this trace couple times before, and also the fact
that 4.9 had been running fine since the release makes me suspect that igb
is not to blame. What can I do to provide additional details here?
