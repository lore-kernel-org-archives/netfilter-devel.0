Return-Path: <SRS0=IQIq=VI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B295DC74A4B
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 09:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3021720872
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 09:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="nUocl2Zo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfGKJBL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:01:11 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:51331 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfGKJBK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 05:01:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id D15A43C801A3;
        Thu, 11 Jul 2019 11:01:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1562835665; x=1564650066; bh=FL1qtl8zrv
        Fw1MoIbHxFmayKTqPcaAITH0yr1OG0gGU=; b=nUocl2ZofFG8Ht7t/OOj8zXF6v
        tVS41UYpXeHqq3LIxLG7oopM8j/oon1oymtB0RIYxboND8p3TBDexfk7bwD7+vSN
        VNF+AkHjE8nTwOmBpug/O4vJfSwb9rRELCwAdJoGiNSMqFswWChcEWx2NL3IEENq
        xH+TKcdL9WD0vwYys=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 11 Jul 2019 11:01:05 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 3B3033C80198;
        Thu, 11 Jul 2019 11:01:05 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id E79E521F00; Thu, 11 Jul 2019 11:01:04 +0200 (CEST)
Date:   Thu, 11 Jul 2019 11:01:04 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Jakub Jankowski <shasta@toxcorp.com>
cc:     netfilter@vger.kernel.org, mhemsley@open-systems.com,
        netfilter-devel@vger.kernel.org
Subject: Re: 3-way handshake sets conntrack timeout to max_retrans
In-Reply-To: <alpine.LNX.2.21.1907101251090.26040@kich.toxcorp.com>
Message-ID: <alpine.DEB.2.20.1907111056480.22623@blackhole.kfki.hu>
References: <alpine.LNX.2.21.1907100147540.26040@kich.toxcorp.com> <alpine.DEB.2.20.1907101242560.17522@blackhole.kfki.hu> <alpine.LNX.2.21.1907101251090.26040@kich.toxcorp.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-1799853762-1562835664=:22623"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1799853762-1562835664=:22623
Content-Type: text/plain; charset=US-ASCII

Hi,

On Wed, 10 Jul 2019, Jakub Jankowski wrote:

> On 2019-07-10, Jozsef Kadlecsik wrote:
> 
> > On Wed, 10 Jul 2019, Jakub Jankowski wrote:
> > 
> > > We're debugging a weird issue. tl;dr: I have a .pcap file of connection
> > > setup that makes conntrack apply TCP_CONNTRACK_RETRANS timeout (300s by
> > > default) instead of TCP_CONNTRACK_ESTABLISHED (5d by default). The .pcap
> > > is a recording of some app traffic running on Windows (SAP, I believe).
> > >
> > > The offending handshake is:
> > > 
> > > root@testhost0:~# tcpdump -v -nn --absolute-tcp-sequence-numbers -r
> > > replayed-traffic.pcap
> > > reading from file replayed-traffic.pcap, link-type EN10MB (Ethernet)
> > > 01:13:25.070622 IP (tos 0x0, ttl 128, id 35410, offset 0, flags [DF],
> > > proto
> > > TCP (6), length 52)
> > >     10.88.15.142.51451 > 10.88.1.2.3230: Flags [S], cksum 0x1473
> > > (correct),
> > > seq 962079611, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK],
> > > length 0
> > > 01:13:26.070462 IP (tos 0x0, ttl 53, id 29815, offset 0, flags [DF], proto
> > > TCP
> > > (6), length 48)
> > >     10.88.1.2.3230 > 10.88.15.142.51451: Flags [S.], cksum 0x70cf
> > > (correct),
> > > seq 1148284782, ack 962079612, win 65535, options [mss 1380,nop,wscale 3],
> > > length 0
> > > 01:13:27.070449 IP (tos 0x0, ttl 128, id 35411, offset 0, flags [DF],
> > > proto
> > > TCP (6), length 40)
> > >     10.88.15.142.51451 > 10.88.1.2.3230: Flags [.], cksum 0x9a46
> > > (correct),
> > > ack 1148284783, win 512, length 0
> > > 
> > > This conversation results in the following conntrack events:
> > > 
> > > root@testhost0:~# conntrack -E --orig-src 10.88.15.142
> > >     [NEW] tcp      6 120 SYN_SENT src=10.88.15.142 dst=10.88.1.2
> > > sport=51451
> > > dport=3230 [UNREPLIED] src=10.88.1.2 dst=10.88.15.142 sport=3230
> > > dport=51451
> > >  [UPDATE] tcp      6 60 SYN_RECV src=10.88.15.142 dst=10.88.1.2
> > > sport=51451
> > > dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230 dport=51451
> > >  [UPDATE] tcp      6 312 ESTABLISHED src=10.88.15.142 dst=10.88.1.2
> > > sport=51451 dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230
> > > dport=51451
> > > [ASSURED]
> > > 
> > > 
> > > After enabling all pr_debug()s in nf_conntrack_proto_tcp.c, the above
> > > handshake results in this:
> > 
> > Thanks for the thorough report, but the kernel debug log above does not
> > correspond to the packet replay: the TCP parameters do not match. Please
> > send the proper debug log, so we can look into it.
> 
> Argh. My bad, wrong copy&paste, sorry. Here goes the correct debug snippet:

