Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BFCC10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 09:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 933EB2183F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 09:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWJ00z+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388593AbfDRJ6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:58:49 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:44895 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfDRJ6t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 05:58:49 -0400
Received: by mail-vk1-f193.google.com with SMTP id q189so329718vkq.11;
        Thu, 18 Apr 2019 02:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MDXx34Z4qA3a8kaTeqeuzWic43HgUDc8KSJFJYxiSAg=;
        b=PWJ00z+z8JynYuz/jxo66kBeshN2b5sg9Co34vVNAbFBNzQHdY3fl+Dfopj6qqxb+q
         TVbsAgRO70OTaxGfhpe2Rn2UV5lGv352nHNIFY/CQdOU//ItOfWYvu22ES/7Kjq3TLxT
         g2+Bv1jrdViBSnNvWQfLQ9xHMb1lWcmDvgR5Y0VBidisVlNNR5lZTRccVWZfj+d24Vgl
         HENZq9ZzdH5nCxMuzP+/BR2/f2feGkU5GaNeaAvT1QR0+Ec21+VNLfcuixfxjagk8duo
         cFMfTWyLAwFc3FFq4ywGZt1hyYXp0V21psoU9hJ6ArMOq1jHMj5eESUW8kO9Q+ZZlBk5
         mO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MDXx34Z4qA3a8kaTeqeuzWic43HgUDc8KSJFJYxiSAg=;
        b=IQ/PD9RKWV7fKkauWlVFX0W8Hu90RIezsjA/3+Ztg3uHzRPT1wZEcSWcB38YVs/XnJ
         G+RYjEcRBnvMlg10z3op6Ubb+z4V7lSfgKcNnRq9RXimEjc0ViMqD9kL3dwlnrDB7z17
         2hNNpsduTbLa+GFF7vTG5GXxdlCHNAa/+orYZ8cstE17MCgIz05d8p1GY8DtNUP+4HNF
         wrFR8O8tXOgqxNpMKb39tYj8uIAo08NgCekAEQp5kDPVr2gOGxbPyIAL95jYyICBELes
         eKVgOzYEK4xRB2XIy2KIMIA6spZj+JediTFQW5+gXhSvDpFBzw8LMCGbn/bXT6t8X0iO
         Z9kg==
X-Gm-Message-State: APjAAAWzhvUWP30OkgDCRWVEiY2De8iimhiHRbCG2JcT7CpwxT8p/Znz
        Em5y2Ps7ImVb0YxzGQyMAQvTVqMBmAFlwBKPX0B5IYIeGQVR
X-Google-Smtp-Source: APXvYqz2Me++RaRch0/OetAWJw17u7QptL2ZP09mQRttDEdaR4kChCNGF/GFBGWL6/hxKMgKnRV1Khr4yFArZ0qNi5M=
X-Received: by 2002:a1f:954:: with SMTP id 81mr3040252vkj.88.1555581527893;
 Thu, 18 Apr 2019 02:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190409065612.32652-1-rdong.ge@gmail.com>
In-Reply-To: <20190409065612.32652-1-rdong.ge@gmail.com>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Thu, 18 Apr 2019 17:58:37 +0800
Message-ID: <CAN1LvyreYTmi2VeH=6_TmRKFpGpkv4sfeC1SOz5ykQR2HnSWXg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: fix dangling pointer access of fake_rtable
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

friendly ping

