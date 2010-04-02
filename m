From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: br_netfilter post routing hook question...
Date: Fri, 2 Apr 2010 19:32:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004021932210.14322@obet.zrqbmnf.qr>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gareth Williams <gwilliams@ubicom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51174 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab0DBRcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:32:47 -0400
In-Reply-To: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-04-02 16:18, Gareth Williams wrote:
>
>Unfortunately I cannot see these marks in my code because the priority
>on the bridge_netfilter post routing hook is PRI_LAST.
>
>Since it is PRI_LAST I have no room to put my hook lower than it - so I
>will never see these marks.

Yeah I'll schedule proposing a patch.

