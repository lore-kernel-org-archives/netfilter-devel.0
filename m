From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-addons: match packets based on status of grsecurity
 RBAC
Date: Mon, 18 Oct 2010 11:50:50 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010181145360.18053@obet.zrqbmnf.qr>
References: <20101017135202.8AFEE148E1BC@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pva@gentoo.org,
	hardened@gentoo.org, zbyniu@destrukcja.pl, spender@grsecurity.net,
	pageexec@freemail.hu
To: basile@opensource.dyc.edu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46098 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab0JRJuv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:50:51 -0400
In-Reply-To: <20101017135202.8AFEE148E1BC@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-10-17 15:52, basile@opensource.dyc.edu wrote:

>This patch adds a module which is useful to users of
>grsecurity's RBAC system.  It matches packets based
>on whether RBAC is enabled or disabled.

Can you elaborate a bit on how this is useful in conjunction with 
rulesets? I could imagine it be used with LSM selctx'es for example, or 
another extension that tests for other RBAC attributes.

Also, I don't see a xt_gradm.c in this patch.


thanks,
Jan
