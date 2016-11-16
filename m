From: Eric Dumazet <edumazet@google.com>
Subject: Re: netfilter question
Date: Wed, 16 Nov 2016 05:33:48 -0800
Message-ID: <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Desrochers <ericd@miromedia.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35289 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752808AbcKPNdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 08:33:50 -0500
Received: by mail-it0-f49.google.com with SMTP id c20so209469803itb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 05:33:49 -0800 (PST)
In-Reply-To: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 16, 2016 at 2:22 AM, Eric Desrochers <ericd@miromedia.ca> wrote=
:
> Hi Eric,
>
> My name is Eric and I'm reaching you today as I found your name in multip=
le netfilter kernel commits, and was hoping we can discuss about a potentia=
l regression.
>
> I identified (git bisect) this commit [https://github.com/torvalds/linux/=
commit/71ae0dff02d756e4d2ca710b79f2ff5390029a5f] as the one introducing a s=
erious performance slowdown when using the binary ip/ip6tables with a large=
 number of policies.
>
> I also tried with the latest and greatest v4.9-rc4 mainline kernel, and t=
he slowdown is still present.
>
> So even commit [https://github.com/torvalds/linux/commit/a1a56aaa0735c782=
1e85c37268a7c12e132415cb] which introduce a 16 bytes alignment on xt_counte=
r percpu allocations so that bytes and packets sit in same cache line, does=
n't have impact too.
>
>
> Everything I found is detailed in the following bug : https://bugs.launch=
pad.net/ubuntu/+source/linux/+bug/1640786
>
> Of course, I'm totally aware that "iptables-restore" should be the favori=
te choice as it is way more efficient (note that using iptables-restore doe=
sn't exhibit the problem) but some folks still rely on ip/ip6tables and mig=
ht face this performance slowdown.
>
> I found the problem today, I will continue to investigate on my side, but=
 I was wondering if we could have a discussion about this subject.
>
> Thanks in advance.
>
> Regards,
>
> Eric
>

Hi Eric

Thanks for your mail. But you should CC it on netfilter-devel mailing list.

Key point is that we really care about fast path : packet processing.
And cited commit helps this a lot by lowering the memory foot print on
hosts with many cores.
This is a step into right direction.

Now we probably should batch the percpu allocations one page at a
time, or ask Tejun if percpu allocations could be really really fast
(probably much harder)

But really you should not use iptables one rule at a time...
This will never compete with iptables-restore. ;)

Florian, would you have time to work on a patch trying to group the
percpu allocations one page at a time ?
