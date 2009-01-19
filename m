From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Permit *any* destination port from source ip
Date: Mon, 19 Jan 2009 21:14:27 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901192112530.11601@fbirervta.pbzchgretzou.qr>
References: <C59A488F.D281%simon@clubbeadplus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Simon Labrecque <simon@clubbeadplus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45030 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZASUO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:14:28 -0500
In-Reply-To: <C59A488F.D281%simon@clubbeadplus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-19 21:11, Simon Labrecque wrote:
>
>   I would like to have a specific connection act like an "authentication"
>service; that is, when a connection to a specific port is made and once the
>required data has passed between the 2 hosts, the client is now
>authenticated, permitting access to other network services which are flagged
>with the RELATED state (and not the NEW one).

"RELATED" is for protocol-related connections and, I think, it should
not be abused to denote "AUTHENTICATED".

>   Is this possible? It seems it was possible a while ago (while
>exp->mask.dst was still present), but this was removed and I don't see how I
>can achieve the same functionality with the current structures. Am I missing
>something?

A userspace daemon can augment the ruleset after authentication,
either by calling iptables(8), or iptables-restore/save.
