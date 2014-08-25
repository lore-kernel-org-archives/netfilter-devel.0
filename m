From: Paul Robert Marino <prmarino1@gmail.com>
Subject: Re: ARP flux on bond interface
Date: Mon, 25 Aug 2014 17:20:24 -0400
Message-ID: <CAPJdpdAuF4Db-SJbjnx90qmETBanCZMPv5mVutd=Bxm2Pufytg@mail.gmail.com>
References: <CAMRqRqwzKEe4-L4Zxp8fciVQc_aN02uBuR9kSWmr3vQHc3xJBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Max Dmitrichenko <dmitrmax@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35292 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaHYVUZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:20:25 -0400
Received: by mail-qg0-f42.google.com with SMTP id j5so13996925qga.29
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2014 14:20:24 -0700 (PDT)
In-Reply-To: <CAMRqRqwzKEe4-L4Zxp8fciVQc_aN02uBuR9kSWmr3vQHc3xJBA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That sounds like you have forwarding enabled. disable ip forwarding if
you can and that should go away.
In /etc/sysctl.conf set the following "net.ipv4.ip_forward = 0",
"net.ipv4.conf.all.mc_forwarding = 0", "net.ipv4.ip_forward = 0",
"net.ipv6.conf.all.forwarding = 0", "net.ipv6.conf.all.mc_forwarding =
0", etc. which should be the default in SL 6
In short if you run " sysctl -a |grep forward" and any thing has a 1
next to it set it to 0 in /etc/sysctl.conf

then run "sysctl -p"

If that does not work you may have a bug, or it could be just a funkie
routing table. this is why you gennerally dont put 2 or more
interfaces on the same subnet with different IP addresses if you can
avoid it.



On Mon, Aug 25, 2014 at 4:47 AM, Max Dmitrichenko <dmitrmax@gmail.com> wrote:
> Hi!
>
> There is a strange problem on the following setup.
>
> There is two bond interfaces in the same IP-subnet (I know this is a
> little bit weird). Let's say first has IP-address Ai and MAC-address
> Am and the second Bi and Bm respectively.
>
> Sometimes when interface B makes an ARP-request, the same request
> appears on the interface A, but with source MAC-address of B, i.e. Bm.
> This event poisons the ARP-table of the upstream switch and it sends
> to A packets addressed to B which are dropped by my host system.
>
> I've set arp_ignore=1 and tried to set arp_announce to 1 and 2, but
> neither combination helps.
>
> Is it kind of bug or it is expected behavior?
>
> The kernel version is 2.6.32 from Scientific Linux 6.5 (i.e. it is
> very close to one from RHEL 6).
>
> --
> Max
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