The kernel does not print enough information. Could you apply the attached 
patch to your kernel at the test machine, rerun the test and send the 
logs?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1799853762-1562835664=:22623
Content-Type: text/x-diff; name=tcp_conntrack_debug.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.20.1907111101040.22623@blackhole.kfki.hu>
Content-Description: tcp_conntrack_debug.patch
Content-Disposition: attachment; filename=tcp_conntrack_debug.patch

ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3Rv
X3RjcC5jIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fdGNw
LmMNCmluZGV4IDM3ZWYzNWI4NjFmMi4uZmVjYzIwMDM2ODgyIDEwMDY0NA0K
LS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fdGNwLmMN
CisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3RjcC5j
DQpAQCAtNTI2LDExICs1MjYsMTQgQEAgc3RhdGljIGJvb2wgdGNwX2luX3dp
bmRvdyhjb25zdCBzdHJ1Y3QgbmZfY29ubiAqY3QsDQogCXByX2RlYnVnKCJz
ZXE9JXUgYWNrPSV1KyglZCkgc2Fjaz0ldSsoJWQpIHdpbj0ldSBlbmQ9JXVc
biIsDQogCQkgc2VxLCBhY2ssIHJlY2VpdmVyX29mZnNldCwgc2FjaywgcmVj
ZWl2ZXJfb2Zmc2V0LCB3aW4sIGVuZCk7DQogCXByX2RlYnVnKCJ0Y3BfaW5f
d2luZG93OiBzZW5kZXIgZW5kPSV1IG1heGVuZD0ldSBtYXh3aW49JXUgc2Nh
bGU9JWkgIg0KLQkJICJyZWNlaXZlciBlbmQ9JXUgbWF4ZW5kPSV1IG1heHdp
bj0ldSBzY2FsZT0laVxuIiwNCisJCSAicmVjZWl2ZXIgZW5kPSV1IG1heGVu
ZD0ldSBtYXh3aW49JXUgc2NhbGU9JWkgIg0KKwkJICJsYXN0IGRpcj0lZCBz
ZXE9JXUgYWNrPSV1IGVuZD0ldSB3aW49JXUgcmV0cmFucz0lZFxuIiwNCiAJ
CSBzZW5kZXItPnRkX2VuZCwgc2VuZGVyLT50ZF9tYXhlbmQsIHNlbmRlci0+
dGRfbWF4d2luLA0KIAkJIHNlbmRlci0+dGRfc2NhbGUsDQogCQkgcmVjZWl2
ZXItPnRkX2VuZCwgcmVjZWl2ZXItPnRkX21heGVuZCwgcmVjZWl2ZXItPnRk
X21heHdpbiwNCi0JCSByZWNlaXZlci0+dGRfc2NhbGUpOw0KKwkJIHJlY2Vp
dmVyLT50ZF9zY2FsZSwNCisJCSBzdGF0ZS0+bGFzdF9kaXIsIHN0YXRlLT5s
YXN0X3NlcSwgc3RhdGUtPmxhc3RfYWNrLA0KKwkJIHN0YXRlLT5sYXN0X2Vu
ZCwgc3RhdGUtPmxhc3Rfd2luLCBzdGF0ZS0+cmV0cmFucyk7DQogDQogCWlm
IChzZW5kZXItPnRkX21heHdpbiA9PSAwKSB7DQogCQkvKg0KQEAgLTcxNSwx
MCArNzE4LDE1IEBAIHN0YXRpYyBib29sIHRjcF9pbl93aW5kb3coY29uc3Qg
c3RydWN0IG5mX2Nvbm4gKmN0LA0KIAkJfQ0KIAl9DQogDQotCXByX2RlYnVn
KCJ0Y3BfaW5fd2luZG93OiByZXM9JXUgc2VuZGVyIGVuZD0ldSBtYXhlbmQ9
JXUgbWF4d2luPSV1ICINCi0JCSAicmVjZWl2ZXIgZW5kPSV1IG1heGVuZD0l
dSBtYXh3aW49JXVcbiIsDQorCXByX2RlYnVnKCJ0Y3BfaW5fd2luZG93OiBy
ZXM9JXUgc2VuZGVyIGVuZD0ldSBtYXhlbmQ9JXUgbWF4d2luPSV1IHNjYWxl
PSVpICINCisJCSAicmVjZWl2ZXIgZW5kPSV1IG1heGVuZD0ldSBtYXh3aW49
JXUgc2NhbGU9JWkgIg0KKwkJICJsYXN0IGRpcj0lZCBzZXE9JXUgYWNrPSV1
IGVuZD0ldSB3aW49JXUgcmV0cmFucz0lZFxuIiwNCiAJCSByZXMsIHNlbmRl
ci0+dGRfZW5kLCBzZW5kZXItPnRkX21heGVuZCwgc2VuZGVyLT50ZF9tYXh3
aW4sDQotCQkgcmVjZWl2ZXItPnRkX2VuZCwgcmVjZWl2ZXItPnRkX21heGVu
ZCwgcmVjZWl2ZXItPnRkX21heHdpbik7DQorCQkgc2VuZGVyLT50ZF9zY2Fs
ZSwNCisJCSByZWNlaXZlci0+dGRfZW5kLCByZWNlaXZlci0+dGRfbWF4ZW5k
LCByZWNlaXZlci0+dGRfbWF4d2luLA0KKwkJIHJlY2VpdmVyLT50ZF9zY2Fs
ZSwNCisJCSBzdGF0ZS0+bGFzdF9kaXIsIHN0YXRlLT5sYXN0X3NlcSwgc3Rh
dGUtPmxhc3RfYWNrLA0KKwkJIHN0YXRlLT5sYXN0X2VuZCwgc3RhdGUtPmxh
c3Rfd2luLCBzdGF0ZS0+cmV0cmFucyk7DQogDQogCXJldHVybiByZXM7DQog
fQ0K

--110363376-1799853762-1562835664=:22623--
