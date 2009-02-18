From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] netfilter: Combine ipt_ttl and ip6t_hl source
Date: Wed, 18 Feb 2009 18:59:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902181855570.8011@fbirervta.pbzchgretzou.qr>
References: <1234972949-12036-1-git-send-email-jengelh@medozas.de> <1234972949-12036-3-git-send-email-jengelh@medozas.de> <499C4813.8070102@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55835 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZBRR7o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:59:44 -0500
In-Reply-To: <499C4813.8070102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-18 18:40, Patrick McHardy wrote:
>
> Also applied, thanks. How about a compat config option for one
> or two releases to keep the make oldconfig annoyance down?
>
This has been previously discussed with Sam or Roman, the end result
being that kbuild does not quite support option fowarding - every
symbol (e.g. OLD_TTL) that has no text will only be enabled if another
symbol references it (thru 'select' for example) and otherwise any
value, even one from .config, will be discarded and set to =n instead.
But when OLD_TTL=n, the 'select NEW_TTL' on OLD_TTL will not take
effect, and so on..
