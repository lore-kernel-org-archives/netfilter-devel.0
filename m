From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables: improve chain name validation
Date: Mon, 7 Oct 2013 16:14:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1310071613590.6551@nerf07.vanv.qr>
References: <20131005163315.GA16881@home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:47621 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab3JGOOt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:14:49 -0400
In-Reply-To: <20131005163315.GA16881@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2013-10-05 18:33, Phil Oester wrote:

>As pointed out by Andrew Domaszek, iptables allows whitespace to be 
>included in chain names.  This causes issues with iptables-restore, and 
>later iptables actions on the chain.  Attached patch disallows 
>whitespace, and also consolidates all chain name checking into a new 
>function.

IMO iptables-save should just put the chain name in quotes (calling 
xtables_save_string) if there is a need to do so.
