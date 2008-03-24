From: "Igor M Podlesny" <for.poige+linux.nf@gmail.com>
Subject: How to unambiguously classify own multicast-loop traffic with Netfilter?
Date: Mon, 24 Mar 2008 23:04:51 +0700
Message-ID: <43d009740803240904i3d6df4ffi7dc9ad9d9e68f69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:45287 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759994AbYCXQEx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:04:53 -0400
Received: by rn-out-0910.google.com with SMTP id v46so1336718rnb.15
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2008 09:04:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

Recently my home network got additional network connection, so I
decided to try using Zebra to see if the whole set-up would be simpler
and easier to maintain. During the test period I've noticed that
Netfilter "sees" locally originated multicast traffic as
external-incoming one:

       [125488.045542] RAW: M: IN=eth3 OUT= MAC= SRC=172.19.20.2
DST=224.0.0.9 LEN=512 TOS=0x10 PREC=0x00 TTL=1 ID=0 DF PROTO=UDP
SPT=520 DPT=520 LEN=492

       (Caught with such set-up:
       *raw
       -A PREROUTING -d 224.0.0.9/32 -i eth3 -m pkttype --pkt-type multicast
-j LOG --log-prefix "RAW: M: " --log-ip-options)

IP-addr. "172.19.20.2" is a local one; it's assigned to interface "eth3".

       I dug a bit more and can suppose that Zebra's RIPv2 uses
IP_MULTICAST_LOOP flag. But then another question arises: is there a
good/proper way to detect such kind a traffic with Netfilter? I mean
such a way that would exclude possibilities for bogus traffic being
treated as IP_MULTICAST_LOOP, i.e., how to unambiguously classify own
multicast-loop traffic with Netfilter?

-- 
End of message. Next message?
