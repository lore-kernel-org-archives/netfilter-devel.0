From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Tue, 20 Jun 2017 12:28:44 +0200
Message-ID: <CAJO99T=5RPz691h9kAnSsC4fy_54o3qWU_2o-4FhHrxp5af7MQ@mail.gmail.com>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
 <20170516082128.GB16290@breakpoint.cc> <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:34162 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdFTK2p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2017 06:28:45 -0400
Received: by mail-yb0-f179.google.com with SMTP id e201so31946315ybb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2017 03:28:45 -0700 (PDT)
In-Reply-To: <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-05-18 9:41 GMT+02:00 Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>:
> I have seen this trace couple times before, and also the fact
> that 4.9 had been running fine since the release makes me suspect that ig=
b
> is not to blame. What can I do to provide additional details here?

We have done some adittinal debugging on this issue, where we also tried wi=
th a
broadcom gigabit ethernet card, with similar results (not the kernel
crash, but machine
comes to a complete stall due to load/io wait)

When trying to narrow down the problem, I removed the NAT rules, and
in particular
the

chain postrouting {
  type nat hook postrouting priority 100
}

And the problem disappears. Commenting in the above block again,
causes the following to happen:

kworker/0:0 starts to use more and more cpu, and in less than a minute
renders the
machine useless. If network cable is unplugged, it takes aroung 30
seconds for the machine to get into a useful state again.

We are seeing around 40-60kpps on the link. This bug is introduced
somewhere between
4.8.6 and 4.9

--
Bj(/)rnar
