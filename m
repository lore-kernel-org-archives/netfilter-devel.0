Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A75FC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F74260F4E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhGZHDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:03:07 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:46915 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhGZHDG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 03:03:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id AAC7FCC011B;
        Mon, 26 Jul 2021 09:43:34 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 26 Jul 2021 09:43:32 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 7F9C2CC0109;
        Mon, 26 Jul 2021 09:43:32 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 7739B3412EC; Mon, 26 Jul 2021 09:43:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 7374A3412EB;
        Mon, 26 Jul 2021 09:43:32 +0200 (CEST)
Date:   Mon, 26 Jul 2021 09:43:32 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Akshat Kakkar <akshat.1984@gmail.com>
cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
In-Reply-To: <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
Message-ID: <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org>
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com> <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org> <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 26 Jul 2021, Akshat Kakkar wrote:

> MCU is using IP only to dial to VC1 and not hostname.
> 
> I went through packet capture and find everything in line with the
> standard. Just that it is sending "CS : Call Proceeding" packet which
> is an optional packet but it is part of standard.
> I can share pcap file if needed.

Could you enable dynamic debugging in the kernel and enable it for the 
nf_conntrack_h323 module? Then please repeate the testing with the 
working and not working VCs and send the generated kernel debug log 
messages.

Best regards,
Jozsef 
> On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >
> > Hello,
> >
> > On Sat, 24 Jul 2021, Akshat Kakkar wrote:
> >
> > > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> > >
> > > There is a Linux firewall between VCs and MCU.
> > >
> > > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > > There is no natting for MCU IP as it is routable.
> > >
> > > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> > >
> > > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > > h225: CS connect packet is correctly replaced by the natted IP.
> > >
> > > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > > correctly only for VC2 and not for VC1. For VC1, it is still its
> > > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> > >
> > > Because of this, video call is successful only with VC2 and not with
> > > VC1, when initiated from MCU. I tried with another panasonic VC
> > > hardware, there was no change.
> > >
> > > Further packet dump analysis showed that for VC1, there are 3 h225
> > > packets (setup, call proceeding and alert) before Connect message but
> > > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > > message.
> > >
> > > Is there a bug in nf_nat_h323 module or am I missing something?
> >
> > It can be a bug/incompatibility with the H.323 implementation in the
> > Panasonic device. However, first I'd make sure the MCU does not use
> > hostname for VC1 instead of its IP address. Hostnames in the calls are not
> > supported.
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
