From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons build failed with linux 4.5 header
Date: Fri, 22 Apr 2016 15:46:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604221535250.14824@nerf40.vanv.qr>
References: <57175EB6.8040308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, normand@linux.vnet.ibm.com
To: mikko.rapeli@iki.fi
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46894 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbcDVNq2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Apr 2016 09:46:28 -0400
In-Reply-To: <57175EB6.8040308@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-04-20 12:49, Normand wrote:
> -fasynchronous-unwind-tables -g -o libxt_pknock.oo -c libxt_pknock.c;
> [   81s] In file included from /usr/include/iptables/xtables.h:16:0,
> [   81s]                  from libxt_pknock.c:15:
> [   81s] /usr/include/linux/if.h:71:2: error: redeclaration of enumerator
> 'IFF_UP'
> [   81s]   IFF_UP    = 1<<0,  /* sysfs */
> [   81s]   ^

git blame include/uapi/linux/netfilter_ipv4/ip_tables.h:
1ffad83d (Mikko Rapeli  2015-10-15 07:56:30 +0200  20) #include <linux/if.h>

Great. That commit broke userspace programs like

 #include <net/if.h>
 #include <linux/netfilter_ipv4/ip_tables.h>

The only reason it did not break the iptables source code _yet_ is 
because iptables.git keeps a cached copy (old by now). As soon as 
someone updates those too as part of the regular routine, all goes to 
the bin.
