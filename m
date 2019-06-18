Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7541FC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E042080C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:06:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iO1Egtsa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfFRKGp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 06:06:45 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:42304 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFRKGp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 06:06:45 -0400
Received: by mail-io1-f48.google.com with SMTP id u19so28340220ior.9;
        Tue, 18 Jun 2019 03:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=e8kLZtNNepI5ysJyFaRF/iVB8aSg3k6lWY8FpR+u/+g=;
        b=iO1EgtsaSVtcCkvQYL1zUODlNdrDCCYjgMxsGKRsE9E6Hq59WWNStQjL5aRvAIJhtn
         9AskEgtrysbpvdBjGgMZvNebG5zDKzbXZ7RlXxxlXfTrW7lOzOkU9MbpO1wSnM44d2iP
         EP5lzH1TEQ8f2CmB0FdYYF5G12jAfJCglnxjeBJg72ds3coVN5VwpAG6gtG8yQf7Ohzj
         JF3KOM+OI5u6qdBnTJvk3DzgtYa9aUyx5zzZSURRCiowQ7NUkmjpAJq37S8IejXYYa36
         ln4NFyJ5ddsPo2eIc88XCuSB6X28HcxzpMywidQr/s/j6lFksGJiGn/hDy9j/fK0BcA6
         /OWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=e8kLZtNNepI5ysJyFaRF/iVB8aSg3k6lWY8FpR+u/+g=;
        b=bV1v4gFSUOTh0LreyvaR7UGm8p2VH3gnAEmFwXEKaaSW3OLcc3p8BpsV07Sbjm86QT
         5W5NwQaYwMItZOagRxwCR+Mdu4CPy+hmFP5/rj2yMYM6GQuvZTM53UHsp/B1yuSwOKcT
         6jHZfVKhh+R2LL7NBj6maEWApsYt4vT9eKQoKH/sOfZTY0sOPnzaKvik2+uJ6z/9rLW8
         5Qk9YLcagStKm1k6TRg76VErHGphGtIpIeDXoojlyyd/NlNy4/ZFxiRI/i4mPG82U3yK
         8U7Q+UMyPZGAUrOtJU/3Nzz/F2uiXVnIlbJYIJmWrJxcKp+kJMoDWIOoBSf8LGEUrt0g
         FYHw==
X-Gm-Message-State: APjAAAV3AIV2+7+TgWnIClccCfvP9TIiwS5Ietzr9A7X1uT1ORUlSk8z
        ThWp25QLEEqPAmtYedIbKufPiroEfmIGaN8yL9Fy8Z+LB9bgsQ==
X-Google-Smtp-Source: APXvYqzkOrvCQZBZI71S/0OsSWHtH4dIAnQ9vVsd/XhjZETngwUXNKoOrUP1SbkbkrGhluLKJhVSJHqGuJ7krz9mxQs=
X-Received: by 2002:a6b:7401:: with SMTP id s1mr18623453iog.67.1560852403357;
 Tue, 18 Jun 2019 03:06:43 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Tue, 18 Jun 2019 13:06:32 +0300
Message-ID: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
Subject: Is this possible SYN Proxy bug?
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi.
I experienced some errors regarding syn proxy. I observed network
traffic and realized syn proxy doesn't set mss value correctly. Then I
did some tests and here is details of my test.

I set 3 different device. A client, firewall and server. Firewall is
where syn proxy rules located.

Before adding syn proxy rules, I observed mss and wscale values

10.0.0.215.60797 > 10.0.1.213.80: Flags [S], seq 3059817525, win
29200, options [mss 1460,sackOK,TS val 95678003 ecr 0,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60797: Flags [S.], seq 3020500548, ack
3059817526, win 14480, options [mss 1460,sackOK,TS val 12703989 ecr
95678003,nop,wscale 2], length 0

So client sets mss 1460 wscale 7, server sets mss 1460 and wscale 2

Then I added below rules and start tests
iptables -t raw -A PREROUTING -i enp7s0f0 -p tcp -m tcp --syn -j CT --notrack
iptables -A FORWARD -i enp7s0f0 -p tcp -m tcp -m state --state
INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 2 --mss
1460
iptables -A FORWARD -i enp7s0f0 -p tcp -m tcp -m state --state INVALID -j DROP

With these values here is what I see on external and internal interface

External interface:
10.0.0.215.60800 > 10.0.1.213.80: Flags [S], seq 1609742327, win
29200, options [mss 1460,sackOK,TS val 99453267 ecr 0,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60800: Flags [S.], seq 3294723050, ack
1609742328, win 0, options [mss 1460,sackOK,TS val 5761239 ecr
99453267,nop,wscale 2], length 0

Internal interface:
10.0.0.215.60800 > 10.0.1.213.80: Flags [S], seq 1609742327, win 229,
options [mss 1460,sackOK,TS val 99453267 ecr 5761239,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60800: Flags [S.], seq 1301167703, ack
1609742328, win 14480, options [mss 1460,sackOK,TS val 16479252 ecr
99453267,nop,wscale 2], length 0

Until here there is nothing wrong. Now see what happen when I set
client mss value to 1260 by changing mtu.

External interface
10.0.0.215.60802 > 10.0.1.213.80: Flags [S], seq 36636545, win 25200,
options [mss 1260,sackOK,TS val 99747035 ecr 0,nop,wscale 7], length 0
10.0.1.213.80 > 10.0.0.215.60802: Flags [S.], seq 2342465663, ack
36636546, win 0, options [mss 1260,sackOK,TS val 6054999 ecr
99747035,nop,wscale 2], length 0

Internal interface
10.0.0.215.60802 > 10.0.1.213.80: Flags [S], seq 36636545, win 197,
options [mss 536,sackOK,TS val 99747035 ecr 6054999,nop,wscale 7],
length 0
10.0.1.213.80 > 10.0.0.215.60802: Flags [S.], seq 3600660781, ack
36636546, win 14480, options [mss 1460,sackOK,TS val 16773019 ecr
99747035,nop,wscale 2], length 0

As you can see syn proxy respond to client with same mss value and
open connection to back end with 536. But I suppose, It should send
1460 to client and 1260 to server.

I tried both bridged and router topology with kernel versions 5.0.13
and 4.14.21 and got same results. iptables version is 1.4.21

Regards
--
Ibrahim Ercan
