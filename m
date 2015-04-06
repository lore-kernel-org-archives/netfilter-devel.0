From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Mon, 6 Apr 2015 03:51:28 +0200
Message-ID: <20150406015128.GA20515@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
 <20150405113214.GA23433@acer.localdomain>
 <20150405121104.GD23433@acer.localdomain>
 <552187FB.60904@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62756 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbDFBvc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 21:51:32 -0400
Content-Disposition: inline
In-Reply-To: <552187FB.60904@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.04, Alexander Holler wrote:
> Am 05.04.2015 um 14:11 schrieb Patrick McHardy:
> > On 05.04, Patrick McHardy wrote:
> 
> >> Basically this involves splitting the expression types into lhs (non-const)
> >> and rhs (const) parts. Keywords on the RHS side can be caught using an
> >> error statement and deferred to resolution during runtime.
> 
> Sounds like trial and error. ;)

The approach is, the patch isn't, it changes the grammar to have
these kinds of errors in a defined state. The patch I sent
however is, but I'm quite sure i understand the implications.
