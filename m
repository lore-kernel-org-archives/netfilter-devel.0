From: "Shaun R." <mailinglists@unix-scripts.com>
Subject: ebtables 2.0.9-1 build problems on centos4
Date: Mon, 27 Jul 2009 12:19:27 -0700
Message-ID: <h4kulg$lg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34897 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG0TZH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:25:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MVVol-0002yV-6l
	for netfilter-devel@vger.kernel.org; Mon, 27 Jul 2009 19:25:03 +0000
Received: from ip68-5-154-128.oc.oc.cox.net ([68.5.154.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2009 19:25:03 +0000
Received: from mailinglists by ip68-5-154-128.oc.oc.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2009 19:25:03 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm trying to build ebtables 2.0.9-1 on CentOS 4.  The distro has a older 
kernel provided that doesnt have x_tables.h so i have to specify the 
KERNEL_INCLUDES=linux-2.6.18.8/include/ during the make (yes i extracted the 
source there).  I'm not running a default CentOS4 kernel because i have a 
custom build Xen kernel running.  It's version is 2.6.18.8 and was pulled 
from the Xen Tree (changeset 780).  The source i extracted for the 
kernel_includes was a vanilla version of 2.6.18.8 from kernel.org.  Any 
idea's what i need to do here?

[root@host ebtables-v2.0.9-1]# make KERNEL_INCLUDES=linux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o getethertype.o getethertype.c -Iinclude/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o communication.o communication.c -Ilinux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o libebtc.o libebtc.c -Ilinux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o useful_functions.o useful_functions.c -Ilinux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o ebtables.o ebtables.c -Ilinux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o extensions/ebt_802_3.o 
extensions/ebt_802_3.c -Ilinux-2.6.18.8/include/
gcc -Wall -Wunused -fPIC -DPROGVERSION=\"2.0.9-1\" -DPROGNAME=\"ebtables\" -DPROGDATE=\"June\ 
2009\" -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50 -DEBTD_CMDLINE_MAXLN=2048 
 -c -o extensions/ebt_nat.o extensions/ebt_nat.c -Ilinux-2.6.18.8/include/
extensions/ebt_nat.c: In function `parse_s':
extensions/ebt_nat.c:99: error: `EBT_VERDICT_BITS' undeclared (first use in 
this function)
extensions/ebt_nat.c:99: error: (Each undeclared identifier is reported only 
once
extensions/ebt_nat.c:99: error: for each function it appears in.)
extensions/ebt_nat.c:104: error: `NAT_ARP_BIT' undeclared (first use in this 
function)
extensions/ebt_nat.c: In function `final_check_s':
extensions/ebt_nat.c:146: error: `EBT_VERDICT_BITS' undeclared (first use in 
this function)
extensions/ebt_nat.c: In function `print_s':
extensions/ebt_nat.c:183: error: `NAT_ARP_BIT' undeclared (first use in this 
function)
extensions/ebt_nat.c:185: error: `EBT_VERDICT_BITS' undeclared (first use in 
this function)
make: *** [extensions/ebt_nat.o] Error 1



