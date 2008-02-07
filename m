From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL 07/09]: Split up nfnetlink_log into log and msg objects
Date: Thu, 7 Feb 2008 13:11:39 +0100
Message-ID: <20080207121139.GZ11220@postel.suug.ch>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165524.13385.49205.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, philipc@snapgear.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46541 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbYBGMLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:11:19 -0500
Content-Disposition: inline
In-Reply-To: <20080118165524.13385.49205.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-18 17:55
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

Applied with a few whitespaces fixed. Thanks Patrick!

>     This changes the API in an incompatible way, but since this feature is
>     new and the libnl netfilter headers haven't been installed so far,
>     there shouldn't be any users affected by this.

Yes, I agree.
