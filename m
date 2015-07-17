From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: nf_conntrack: falling back to vmalloc.
Date: Fri, 17 Jul 2015 11:00:24 +0200
Message-ID: <55A8C428.1000005@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I do run a server with a 64 bit hardened Gentoo Linux (kernel currently 4.0.8).
Around 12th of July it started to spew those messages into kern.log :

/var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650490] nf_conntrack: falling back to vmalloc.
/var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650615] nf_conntrack: falling back to vmalloc.
/var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673649] nf_conntrack: falling back to vmalloc.
/var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673786] nf_conntrack: falling back to vmalloc.

I read https://bugzilla.openvz.org/show_bug.cgi?id=3092 but a reboot did not help.
I got 1-2 thousends of those lines per day.

Any hints ?

-- 
Toralf, pgp key: 872AE508 0076E94E
