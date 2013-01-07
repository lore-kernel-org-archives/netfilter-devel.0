From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Re: arptables bug.
Date: Mon, 7 Jan 2013 20:50:51 +0000
Message-ID: <201301072050.51941.steven@springl.ukfsn.org>
References: <201301052056.18524.steven@springl.ukfsn.org> <20130107032415.GA18563@1984>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:39114 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3AGUu5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:50:57 -0500
In-Reply-To: <20130107032415.GA18563@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 07 Jan 2013 03:24:15 Pablo Neira Ayuso wrote:
> On Sat, Jan 05, 2013 at 08:56:18PM +0000, Steven Jan Springl wrote:
> > Hello
> > 
> > I am using arptables v0.0.3.4 in Debian Squeeze.
> > 
> > Issuing command:
> > 
> > aptables -A INPUT -i eth0 --opcode ! 1 -j DROP
> > 
> > Then issuing command arptables-save produces the following:
> > 
> > -A INPUT -j DROP -i eth0  --opcode 1
> > 
> > The "!" is missing from the opcode.
> 
> Patch attached to fix it.
> 
> Bart, could you please apply this to your git repo? Thanks.

Pablo

I can confirm that the patch corrects the bug.

Thanks.

Steven.
