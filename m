Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842A5C001DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 13:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjGZNie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 09:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjGZNid (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 09:38:33 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EAD213F;
        Wed, 26 Jul 2023 06:38:28 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-794d1714617so2512999241.0;
        Wed, 26 Jul 2023 06:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690378707; x=1690983507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cs/p7CEZuKxjp9osy4jGhfk2FuGB/ZhQkEOtsKZJ8ww=;
        b=nrshTphkQdtZw7WFXHJ9bbOZFP4jYem4nHD12FXabkaLkuPa+RPDtf5HA09yrKd1th
         LHt8gOlUP8nl07YfOAyKdc02fKmGxwVSX/9Xed3GC2xif02cGixvEfLq+IUdkCALUUcp
         OvERfyALoXeV+spqW+ExxDgUMg6yDMRt/LQ19s63Y8Fb3SXjeJYzuH24psq7RjHEUd1j
         yjoocYI2bj9xigqEbkAtBkxW9uGhjNr5KPclrHmXKK5sWDwrNJvtB7tSAUX/nD8DY1mr
         eX3zQ5Q4a251q8FhtZhNg1E7ho9U/9U1uZ0ymn1PXEKpsLvQLevJmeQbN+99l6quhPpu
         8sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690378707; x=1690983507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cs/p7CEZuKxjp9osy4jGhfk2FuGB/ZhQkEOtsKZJ8ww=;
        b=EmP1P7Fk/nJNkFknKT9Y1umUS+FcJVd2TYKSKHZBFv9D1olhk9yB9JdTIgZ7nl9VDr
         KMKKEH9khEiBnJQYcvGYWyESr5DhcrpOaXL9JuEAu16oYxizaX3XFIM4bvIHNBuu0JeA
         ueREst2MDFB5hwm1sOnIupWw8a2UUTlCwYM+YkhkoyoQ6f3cuLi06MKGuOcrVeNZmlHd
         Ag0Wb66Pm1S5dZkAPYY+Qi2NPb70ltzpx+1tfFJTH+COxpbSY8nOnJouOwo0T7EY6g7f
         pDoR5aiDZyqhHD2W2QkPHhQ5F6ZnEcTSh0AwfSVtv4ouq0Qd3HcoO2XoAr3fQ6Sq6RVE
         CptQ==
X-Gm-Message-State: ABy/qLbOhOdo6rebQAqUUrbmEZDYm1RtiZyCHQRYpN4PcTWGjBi75Oi/
        gOBGy6Y3q2L2uDGcZtnEd2+bVU1BuVL288j7wweZeu5BtpU=
X-Google-Smtp-Source: APBJJlEyguJ8p3ofKHVLX5kUQfrFC8murdqdMJdO4JoSGYJ2j+uDsO2D4D5M22Q1aVzNZCe/H98JLmvCd8a+PCVS1cI=
X-Received: by 2002:a67:ce11:0:b0:443:8f10:7f72 with SMTP id
 s17-20020a67ce11000000b004438f107f72mr1443798vsl.14.1690378707462; Wed, 26
 Jul 2023 06:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsTF21va8HhwrJc_yuVgVU6+dppEd-SdQpDjqLNFtcneQ@mail.gmail.com>
 <20230724142415.03a9d133@kernel.org> <ZMDTUHlPmns/85Kk@calendula> <CAA85sZs4RqJc51po=W-No-DMgWQGVa=hsRdRS5e6FG-F7SnZYA@mail.gmail.com>
In-Reply-To: <CAA85sZs4RqJc51po=W-No-DMgWQGVa=hsRdRS5e6FG-F7SnZYA@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 26 Jul 2023 15:38:16 +0200
Message-ID: <CAA85sZt46J5NJfja=Z-pHnoiS5bJphggf0us8UezmE1CsU8wFw@mail.gmail.com>
Subject: Re: Kernel oops with 6.4.4 - flow offloads - NULL pointer deref
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 26, 2023 at 2:00=E2=80=AFPM Ian Kumlien <ian.kumlien@gmail.com>=
 wrote:
>
> On Wed, Jul 26, 2023 at 10:03=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilt=
er.org> wrote:
> >
> > Hi,
> >
> > On Mon, Jul 24, 2023 at 02:24:15PM -0700, Jakub Kicinski wrote:
> > > Adding netfilter to CC.
> > >
> > > On Sun, 23 Jul 2023 16:44:50 +0200 Ian Kumlien wrote:
> > > > Running vanilla 6.4.4 with cherry picked:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/co=
mmit/?h=3Dv6.4.5&id=3D7a59f29961cf97b98b02acaadf5a0b1f8dde938c
> > > >
> > [...]
> > > > [108431.305700] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> > > > [108431.311107] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> > > > 0000000000000001
> > > > [108431.318420] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> > > > ffff9ebeda71ce58
> > > > [108431.325735] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> > > > ffff9ebe3d7fad58
> > > > [108431.333068] R10: 0000000000000000 R11: 0000000000000003 R12:
> > > > ffff9ebfafab0000
> > > > [108431.340415] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> > > > ffff9ebd79a0f780
> > > > [108431.347764] FS:  0000000000000000(0000) GS:ffff9ebfafa80000(000=
0)
> > > > knlGS:0000000000000000
> > > > [108431.356069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [108431.362012] CR2: 0000000000000081 CR3: 000000045e99e000 CR4:
> > > > 00000000003526e0
> > > > [108431.369361] Call Trace:
> > > > [108431.371999]  <TASK>
> > > > [108431.374296] ? __die (arch/x86/kernel/dumpstack.c:421
> > > > arch/x86/kernel/dumpstack.c:434)
> > > > [108431.377553] ? page_fault_oops (arch/x86/mm/fault.c:707)
> > > > [108431.381850] ? load_balance (kernel/sched/fair.c:10926)
> > > > [108431.385884] ? exc_page_fault (arch/x86/mm/fault.c:1279
> > > > arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> > > > [108431.390094] ? asm_exc_page_fault (./arch/x86/include/asm/idtent=
ry.h:570)
> > > > [108431.394482] ? flow_offload_teardown
> > > > (./arch/x86/include/asm/bitops.h:75
> > > > ./include/asm-generic/bitops/instrumented-atomic.h:42
> > > > net/netfilter/nf_flow_table_core.c:362)
> > > > [108431.399036] nf_flow_offload_gc_step
> > > > (./arch/x86/include/asm/bitops.h:207
> > > > ./arch/x86/include/asm/bitops.h:239
> > > > ./include/asm-generic/bitops/instrumented-non-atomic.h:142
> > > > net/netfilter/nf_flow_table_core.c:436)
> >
> > This crash points here.
> >
> > static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
> >                                     struct flow_offload *flow, void *da=
ta)
> > {
> >         if (nf_flow_has_expired(flow) ||
> >             nf_ct_is_dying(flow->ct) ||
> >             nf_flow_is_outdated(flow))
> >                 flow_offload_teardown(flow);
> >
> >         if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) { <--
> >
> > Is this always reproducible on your testbed?
>
> That's a bit unknown, I don't quite know what triggers it... I only
> know it's happened twice :/
> (That i've noticed - the fw runs with a watchdog and it's always been
> a "uhuh... uptime is less than expected" kind of thing)

I should add that i do:
for interface in eno1 eno2 eno3 eno4 ; do
for offload in ntuple hw-tc-offload rx-udp-gro-forwarding rx-gro-list ; do
ethtool -K $interface $offload on > /dev/null
done
done

And that some interfaces are directly attached to a bridge while
others are more normal

lspci |grep Ethernet
06:00.0 Ethernet controller: Intel Corporation Ethernet Connection
X553 1GbE (rev 11)
06:00.1 Ethernet controller: Intel Corporation Ethernet Connection
X553 1GbE (rev 11)
07:00.0 Ethernet controller: Intel Corporation Ethernet Connection
X553 1GbE (rev 11)
07:00.1 Ethernet controller: Intel Corporation Ethernet Connection
X553 1GbE (rev 11)

This is since i added NET_SCHED etc support back in to the kernel

tc qdisc show
qdisc noqueue 0: dev lo root refcnt 2
qdisc mq 0: dev eno1 root
qdisc fq 0: dev eno1 parent :c limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :b limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :a limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :9 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :8 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :7 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :6 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :5 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :4 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :3 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :2 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno1 parent :1 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc mq 0: dev eno2 root
qdisc fq 0: dev eno2 parent :c limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :b limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :a limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :9 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :8 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :7 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :6 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :5 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :4 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :3 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :2 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno2 parent :1 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 18028b initial_quantum 90140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc mq 0: dev eno3 root
qdisc fq 0: dev eno3 parent :c limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :b limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :a limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :9 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :8 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :7 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :6 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :5 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :4 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :3 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :2 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno3 parent :1 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc mq 0: dev eno4 root
qdisc fq 0: dev eno4 parent :c limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :b limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :a limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :9 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :8 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :7 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :6 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :5 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :4 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :3 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :2 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc fq 0: dev eno4 parent :1 limit 10000p flow_limit 100p buckets
1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b
low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon
10s horizon_drop
qdisc noqueue 0: dev external-net root refcnt 2
qdisc noqueue 0: dev local-lan root refcnt 2
qdisc noqueue 0: dev virtual-net root refcnt 2
qdisc noqueue 8001: dev vnet0 root refcnt 2
qdisc noqueue 8002: dev vnet1 root refcnt 2
qdisc noqueue 8003: dev vnet2 root refcnt 2
qdisc noqueue 8004: dev vnet3 root refcnt 2
qdisc noqueue 8005: dev vnet4 root refcnt 2
qdisc noqueue 8006: dev vnet5 root refcnt 2
qdisc noqueue 8007: dev vnet6 root refcnt 2
qdisc noqueue 8008: dev vnet7 root refcnt 2
qdisc noqueue 0: dev int root refcnt 2


> > Thanks.
