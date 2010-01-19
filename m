From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 10:55:37 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001191047480.13020@obet.zrqbmnf.qr>
References: <4B5575CB.5050207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39621 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab0ASJzj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:55:39 -0500
In-Reply-To: <4B5575CB.5050207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-01-19 10:05, Patrick McHardy wrote:

>The attached two patches add a 'CT' target to specify parameters
>used during conntrack creation. This can be used to manually attach
>a helper to a connection. A couple of patches I'm still working
>on will additionally use this for the "conntrack zones" classification.
>
>I'm wondering if anyone has further ideas of parameters that might
>make sense to support.

Phil Oester/Pablo had proposed an earlier conntrack target to do just 
that.

[3] 
http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/21499
(Can't find Pablo's update to that)
