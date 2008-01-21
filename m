From: Philip Craig <philipc@snapgear.com>
Subject: Re: [LIBNL 07/09]: Split up nfnetlink_log into log and msg objects
Date: Mon, 21 Jan 2008 18:05:40 +1000
Message-ID: <47945254.5000008@snapgear.com>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165524.13385.49205.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:53410 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753026AbYAUH7O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 02:59:14 -0500
In-Reply-To: <20080118165524.13385.49205.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> commit c566db4405200994482d36fac45089aba4e2360a
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 17:52:41 2008 +0100
> 
>     [LIBNL]: Split up nfnetlink_log into log and msg objects
>     
>     Split the nfnetlink_log code into two seperate objects, "netfilter/log"
>     to represent logging instances and "netfilter/log_msg" to represent
>     log messages. Also perform some function name unification for consistency
>     with other libnl object types, mainly renaming nfnl_log_build_*_msg
>     to nfnl_log_build_*_request.
>     
>     This changes the API in an incompatible way, but since this feature is
>     new and the libnl netfilter headers haven't been installed so far,
>     there shouldn't be any users affected by this.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Definitely an improvement, thanks. The pf bind/unbind are still handled
differently, but I guess they are too simple to warrant it and will
never get more attributes.

I hadn't noticed the missing headers because my cross compile
environment has its own custom install target.

