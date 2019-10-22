Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E47CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 15:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77262214B2
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 15:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UyulZTi7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbfJVP5k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:57:40 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:39848 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbfJVP5j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 11:57:39 -0400
Received: by mail-ua1-f66.google.com with SMTP id b14so5072292uap.6
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 08:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NK8u/aGX2NmYqKTBfpAK9Fl3I6ETdvXZPf0sGewxybc=;
        b=UyulZTi7Auu7Mx9xe+Xq9lL9C9MllBGt+zH7z0RzxWeMmOm9yQtlysNG9jLcUHtBTc
         p7dbuyHRjqYKZxxDNF0W9QHRmqfTwj1Tt+aoEYz7bpMLOQaZNo21aR2288aKRIERzukr
         52C6XKEtUCcseTbuhxIu6zYjn0yn36YrZdhbeDh/KTuIkwlTkFij4183OfaA4JlgbzuP
         7+KPGgKAvfyUzZkyBSLaz3a5oXgVWFRx+DK1iKqEt1RMsmPLmDvYpNUg/oAn9l3xJvWR
         zUMD14phCVdtUaUzIu1UNf4tCbneOExZNchblikq16679wyFhsrQ18Jg5zbjaGWSrT4C
         tEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NK8u/aGX2NmYqKTBfpAK9Fl3I6ETdvXZPf0sGewxybc=;
        b=GxmWyZLNEecXzMA3nrcMfcXqpwCp/L6xvfiZQFFkdtisKIsHF9LznXAt+PRXm1vnQq
         w0Ap1mumvJfJKhTvyga+QeTiaUjHnHac+yAhpU1ENst/1UgdianJluFvQibANvsR+Pu5
         MobHFMk5MGvBxMEdVQvK3pvEUcE3tc5FblxsIO5lKztTDcisQ3JKr6yBrgpA56XuMIp2
         F/MDThTebKhhjtR6OmZ4TkjzrnATxjd6+3wOvK/URzc2bumWsZl8TVLHeFxCM0wpoDbn
         W1ih4VNqaHooQRDVn8ygdW5y8Wfvowvnr7FUfP3ejArZ1smIoKwC2HmHboIsDnRvvXC1
         K3pw==
X-Gm-Message-State: APjAAAU1bT21y8IV0HVfvppm9Y8vvIGkaPcoD4mjwvjbIeinKFaQ6rDD
        oRKxylr8ze5OUgd2T/7IRNok4oGDoSbUJMIPtz1GVX9cgEU=
X-Google-Smtp-Source: APXvYqwX7hLCcce3rj3cxvB9tv3TJGDoZJi8ObdmvcWOjCY64zOEI2ZcjBxoW+HiecXD3oCx0b3TQ1sKTmIikDSLAnI=
X-Received: by 2002:ab0:5bdb:: with SMTP id z27mr2476716uae.118.1571759856899;
 Tue, 22 Oct 2019 08:57:36 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Tue, 22 Oct 2019 17:57:25 +0200
Message-ID: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
Subject: nftables: secmark support
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
I am trying to finally get secmark with nftables to work.
The kernel[1][2] and libnftnl[3] parts are done.
For the nft front-end I think some things need a further change than
already introduced[4].

1.
I found no way to store the secmark label into the connection tracking
state and thereby set the label on established,related packets.
Using a patch[5] it works with the following syntax:
(Note: The patch will currently probably not apply to current master,
due to [6])

    [... define secmarks and port maps ...]
    chain input {
        type filter hook input priority 0;
        ct state new meta secmark set tcp dport map @secmapping_in
        ct state new ip protocol icmp meta secmark set "icmp_server"
        ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_server"
        ct state new ct secmark_raw set meta secmark_raw
        ct state established,related meta secmark_raw set ct secmark_raw
    }
    chain output {
        type filter hook output priority 0;
        ct state new meta secmark set tcp dport map @secmapping_out
        ct state new ip protocol icmp meta secmark set "icmp_client"
        ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_client"
        ct state new ct secmark_raw set meta secmark_raw
        ct state established,related meta secmark_raw set ct secmark_raw
    }

2.
The rules in 1. are not idempotent. The output of 'nft list ruleset' is:

    chain input {
        type filter hook input priority filter; policy accept;
        ct state new secmark name tcp dport map @secmapping_in
        ct state new ip protocol icmp secmark name "icmp_server"
        ct state new ip6 nexthdr ipv6-icmp secmark name "icmp_server"
        ct state new ct secmark set secmark
        ct state established,related secmark set ct secmark
    }
    chain output {
        type filter hook output priority filter; policy accept;
        ct state new secmark name tcp dport map @secmapping_out
        ct state new ip protocol icmp secmark name "icmp_client"
        ct state new ip6 nexthdr ipv6-icmp secmark name "icmp_client"
        ct state new ct secmark set secmark
        ct state established,related secmark set ct secmark
    }

What are the code locations to fix?

3.
The patch also adds the ability to reset secmarks.
Is there a way to query the kernel about the actual secid (to verify
the reset works)?

4.
Maybe I can contribute a howto for wiki.nftables.org. What is the
preferred format?

Best regards,
     Christian G=C3=B6ttsche


[1] https://github.com/torvalds/linux/commit/fb961945457f5177072c968aa38fee=
910ab893b9
[2] https://github.com/torvalds/linux/commit/b473a1f5ddee5f73392c387940f4fb=
cbabfc3431
[3] https://git.netfilter.org/libnftnl/commit/?id=3Daaf20ad0dc22d2ebcad1b2c=
43288e984f0efe2c3
[4] https://git.netfilter.org/nftables/commit/?id=3D3bc84e5c1fdd1ff011af978=
8fe174e0514c2c9ea
[5] https://salsa.debian.org/cgzones-guest/pkg-nftables/blob/master/debian/=
patches/0004-secmark-add-missing-pieces.patch
[6] https://git.netfilter.org/nftables/commit/?id=3D998142c71d095d79488495e=
a545a704213fa0ba0
