Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3C4C47257
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 17:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3220520820
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 17:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewmptzXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEIRp7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 13:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgEIRp6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 13:45:58 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A224CC061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 10:45:56 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r2so4477777ilo.6
        for <netfilter-devel@vger.kernel.org>; Sat, 09 May 2020 10:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nnruQUz5/Ril9x9+et0TLddIG/QJeMyZppa0fmv1kmY=;
        b=ewmptzXF+Gr1mvJITodTVkNElEYdKg5jRnl91FvwUHJe4vyWVABLXUZMS1PTvY2axY
         iN3Xk52UbDXBzJkk7MeXxJimn+8+2Zv1T0pAfzNpm7A7tC65SJBp1x68NCsrgEKe2cIC
         GRkZamJemjOVxmQnLe3TYgyv/j+57v3p1NZc24lDZedwImSM7LVWsocRHXzmjyF5JjYm
         FAbjuStMPC5LX9QdI6RGUlUZY+GI0CqgTRzwQO9q3R734AzS5VxzIVEDiy1QsNuwxN2W
         FPwS/wBHaRkYPKduow8hiu1KxABcxm0z5Hw9PYfFPY1LCBWQVy8wPmdT0T1KHimQm28f
         JjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nnruQUz5/Ril9x9+et0TLddIG/QJeMyZppa0fmv1kmY=;
        b=ArwHyfQBBE1vcOAHuOKpTd310tJ/ba6vqU4r5p08KSjn08rKEq9UZG65qM19QrAlOT
         dWXujf+Ft72qH4P5pF05tIeQ1ON73FyP6lyvoslD7aIT7ofDCGA/xypzw2e0A9j3X4Ap
         rzHYFkdq88UCqYO7QUASM72Ulx9T5b1kjyaq5752c51HBIRSe46foWefJ25fgFNevnzH
         RFw6YuI7EYlYHLyjlRWFZSXootDoMrL4sFUD3dksbgVOvChN4xy9Qr+DsUk+yyTJOVfS
         12ti+ckvoTEEdJp0ETalgE4zoQXlGc7nXjwM1RtZVVBC588gET8ULoGG6rI56vbIGY8q
         rs/A==
X-Gm-Message-State: AGi0PubO8vmycnIPNo3hr1rKp5Few3GxLSII2hsb6ZwM6gdBFDEdFCm2
        3ysIvdJzfSesyQbgJZ9Y1T2P4VG86KjCw3gTan9xxg==
X-Google-Smtp-Source: APiQypJB2lv2thv585LZL2I5v6+62peH9ODSQonegDK2nVlaRSaVFKyCf/+STGJF88FEByehfzZpZEMpwE6FbtEn0Bo=
X-Received: by 2002:a92:af44:: with SMTP id n65mr8230372ili.61.1589046355692;
 Sat, 09 May 2020 10:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200509052235.150348-1-zenczykowski@gmail.com> <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr>
In-Reply-To: <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 10:45:42 -0700
Message-ID: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
Subject: Re: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID' packets
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

So I've never tried to figure out how things break, just observed that
they do - first many many years ago (close to 15ish) - between my wifi
connected laptop at home and my university server in the same city.
I've kept an INVALID->DROP rule in all my firewalls since then and not
had problems.  I vaguely recall seeing delayed packets when I debugged
it back then.

See for example: https://github.com/moby/libnetwork/issues/1090 for
others running into this.

Now we've hit an issue at work where a network misconfiguration has
asymmetric one way pathing with a result that some packets were
getting *massively* delayed, and it's been causing user firewalls to
generate tcp resets for 'too old' 'already ack'ed' packets (ie. dups).

While this is of course a misconfig, and it shouldn't happen, in
practice it sometimes simply does.
All it takes is for a packet to get into a long queue, and the network
path to shift (immediately after it) to a less congested path.
Due to bufferbloat those long queues can take seconds to drain and
exceed path rtt by orders of magnitude.

I *think* what happens is:

A non-final tcp packet gets massively delayed, the packet past that
makes it through to the receive, and triggers an ACK with SACK, which
makes it back to the sender and triggers a retransmit and the
connections keeps on making forward progress,  then eventually the
delayed packet arrives and it's no longer considered valid and
triggers a tcp reset.  Massively of course depends on the rtt and
retransmit aggressiveness.

Here's my attempt to demonstrate what I believe the problem to be:

(on a freshly booted clean/empty/idle fedora 31 vm)

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
modprobe ifb
ip link set dev ifb0 up
tc qdisc add dev ifb0 root netem reorder 99% 0% delay 10s
tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress u32 match u32 0 0 action mirred egress
redirect dev ifb0
wget -O /dev/null https://git.kernel.org/torvalds/t/linux-5.7-rc4.tar.gz
iptables-save -c

...
/dev/null                             [     <=3D>
                           ] 169.58M  2.93MB/s    in 45s
2020-05-09 10:35:44 (3.81 MB/s) - =E2=80=98/dev/null=E2=80=99 saved [177819=
073]
...
[31750:181080717] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
[244:1403178] -A INPUT -m state --state INVALID -j DROP


Now if I reboot, and run the same script, except instead of the
INVALID/DROP rule I do
  iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
then the download never finishes (it hangs after 15MB @ 2MB/s and
eventually times out).

[4170:16758894] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
[37:147454] -A INPUT -p tcp -j REJECT --reject-with tcp-reset

(arguably since this is a VM, and thus NAT'ed by my host, and then
again by the real ipv4 NAT, the setup isn't entirely clear, but I hope
it makes my point: INVALID state needs to be dropped, not rejected)
