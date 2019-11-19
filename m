Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD5DC432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 08:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9240A20878
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 08:10:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbMp9hYl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfKSIKg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 03:10:36 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:45857 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKSIKg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 03:10:36 -0500
Received: by mail-io1-f52.google.com with SMTP id v17so11011554iol.12;
        Tue, 19 Nov 2019 00:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2oLH1Lri8f6h5RvlMJKE4Jdozlmbr5UHnMrdItBPFfc=;
        b=EbMp9hYlDCahxFVbPT/RUXrbkTICEMmmLX7G8ttqrGi0MLaPMb5iBtSV4B/fmfWUK0
         FTxa5SvPrA8EhUXlm9r1WPMLS6F289N3pNS0nkM6sWlIv3zQX0zLzX4HDRM7LVUZjLX5
         iekEFzw8zzNPMMELvq3UK3HTRZPtm/6e5lSdflaGoIYvai/YtQcQD/zUg7alDuZ3Jbsl
         JD3BNIvzS7XbaqTLVqXZVeex9CjnG6dhDo8k8AAgEJKFxuhF+fQzJturHSjaeLF+G0Bk
         rlkNoTbFPpsts1oX6Jm766sXhWFvWbVK8AFOAv/Z/4ty250eGw7S+H1/sqLrr1PuYb4G
         VRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2oLH1Lri8f6h5RvlMJKE4Jdozlmbr5UHnMrdItBPFfc=;
        b=n/XGEVkG5tNxS9I2QKzJGqc+1DHlEp/FRDfmf1EvhrA5Rgod0LwSThh9Q6B7xENbHa
         VVOZmqorfJnSWeek+1AL0pXFR8NL5zqN+292v3/3Ate64F9NCz7ONhN5OFHtZJrTHx56
         Fkipkeft/jRF2oPCDesNKOQFWA6tWCwLyQz7S/FRm2DveW2QWOJ5fFKsPHdHiRLDHsPV
         AnKWUnnd0rMuFazNDiDZDhIimCCGo9QqaMDmDKUGpfTRpC4qvjfUyO3icx0wK6EYYAvw
         I71TYw4gLxseasFXTelTCd5zpaiIV4N2IkIl+TyB5eVOIw11YAI10KIH8DvLdRyTw+fE
         WAwA==
X-Gm-Message-State: APjAAAUaB6kt2CYF255PjvZhlJZ2Nrd8Wj02zyHyhuphl/9CIWuPMmUC
        NNtn34N0zAhlq24JXBCOmXN3BENHlBXUCObF9LfYjXwQnRo=
X-Google-Smtp-Source: APXvYqzqKLU0edeyLnUKlEF3jcYcGmBL7nEJ/4PIZqaQ4JWHORWIB1qLX9DqpPQfVrPMYNrHfhfTL7QPTaIn7GGawYU=
X-Received: by 2002:a6b:ed05:: with SMTP id n5mr16281734iog.278.1574151034577;
 Tue, 19 Nov 2019 00:10:34 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Tue, 19 Nov 2019 11:10:23 +0300
Message-ID: <CAK6Qs9k0Z9US9u3OWhO4_DTjU1+zY5wXpARu6=cwgVOPx8jP2Q@mail.gmail.com>
Subject: Mysql has problem with synproxy
To:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi.
We are having problem with mysql and synproxy. While other tcp apps
working fine on same server, mysql server seems not working properly
when we activated synproxy.

This is the handshake packets while synproxy deactivated. 10.0.0.1 is
the server.

14:28:57.344688 IP 10.0.0.2.59924 > 10.0.0.1.3336: Flags [S], seq
2738839797, win 29200, options [mss 1460,sackOK,TS val 1776041 ecr
0,nop,wscale 7], length 0
14:28:57.344836 IP 10.0.0.1.3336 > 10.0.0.2.59924: Flags [S.], seq
3873797148, ack 2738839798, win 65535, options [mss 1460,nop,wscale
6,sackOK,TS val 3220882344 ecr 1776041], length 0
14:28:57.344961 IP 10.0.0.2.59924 > 10.0.0.1.3336: Flags [.], ack 1,
win 229, options [nop,nop,TS val 1776041 ecr 3220882344], length 0

Here client is able to connect without any problem. Server has wscale
6 and mss 1460, so we added synproxy rules as below

iptables -t raw -A PREROUTING -i enp12s0f0 -p tcp --syn -j CT --notrack
iptables -t filter -A FORWARD  -i enp12s0f0 -p tcp -m state --state
INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --mss 1460
--wscale 6
iptables -t filter -A FORWARD -i enp12s0f0 -p tcp -m state --state
INVALID -j DROP

After synproxy activated, server send reset and reject connection.
Here is the packets we captured between client to firewall and
firewall to server

Between client and firewall
14:28:12.343253 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [S], seq
1356993242, win 29200, options [mss 1460,sackOK,TS val 1731041 ecr
0,nop,wscale 7], length 0
14:28:12.343280 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [S.], seq
2278099588, ack 1356993243, win 0, options [mss 1460,sackOK,TS val
1423321111 ecr 1731041,nop,wscale 6], length 0
14:28:12.343439 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [.], ack 1,
win 229, options [nop,nop,TS val 1731042 ecr 1423321111], length 0
14:28:12.343611 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [.], ack 1,
win 1023, options [nop,nop,TS val 1423321111 ecr 1731042], length 0
14:28:12.343692 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [R], seq
2278099589, win 0, length 0

Between firewall and server
14:28:12.343459 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [S], seq
1356993242, win 229, options [mss 1460,sackOK,TS val 1731042 ecr
1423321111,nop,wscale 7], length 0
14:28:12.343583 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [S.], seq
1666149016, ack 1356993243, win 65535, options [mss 1460,nop,wscale
6,sackOK,TS val 109930553 ecr 1731042], length 0
14:28:12.343602 IP 10.0.0.2.59586 > 10.0.0.1.3336: Flags [.], ack 1,
win 229, options [nop,nop,TS val 1731042 ecr 3091507291], length 0
14:28:12.343686 IP 10.0.0.1.3336 > 10.0.0.2.59586: Flags [R], seq
1666149017, win 0, length 0

Here mysql runs on freebsd and since it is a real system that makes it
harder to debug. Any idea what causes this?

Regards.

--
=C4=B0brahim Ercan
