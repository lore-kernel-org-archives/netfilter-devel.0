From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iprange non-range recognition
Date: Sun, 25 Oct 2009 11:28:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910251123490.3852@obet.zrqbmnf.qr>
References: <1253741194-26060-1-git-send-email-jengelh@medozas.de> <20091025100943.GR29852@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46966 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZJYK2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Oct 2009 06:28:08 -0400
In-Reply-To: <20091025100943.GR29852@prithivi.gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Harald,

On Sunday 2009-10-25 11:09, Harald Welte wrote:
>On Wed, Sep 23, 2009 at 11:26:30PM +0200, Jan Engelhardt wrote:
> 
>> here is a fix and subsequent cleanups to Debian bug #547139.
>> Please merge.
>
>sorry for the long delay, I've merged your patches into iptables master.

[Re the other message] I took the freedom to continue to push to my 
master while Patrick is now unfortunately away, and did not expect that 
anyone would still consider all the merge requests valid.

Ok so they got merged, though you seemed to have done that with 
cherry-pick rather than merge (they are the same after all). Just a note 
- you c-p'd them all in _reverse_. I hope they applied though.
