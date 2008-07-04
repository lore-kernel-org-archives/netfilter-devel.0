From: "Juan Pablo Nelson" <juanpablonelson@gmail.com>
Subject: Help on compiling iptables targets
Date: Fri, 4 Jul 2008 20:45:59 +0200
Message-ID: <94ce93aa0807041145p6a118044gf91f5634555d79db@mail.gmail.com>
References: <94ce93aa0807041142i3fec004eh4b8b4aa01ddd85f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:43630 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYGDSqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:46:02 -0400
Received: by yw-out-2324.google.com with SMTP id 9so575035ywe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2008 11:46:00 -0700 (PDT)
In-Reply-To: <94ce93aa0807041142i3fec004eh4b8b4aa01ddd85f1@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all
I m trying to write new tables, targets and matches for iptables.
I have compiled a new table (mytable) and get a .ko file; then insmod
in the kernel and finally used it from iptables command without
problems.
The script i used is:

obj -m := mytable.o
all:
make -C /lib/modules/$(shell uname -r)/build SUBDIRS=$(PWD) modules

Then i compiled the TTL target (just to see if thinghs go wrong) with
the same script, getting the .ko file.
When i tried to use TTL target, i got the following:

#iptables -t mangle -A PREROUTING -i eth0 -j TTL --ttl-set 64
/usr/local/libexec/xtables/libipt_TTL.so:
/usr/local/libexec/xtables/libipt_TTL.so: only ET_DYN and ET_EXEC can
be loaded
iptables v1.4.1.rc2:Unknown arg '--ttl-set'


What is the correct script to generate libipt_TTL.so?
What is the reason that iptables accept .ko tables and don accept .ko targets?

Thanks,
Juan Pablo