Rundong Ge <rdong.ge@gmail.com> =E4=BA=8E2019=E5=B9=B44=E6=9C=889=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:56=E5=86=99=E9=81=93=EF=BC=9A
>
> With  bridge-nf-call-iptables enabeled, Skbs go through the bridge
> and enqueued between  <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and
> <NF_BR_FORWARD,NF_BR_PRI_BRNF - 1> won't be flushed when bridge is
> down. Then _skb_refdst of skbs in the nfqueue become dangling pointer.
>
> Reproduce steps:
> 1.Create a bridge on the box.
> 2.echo 1 >/proc/sys/net/bridge/bridge-nf-call-iptables
> 3.Add a netfilter hook function to queue the packets to nfqueuenum 0.
>   The hook point must between <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF> and
>   <NF_BR_FORWARD,NF_BR_PRI_BRNF - 1>.
> 4.Add a userspace process "nfqueue_rcv" to continuously read and
>   set_verdict "NF_ACCEPT" to packets from queue 0.
> 5.Continuosly ping client1 from client0
> 6.Send "Ctrl + Z" to pause the "nfqueue_rcv" to simulate the queue
>   congestion.
> 7.Using "ifconfig br0 down&&brctl delbr br0" to delete the bridge.
> 8.At this time the _skb_refdst of skbs in the nfqueue become dangling
>   pointer. If we send "fg" to resume the "nfqueue_rcv", the kernel
>   may try to access the freed memory.
>
> Debug log:
> Here I add debug logs in "netdev_freemem" and "dst_release" to prove
> the freed memory access. As the log shows, the "dst_release" accessed
> bridge's fake_rtable after the bridge was freed.
>
> Apr  8 22:25:14 raydon kernel: [62139.005062] netdev_freemem name:br0,
> fake_rtable:000000009d76cef0
>
> Apr  8 22:25:21 raydon kernel: [62145.967133] dst_release
> dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
>
> Apr  8 22:25:21 raydon kernel: [62145.967154] dst_release
> dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
>
> Apr  8 22:25:21 raydon kernel: [62145.967180] dst_release
> dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
>
> Apr  8 22:25:21 raydon kernel: [62145.967197] dst_release
> dst:000000009d76cef0 dst->dev->name: =C5=99KU=C2=A1TH
>
> The reason why the hook point should be after <NF_BR_PRE_ROUTING,
> NF_BR_PRI_BRNF> is skbs reference bridge's fake_rtable in
> "br_nf_pre_routing_finish" hooked at <NF_BR_PRE_ROUTING,NF_BR_PRI_BRNF>.
>
> And the reason why the hook point should be before <NF_BR_FORWARD,
> NF_BR_PRI_BRNF - 1> is "br_nf_forward_ip" will set the state.out to
> bridge dev. After this hook point, the "nfqnl_dev_drop" triggered by
> the bridge's NETDEV_DOWN event can flush the queued skbs before
> bridge's memory is freed, because the state.out now matches the
> bridge's dev.
>
> Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_qu=
eue.c
> index 0dcc359..57eb02d 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -905,13 +905,25 @@ static void free_entry(struct nf_queue_entry *entry=
)
>  dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
>  {
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> -       int physinif, physoutif;
> +       struct net_device *physindev, *physoutdev;
> +       struct net_bridge_port *port;
>
> -       physinif =3D nf_bridge_get_physinif(entry->skb);
> -       physoutif =3D nf_bridge_get_physoutif(entry->skb);
> -
> -       if (physinif =3D=3D ifindex || physoutif =3D=3D ifindex)
> -               return 1;
> +       physindev =3D nf_bridge_get_physindev(entry->skb);
> +       physoutdev =3D nf_bridge_get_physoutdev(entry->skb);
> +       if (physindev) {
> +               if (physindev->ifindex =3D=3D ifindex)
> +                       return 1;
> +               port =3D br_port_get_rcu(physindev);
> +               if (port && port->br->dev->ifindex =3D=3D ifindex)
> +                       return 1;
> +       }
> +       if (physoutdev) {
> +               if (physoutdev->ifindex =3D=3D ifindex)
> +                       return 1;
> +               port =3D br_port_get_rcu(physoutdev);
> +               if (port && port->br->dev->ifindex =3D=3D ifindex)
> +                       return 1;
> +       }
>  #endif
>         if (entry->state.in)
>                 if (entry->state.in->ifindex =3D=3D ifindex)
> --
> 1.8.3.1
>
