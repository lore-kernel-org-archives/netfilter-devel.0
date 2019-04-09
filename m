Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722C3C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CBD620880
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 06:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUYktPXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfDIGdl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:33:41 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:33197 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDIGdl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 02:33:41 -0400
Received: by mail-vs1-f66.google.com with SMTP id a190so2160504vsd.0;
        Mon, 08 Apr 2019 23:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NyGZLuY21oSC+JaRuB0mfx28bYiC0HLCEIG2dSvO3Ek=;
        b=EUYktPXjheGlgZ8CRsXW3ipjOXvlGZ3SPf4aJ+pT9YQ7QVuewt6Wd7P7mqHk68eYPv
         fQbkY6QqFxAOkEKSNUDpIjf13SLzX4zo/IojWPC5FqqqKFlNJa8R1YTILT2gTO9mgN5P
         Gk2+kgAZzdxBVh2N9YH8AQfre1NZ84NukgMBDyCnmwtAPKMyyVi2Fb+S6ua7OAhNTCbB
         YAOF0ivStQFktm54yviq6ElX1VZ/jTN6RuzqKMby+ceUGLM0jS3Fu7pLJYDP4Xovh1Rs
         oV+LIURz5061t1haX+Zb6PlwaNp89GhcOIkhwSMd+iPd+tr4hDw0LyVQcaDeRD4vtAkc
         nIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NyGZLuY21oSC+JaRuB0mfx28bYiC0HLCEIG2dSvO3Ek=;
        b=jdgGxn62zEycE1MOeO4iXhDpc92aPT1wNDiU21nhFlC2cRB0gmAwMNbQQ269RIQOO0
         SQXuC9ZTk24B8GOwDCdmbs6Ma6SIVGzXsd979Z/4d+vmbp7rT0epuz/uqLzMxxmoHmwN
         hLWtDPhLUe008qJ1TRvBKRIHUgB8qeYZCWf7MjSUpVfPXzZR+hgeIYwrawZiKuFrd4Rl
         mIu04N5KqmAcQon0OD/2DCtkGZ9gn2WNlwprwfeGm/v2ht9JMbgIL0LcsdlxiDHU83Yc
         dLyEtMVLXNTMOP09BuoDhaQAuHvO2arYEmPt4yfUXE4ce6HLueKm2twMJ4snexhdG0YR
         /vSw==
X-Gm-Message-State: APjAAAV3Qqv5/5PRzmW/mH6pnPpuRkjtNz46uCw26Br26/MtRvLlrDkq
        vk3Hr33IIyjnqhCoIG7thSFUsJ7i3WX6/UOzCQ==
X-Google-Smtp-Source: APXvYqz84J2C57bDVeRCZ72qMtsnLzxdKZfsiPCc+g/KpuITrn9PV5MCO+ssL/wALosXZQZ96aY4n7yLAFUdwdFFiA4=
X-Received: by 2002:a67:8154:: with SMTP id c81mr19420779vsd.37.1554791620260;
 Mon, 08 Apr 2019 23:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190402125609.30313-1-rdong.ge@gmail.com> <20190403174441.2l7xyk5o2hftrdm3@salvia>
In-Reply-To: <20190403174441.2l7xyk5o2hftrdm3@salvia>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Tue, 9 Apr 2019 14:33:28 +0800
Message-ID: <CAN1Lvyov_GOjg=1zrgWsV0_ptBGoFfLBsQKU7RswgmzZEjFkmw@mail.gmail.com>
Subject: Re: [PATCH] netfilter:bridge: Hold bridge dev for fake_rtable to
 avoid the dangling pointer
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

I've tested on mainline v5.0. The dangling pointer access of fake_rtable
still exists.

My env is like this: client0--box--client1.
The box runs ubuntu with v5.0 kernel, br_netfilter and nfnetlink_queue
are inserted.

Reproduce steps:
1.Create a bridge on the box.
2.echo 1 >/proc/sys/net/bridge/bridge-nf-call-iptables
3.Add a netfilter hook function to queue the packets to nfqueuenum 0.
  The hook point must between <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and
  <NF_BR_FORWARD,NF_BR_PRI_BRNF - 1>.
4.Add a userspace process "nfqueue_rcv" to continuously read and
  set_verdict "NF_ACCEPT" to packets from queue 0.
5.Continuosly ping client1 from client0
6.Send "Ctrl + Z" to pause the "nfqueue_rcv" to simulate the queue
  congestion.
7.Using "ifconfig br0 down&&brctl delbr br0" to delete the bridge.
8.At this time the _skb_refdst of skbs in the nfqueue become dangling
  pointer. If we send "fg" to resume the "nfqueue_rcv", the kernel
  may try to access the freed memory.

Debug log:
Here I add debug logs in "netdev_freemem" and "dst_release" to prove
the freed memory access. As the log shows, the "dst_release" accessed
bridge's fake_rtable after the bridge was freed.

Apr  8 22:25:14 raydon kernel: [62139.005062] netdev_freemem name:br0,
fake_rtable:000000009d76cef0
Apr  8 22:25:21 raydon kernel: [62145.967133] dst_release
dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
Apr  8 22:25:21 raydon kernel: [62145.967154] dst_release
dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
Apr  8 22:25:21 raydon kernel: [62145.967180] dst_release
dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
Apr  8 22:25:21 raydon kernel: [62145.967197] dst_release
dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH



The reason why the hook point should be after <NF_BR_PRE_ROUTING,
NF_BR_PRI_BRNF> is skbs reference bridge's fake_rtable in
"br_nf_pre_routing_finish" hooked at <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF>.

And the reason why the hook point should be before <NF_BR_FORWARD,
NF_BR_PRI_BRNF - 1> is "br_nf_forward_ip" will set the state.out to
bridge dev. After this hook point, the "nfqnl_dev_drop" triggered by
the bridge's NETDEV_DOWN event can flush the queued skbs before
bridge's memory is freed, because the state.out now matches the
bridge's dev.

So the root cause is "nfqnl_dev_drop" didn't flush the skbs properly
queued between <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and <NF_BR_FORWARD,
NF_BR_PRI_BRNF - 1>.

As you mentioned, hold the bridge dev for these skbs is not a proper
solution. I will send another patch to let "nfqnl_dev_drop" can flush
these skbs.

Thanks
Rundong


Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2019=E5=B9=B44=E6=9C=884=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=881:44=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Tue, Apr 02, 2019 at 12:56:09PM +0000, Rundong Ge wrote:
> > Problem:
> > When bridge-nf-call-iptables is enabled, skb_dst(skb) of packets that
> > in the nfqueue may be a dangling pointer if user delete the bridge.
> > Because packets go through the br_nf_pre_routing_finish will set the ds=
t
> > pointer to the br->fake_rtable. But the br struct will be freed
> > without the reference check for these skbs.
> >
> > User impact:
> > Kernel panic may happen when user delete the bridge if there are
> > continuous traffics go through the nfqueue.
> > Here is a panic in my device which using kernel v3.10.
>
> This kernel is _very old_.
>
> Could you provide the steps to reproduce this issue?
>
> Holding the device doesn't seem the way to go to me, we have a of
> netdevice_notifier that is dropping packets for an interface that is
> gone in nfnetlink_queue. We also drop packets whenever a hook in gone.
>
> So I wonder if this is still a problem in mainline kernels.
