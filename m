From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: Re: Make/compile error for iptables-1.4.0rc1
Date: Sun, 18 Nov 2007 15:23:07 +0100
Message-ID: <1195395787.15945.77.camel@localhost.localdomain>
References: <1195245146.15945.50.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
	 <1195390182.15945.57.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	yasuyuki@netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:43512 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXKROYR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:24:17 -0500
In-Reply-To: <1195390182.15945.57.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2007-11-18 at 13:49 +0100, Jesper Dangaard Brouer wrote:
> On Fri, 2007-11-16 at 21:32 +0100, Jesper Dangaard Brouer wrote:
> > SVN blame on iptables.c line 207-208 says its changed by Yasuyuki
> > Kozakai with chainset 6920.
> >
> > The strange thing about these lines is that they contain
> > IPT_SO_GET_REVISION_xxx and not XT_SO_GET_REVISION_xxx as the
> compiler
> > claims. Is some strange macro stuff going on here?
> 
> Does anyone else have this problem with iptables-1.4.0rc1, or is it
> just my compile environment which is screwed? 

Now I have tried to compile on three debian boxes (incl.
people.netfilter.org) where it fails!  I also tried it on a Gentoo box
where it success!  

The problem is "strange macro stuff" because on debian, the header file:
 /usr/include/linux/netfilter_ipv4/ip_tables.h

Defines:
#define IPT_SO_GET_REVISION_MATCH       XT_SO_GET_REVISION_MATCH
#define IPT_SO_GET_REVISION_TARGET      XT_SO_GET_REVISION_TARGET

So fare it looks like a debian bug, in package linux-kernel-headers
(2.6.18-7), because the latest kernel has these defines:

#define IPT_SO_GET_REVISION_MATCH       (IPT_BASE_CTL + 2)
#define IPT_SO_GET_REVISION_TARGET      (IPT_BASE_CTL + 3)

Is this a debian bug? or did the kernel header at some point contain the
IPT_xxx to XT_SO_xxx re-defines?

Look below for what I could find in git...

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer


commit b96e7ecbd052a0916b6078e7600604d7e276a336
Author: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date:   Tue Nov 14 19:48:48 2006 -0800

    [NETFILTER]: ip6_tables: fixed conflicted optname for getsockopt
    
    66 and 67 for getsockopt on IPv6 socket is doubly used for IPv6 Advanced
    API and ip6tables. This moves numbers for ip6tables to 68 and 69.
    This also kills XT_SO_* because {ip,ip6,arp}_tables doesn't have so much
    common numbers now.
    
    The old userland tools keep to behave as ever, because old kernel always
    calls functions of IPv6 Advanced API for their numbers.
    
    Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

