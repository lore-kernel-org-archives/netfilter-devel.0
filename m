From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables and the generic xtables issues
Date: Wed, 15 Oct 2008 22:00:58 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810152151070.28060@fbirervta.pbzchgretzou.qr>
References: <48F69C2A.8010001@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48015 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYJPCA7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:00:59 -0400
In-Reply-To: <48F69C2A.8010001@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-15 21:43, Pablo Neira Ayuso wrote:
>
>Currently, we have tagged quite a lot of targets and matches with
>AF_UNSPEC as they are generic for the netfilter supported protocols.
>This is fine if we only think of ebtables, iptables and ip6tables but
>not for arptables, I doubt that all those target and matches can work
>with arptables - even if we still need the userspace support, of course.
>
>I think that we should fix those, right?

That would be a tremendous amount of work, given that arptables (and
ebtables too) is not quite the same codebase as iptables anymore.
Most of the iptables development just went by arp and ebtables due
to the nature of all these semiforks.

I think we should rather focus on a truly family-independent table
in the very near future. In fact I have ideas floating around that,
but am stuck with how I'd exactly funnel it into reviewable patch
chunks.
