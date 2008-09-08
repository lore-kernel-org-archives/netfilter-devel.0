From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/04]: Netfilter fixes
Date: Sun, 07 Sep 2008 18:23:30 -0700 (PDT)
Message-ID: <20080907.182330.201693956.davem@davemloft.net>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYIHBXh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:23:37 -0400
In-Reply-To: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  4 Sep 2008 16:15:53 +0200 (MEST)

> following are four netfilter fixes for 2.6.27, containing:
> 
> - fix for a accidentally introduced static variable in the SIP helper
>   that was intended to be local from Alexey
> 
> - a GRE helper keymap locking and list iteration fix from Alexey
> 
> - a patch to make the IRC helpers' port parsing more robust against the
>   issues pointed out by Alexey

I applied all of this.

Please limit the scope of anything you send in the future outside of
the merge window.  The "kfree the list head instead of the object itself"
doesn't fix anything, the code worked in it's current form.

These are mostly just cleanups due to code inspection rather than
fixes for bugs that users are actually hitting and reporting.  The
latter (as well as cures for fully exploitable DoS things, obviously)
is the only thing I want to be seeing outside of the merge window.

Thanks.
