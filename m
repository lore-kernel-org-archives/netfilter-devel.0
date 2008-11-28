From: Andy Whitcroft <apw@canonical.com>
Subject: Re: netfilter 23/29: ip{,6}t_policy.h should include xp_policy.h
Date: Fri, 28 Nov 2008 08:58:56 +0000
Message-ID: <20081128085856.GE13465@shadowen.org>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet> <20081127161534.13891.33306.sendpatchset@x2.localnet> <alpine.LNX.1.10.0811271932560.21626@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:44978 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYK1I7A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2008 03:59:00 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811271932560.21626@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 27, 2008 at 07:33:39PM +0100, Jan Engelhardt wrote:
> 
> On Thursday 2008-11-27 17:15, Patrick McHardy wrote:
> 
> >commit 018a7bf1e55000dd792194238c9043918d24d3dd
> >Author: Andy Whitcroft <apw@canonical.com>
> >Date:   Thu Nov 20 15:59:56 2008 +0100
> >
> >    netfilter: ip{,6}t_policy.h should include xp_policy.h
> 
> Still trying to fix Bug #1? It's xt_policy, not XP ;-)

Heh, sorry seems my dyslexia strikes again.  The patch itself of course
is sane just the write up.  If you want me to respin let me know.

-apw
