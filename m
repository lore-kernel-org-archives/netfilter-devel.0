From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Introduce xtables_afinfo
Date: Sat, 7 Feb 2009 20:05:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr>
References: <1234026339.4441.24.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39088 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZBGTFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:05:17 -0500
In-Reply-To: <1234026339.4441.24.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-07 18:05, jamal wrote:

>I am going to incrementally send these changes over a period of time
>until i resolve all my issues; i hope this is fine with your process.

This afinfo thing has been a red LED beam in my eye. I just do not think
iproute2-m_ipt should have to deal with afinfo at all.
..
So I now also dealt with that and moved it according to what I 
think is right - see latest git commit in mine; [77f48c2]
