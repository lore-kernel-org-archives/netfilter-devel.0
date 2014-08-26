From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Tue, 26 Aug 2014 13:45:42 +0200
Message-ID: <CAFpD06SEXxqe2297-N-129tK2=Z2tAiV5fs_1Xc9AvWLnsEuVg@mail.gmail.com>
References: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
	<20140826085513.GA3800@salvia>
	<CAFpD06RPw3pMaLHzXWdMZ7BnzXH1Sh7n68biqpR+o4k5j9=Nkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47118 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaHZLpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:45:43 -0400
Received: by mail-vc0-f175.google.com with SMTP id ik5so16472105vcb.20
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2014 04:45:42 -0700 (PDT)
In-Reply-To: <CAFpD06RPw3pMaLHzXWdMZ7BnzXH1Sh7n68biqpR+o4k5j9=Nkg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I forgot to say that netlink code seems correct:
ip filter INPUT 26
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x0000a8c0 ]
  [ match name tcp rev 0 ]
  [ match name conntrack rev 3 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

2014-08-26 13:43 GMT+02:00 Giuseppe Longo <giuseppelng@gmail.com>:
> Hi Pablo,
> To fix that the add_cmp_ptr() function should be called after
> add_bitwise_* in add_addr() function.
> But this change make the output wrong, see below:
>
> # iptables-compat -A INPUT -p tcp -s 192.168.0.0/24 --dport 22 -m
> conntrack --ctstate NEW -j ACCEPT
> # iptables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> ACCEPT     tcp  --  anywhere             anywhere             tcp
> dpt:ssh ctstate NEW
>
> I'm going to investigate more in depth.
>
> Regards
