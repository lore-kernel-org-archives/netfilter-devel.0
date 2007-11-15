From: Milan =?iso-8859-2?B?S3LobeH4?= <krcmar@datinel.cz>
Subject: Re: Allow MARK in other tables?
Date: Thu, 15 Nov 2007 01:20:50 +0100
Message-ID: <20071115002050.GA14474@hornet.din.cz>
References: <20071107163647.GA5874@hornet.din.cz> <Pine.LNX.4.64.0711141157310.24744@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hornet.din.cz ([85.13.72.2]:54749 "EHLO hornet.din.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbXKOAUx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:20:53 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711141157310.24744@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> On Nov 7 2007 17:36, krcmar@datinel.cz wrote:
> >
> >I am sorry for what could be a stupid question, but _why_ is the MARK
> >target allowed only within the `mangle' table? It does _not_ alter the
> >packet in any way (which I suppose is the reason for all the mangling
> >targets to be limited to the mangle table, e. g. destroying checksums).
> 
> Yes, it's bad, and has been brought up a number of times.
> http://lkml.org/lkml/2007/10/12/176 if you like to jump in.
> 
> >I need some information from tests being performed in the `raw'
> >table to be reused in other tables, and the mark associated with packet
> >seems to me to be the only place to note the information. Am I right?
> 
> You could (ab)use CONNMARK, or modify the MARK code so that it allows
> it to set the mark from elsewhere.

Hello Jan,

the link in your e-mail points to general discussions about
reorganization of tables, which need not be necessarily my case.

I can not (ab)use the CONNMARK, it would cause race conditions at least
at SMP, when two packets of a single connection arrive at the same time.

I've skimmed kernel's sourcecode to find anything relevant (grep -r
nfmark /), and the only problem I've found (protecting me from changing
nfmark's value outside of the `mangle' table) is nfmark's use in routing
decisions. In general, there are two options for me (well, three, if I
admit nfmark's use in routing's rules is rarely used :-))

(1) to check for the change (and reroute) at the end of _each_ table
    traversal,

(2) to extend the sk_buff struct with yet another mark, which would not
    be used outside of netfilter (and especially in routing decisions)

Both are bad, exhausting more resouces (which at general leads to
discussions similar to those you've given the link to). But I _do_ really
need it. Being not able to transfer any information from `raw' to, say,
`mangle', doubles (for me) the already high number of rules traversed
with each packet.

Any suggestions? Should nobody response, I will patch the
netfilter/kernel just for me and stop disturbing this list.

Thank you anyway.

Milan
