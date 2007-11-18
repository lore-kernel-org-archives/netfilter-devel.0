From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: Re: Make/compile error for iptables-1.4.0rc1
Date: Sun, 18 Nov 2007 13:49:42 +0100
Message-ID: <1195390182.15945.57.camel@localhost.localdomain>
References: <1195245146.15945.50.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	yasuyuki@netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:33965 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbXKRMux (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 07:50:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711162234000.21235@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2007-11-16 at 22:34 +0100, Jan Engelhardt wrote:
> On Nov 16 2007 21:32, Jesper Dangaard Brouer wrote:
> >
> >I get a compile/make error when compiling iptables-1.4.0rc1 and latest
> >SVN revision (r7090).
> >
> >cc -O2 -Wall -Wunused -I"/lib/modules/2.6.18-5-686/build"/include -I"/lib/modules/2.6.18-5-686/source"/include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0rc1\"  -DIPT_LIB_DIR=\"/usr/lib/iptables\" -c -o iptables.o iptables.c
> >iptables.c:207: error: 'XT_SO_GET_REVISION_MATCH' undeclared here (not in a function)
> >iptables.c:208: error: 'XT_SO_GET_REVISION_TARGET' undeclared here (not in a function)
> >make: *** [iptables.o] Error 1
> 
> In 7090, these lines have IPT_SO_GET_REVISION_xxx.

Thats also what I wrote in my previous mail, I'll quote my self again:

On Fri, 2007-11-16 at 21:32 +0100, Jesper Dangaard Brouer wrote:
> SVN blame on iptables.c line 207-208 says its changed by Yasuyuki
> Kozakai with chainset 6920.
>
> The strange thing about these lines is that they contain
> IPT_SO_GET_REVISION_xxx and not XT_SO_GET_REVISION_xxx as the compiler
> claims. Is some strange macro stuff going on here?

Does anyone else have this problem with iptables-1.4.0rc1, or is it just
my compile environment which is screwed?

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
