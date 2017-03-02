From: Tugrul Erdogan <h.tugrul.erdogan@gmail.com>
Subject: About Kernel SynProxy Performance
Date: Thu, 2 Mar 2017 09:03:45 +0300
Message-ID: <CA+whn7QO8j=BYOebrJ8=SP79Wn1_w+47VDeHHuP_hWSEQKoe4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36048 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdCBGaU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 01:30:20 -0500
Received: by mail-qk0-f175.google.com with SMTP id n186so105610678qkb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Mar 2017 22:30:17 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I have noticed the commit below in the kernel 4.7 change logs.

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b3d051477cf94e9d71d6acadb8a90de15237b9c1

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8804b2722dc5d6f9b7ba0a9e812eae9ee5ce95bc

Then, I think that this commit might increase SYNPROXY performance of
kernel too and updated my kernel from 3.15.9 to 4.10. But I didn't
notice any significant change on received pps with netfilter/SYNPROXY
module.

I wanted to ask you what may be the reason of that. The commit message
says that the task test result would have approximately %100 increase.

Could you give more details about the reflection of this commit to
SYNPROXY module on performance perspective.

If this commit not affect SYNPROXY module, I want to take your
opinions about is there a way to increase SYNPROXY performace with
some changes which are adopted from the commit linked above on
SYNPROXY internals.

CPU and nic info I used is below:

Intel(R) Xeon(R) CPU   E5645  @ 2.40GHz

82599ES 10-Gigabit SFI/SFP+ Network Connection

and iptables rules

-t raw -A PREROUTING -p tcp -m physdev --physdev-in enp7s0f0 -m tcp
--tcp-flags FIN,SYN,RST,ACK SYN -j NOTRACK

-t filter -A FORWARD -p tcp -m physdev --physdev-in enp7s0f0 -m state
--state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale
7 --mss 1480

Thanks for your kind replies.
Best regards,
Tugrul
