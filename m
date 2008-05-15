From: Anton <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 15:57:27 +0500
Message-ID: <200805151557.28368.anton.vazir@gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com> <200805151535.31933.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:37555 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYEOK51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 06:57:27 -0400
In-Reply-To: <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Definitelly what my test shows - while rule-inserts - if you 
try to insert 10000 rules - after a several hundreds - it 
will be inserting like a 1 rule in 1 second and slowness 
will progress :)

regarding the further slowness inside the kernel - i'm 
reffering to the following tests, since did not do mine

http://people.netfilter.org/kadlec/nftest.pdf

and

http://www.hipac.org/performance_tests/independent.html

On Thursday 15 May 2008 15:43, Jan Engelhardt wrote:
> On Thursday 2008-05-15 12:35, Anton wrote:
> >> You missed IPMARK from Xtables-addons which does the
> >> marking in O(1) instead of O(n).
> >
> >Great! This partially solves problem with marking while
> > used with shaper, but in global scope - iptables
> > remains slow?
>
> Slow, where?
