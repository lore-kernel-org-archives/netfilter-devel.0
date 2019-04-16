Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832C0C10F13
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 15:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 479092087C
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 15:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UV3Rvds0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfDPPww (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 11:52:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36337 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfDPPwv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 11:52:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id y13so27829390wrd.3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2019 08:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3oS/qYGXe7WEI2M3W7pQ3bsscfC/aBDTU2x6tZfY9tY=;
        b=UV3Rvds03i1eMZ8XVkEwHlOPNjuh1gwrbq7mjnfZpS4AB5j+yrbPSct3HSCZoUs2a9
         UA/pbKOZf2HBkJLqxmVkE2VXngbJX35ZPxkbsHNNtMp91l9l5JG/8G1DLIMdamVL6xgz
         lHa+ViZRkTEa2oUfj5EdUHGODJi+RIOAUaAR3rjrCABgb22AsnF12vwvhAnCFQRH9P8/
         yMl7AcBCI+qPMPAlPiLX8tKDPwsFNrSbU7xaOCX4/DILWNACaejL1Zto05vgaM8kWlTx
         rmpX5VrzyPiL7c2jkKdNLkZusUSC8BUGPcYjfWK2QmdqJak1cvPHBuKxLLrCypK00qh3
         rMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3oS/qYGXe7WEI2M3W7pQ3bsscfC/aBDTU2x6tZfY9tY=;
        b=DcydKNYEjmAtOnd5PrRQTnz9Pycu/wiHTMWhXChTW6v4eaCEwBR8opZ23m4f5iB9E7
         DPgWwmBj9YYZm9+tN4eCB/seCFT8H1dtqc5BZqBwB0qqApgGtJtKE+7ruK7axflusBM8
         RZp8yfbAS38GGkSJid2q+xXRDy8nLIj0VBDmwCUz8Yt2O7XkV4XBFRDDzIqGhVjAkYdJ
         PNyE5jvzIvfIUBbltLeo64pj9DwKLbhG2nbnWTIQLHIx96jTT0ifLfZXmWFhs3cqjhRJ
         rE6b2Yt2jSeedX9gWK65L+vd0ob2VC3jZGhfxS9fUYtlZzJqJq3ho7Tf54J798ha4YcP
         cH3w==
X-Gm-Message-State: APjAAAXeHt6hyRsIEZxh+RThoUz/F8FchIwQZz8cXMjClpRO3AshGAJ8
        KMpvTX2/aE0yQCY6qp0cQVeIXVdBQYeVyr+WXHm2xmAS
X-Google-Smtp-Source: APXvYqwanRfl0AxgxisiIFaPmwUwjr26GYhB5WT2EumLw57IB14n4VQxie6/LEu5zyq1BNZZ0VIbYbfVDhBZlYtJ5qs=
X-Received: by 2002:a5d:698b:: with SMTP id g11mr12278040wru.65.1555429969394;
 Tue, 16 Apr 2019 08:52:49 -0700 (PDT)
MIME-Version: 1.0
References: <CANpxKHGdbN6UYTw=r=r9=usZ3taX05ARpnAQ_StF4Zikcpp5WA@mail.gmail.com>
 <20190411102059.b6kyga3jcg6xshcl@salvia>
In-Reply-To: <20190411102059.b6kyga3jcg6xshcl@salvia>
From:   Naruto Nguyen <narutonguyen2018@gmail.com>
Date:   Tue, 16 Apr 2019 22:52:37 +0700
Message-ID: <CANpxKHFpodMq7_C+TE7RDimYGwDf-+Qt10TgU5+Bk_cN=Tmm5w@mail.gmail.com>
Subject: Re: ESTABLISHED tcp conntrack timeout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Thanks very much for your reply. I will describe the test later. Could
you please let me know more clearly in case the TCP_CONNTRACK_UNACK is
set if
IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED is set? Does it indicate some UNACK
packets due to network congestion, but eventually the ACK is sent, so
no packet restransmission happens. Actually I did not see any packet
restransmission in my wireshark trace.

Best regards,
Naruto

<http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail>
Virus-free. www.avg.com
<http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail>
<#DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2>

On Thu, 11 Apr 2019 at 17:21, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> Dropping Cc to netdev and netfilter, no need to Cc everyone :-)
>
> On Wed, Apr 10, 2019 at 05:47:35PM +0700, Naruto Nguyen wrote:
> > Hello everyone,
> >
> > When duplicating tcp conntrack from main name space to another network
> > namespace, I see that sometimes timeout value for an established tcp
> > connection in another network namespace has been changed from 432000
> > to 300 like below, even it is in ASSURED
> >
> > 03:05:53.773
> > tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:05:56.018
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:05:58.267
> > tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:00.511
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:02.767
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:05.024
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:07.318
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:09.578
> > tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:11.833
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:14.082
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:16.315
> > tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:25.314
> > tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:27.571
> > tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:29.815
> > tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> > dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> > [ASSURED] mark=0 use=1
> > 03:06:32.065
> >
> > In nf_conntrack_proto_tcp.c, I see that 2 constants have 5 mins set
> >
> > [TCP_CONNTRACK_RETRANS] = 5 MINS,
> > [TCP_CONNTRACK_UNACK] = 5 MINS,
> >
> > and the code
> >
> > if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
> >        timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
> >        timeout = timeouts[TCP_CONNTRACK_RETRANS];
> > else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
> >        IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
> >        timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
> >        timeout = timeouts[TCP_CONNTRACK_UNACK];
> > else
> >        timeout = timeouts[new_state];
> >
> > but I am not sure this code cause the above issue. For the second
> > TCP_CONNTRACK_UNACK, it only happens for [UNREPLIED] instead of
> > [ASSURED]. Could you please let me know how the time out value can be
> > changed for an established tcp connection and how to prevent this
> > change?
>
> Probably you're seeing retransmission, did you have a look at packet
> traces?
>
> Could you describe you testbed, your kernel, and so on?
>
> Thanks.
