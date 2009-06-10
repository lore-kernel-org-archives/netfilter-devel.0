From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Wed, 10 Jun 2009 14:16:24 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906101405590.30984@fbirervta.pbzchgretzou.qr>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org> <4A2D171E.9060401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54199 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZFJMQX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:16:23 -0400
In-Reply-To: <4A2D171E.9060401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-06-08 15:50, Patrick McHardy wrote:
>>> From: Michael Granzow <mgranzow@zeus.com>
>>>
>>> libiptc already supports adding and deleting multiple rules with
>>> different addresses, so it only needs to be wired up to the options.
>>>
>>> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>
> No objections besides that its too large for this late in the cycle.
>
Git is not as castrated as Hg when it comes to branches, so why not
make a "stable" branch that is then regularly merged into master? :)

The concept fares well with e.g. pam_mount (look at its gitk tree from v0.43
downards); automake also considered, and now uses, this scheme.
