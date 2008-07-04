From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help on compiling iptables targets
Date: Fri, 4 Jul 2008 20:55:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807042053310.31959@fbirervta.pbzchgretzou.qr>
References: <94ce93aa0807041142i3fec004eh4b8b4aa01ddd85f1@mail.gmail.com> <94ce93aa0807041145p6a118044gf91f5634555d79db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Juan Pablo Nelson <juanpablonelson@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYGDSzw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:55:52 -0400
In-Reply-To: <94ce93aa0807041145p6a118044gf91f5634555d79db@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 20:45, Juan Pablo Nelson wrote:

>Hi all
>I m trying to write new tables, targets and matches for iptables.
>I have compiled a new table (mytable) and get a .ko file; then insmod
>in the kernel and finally used it from iptables command without
>problems.
>The script i used is:
>
>obj -m := mytable.o
>all:
>make -C /lib/modules/$(shell uname -r)/build SUBDIRS=$(PWD) modules
>
>Then i compiled the TTL target (just to see if thinghs go wrong) with
>the same script, getting the .ko file.
>When i tried to use TTL target, i got the following:
>
>#iptables -t mangle -A PREROUTING -i eth0 -j TTL --ttl-set 64
>/usr/local/libexec/xtables/libipt_TTL.so:
>/usr/local/libexec/xtables/libipt_TTL.so: only ET_DYN and ET_EXEC can
>be loaded
>iptables v1.4.1.rc2:Unknown arg '--ttl-set'

Who knows what you did to that file...

>What is the correct script to generate libipt_TTL.so?
>What is the reason that iptables accept .ko tables and don accept .ko targets?

iptables (usersapce) does not accept .ko files (ET_REL)
at all, because they are kernel files.
