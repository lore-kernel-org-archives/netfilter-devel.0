From: Anton <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 15:35:31 +0500
Message-ID: <200805151535.31933.anton.vazir@gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151125570.16151@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:44851 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYEOKf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 06:35:28 -0400
In-Reply-To: <alpine.LNX.1.10.0805151125570.16151@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 15 May 2008 14:26, Jan Engelhardt wrote:
> On Thursday 2008-05-15 11:21, Anton wrote:
> > IPTABLES - but it's known that iptables insert/lookup
> > is very slow on huge rulesets (atleat with iptables
> > 1.3.x) and slowness progresses approximatelly
> > exponentially on growth of rules number.
> >
> >Do I miss anything?
>
> You missed IPMARK from Xtables-addons which does the
> marking in O(1) instead of O(n).

Great! This partially solves problem with marking while used 
with shaper, but in global scope - iptables remains slow?
