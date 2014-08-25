From: Max Dmitrichenko <dmitrmax@gmail.com>
Subject: ARP flux on bond interface
Date: Mon, 25 Aug 2014 12:47:23 +0400
Message-ID: <CAMRqRqwzKEe4-L4Zxp8fciVQc_aN02uBuR9kSWmr3vQHc3xJBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48512 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaHYIr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:47:27 -0400
Received: by mail-pd0-f174.google.com with SMTP id fp1so19902753pdb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2014 01:47:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

There is a strange problem on the following setup.

There is two bond interfaces in the same IP-subnet (I know this is a
little bit weird). Let's say first has IP-address Ai and MAC-address
Am and the second Bi and Bm respectively.

Sometimes when interface B makes an ARP-request, the same request
appears on the interface A, but with source MAC-address of B, i.e. Bm.
This event poisons the ARP-table of the upstream switch and it sends
to A packets addressed to B which are dropped by my host system.

I've set arp_ignore=1 and tried to set arp_announce to 1 and 2, but
neither combination helps.

Is it kind of bug or it is expected behavior?

The kernel version is 2.6.32 from Scientific Linux 6.5 (i.e. it is
very close to one from RHEL 6).

--
Max
