From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Mon, 17 Dec 2007 13:52:28 +0100
Message-ID: <4766710C.6030009@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr> <475E639A.9040501@trash.net> <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712151720530.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56866 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbXLQMxO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:53:14 -0500
In-Reply-To: <Pine.LNX.4.64.0712151720530.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Add __beXX types to libiptc.
> Also add __be64/__le64 for completeness.

Doesn't compile here:

Extensions found:
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.24-rc3/build"/include 
-I"/lib/modules/2.6.24-rc3/source"/include -Iinclude/ 
-DIPTABLES_VERSION=\"1.4.0rc1\"  -fPIC -o extensions/libipt_iprange_sh.o 
-c extensions/libipt_iprange.c
In file included from 
/lib/modules/2.6.24-rc3/build/include/linux/netfilter_ipv4/ipt_iprange.h:5,
                  from extensions/libipt_iprange.c:10:
/lib/modules/2.6.24-rc3/build/include/linux/types.h:185: error: 
conflicting types for 'u_int64_t'
/usr/include/sys/types.h:204: error: previous declaration of 'u_int64_t' 
was here
/lib/modules/2.6.24-rc3/build/include/linux/types.h:186: error: 
redefinition of typedef 'u_int64_t'
/lib/modules/2.6.24-rc3/build/include/linux/types.h:185: error: previous 
declaration of 'u_int64_t' was here
make: *** [extensions/libipt_iprange_sh.o] Error 1

I guess we still should add the missing <linux/types.h> inlucdes
to the netfilter headers for old userspace sources.
