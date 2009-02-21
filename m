From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Sat, 21 Feb 2009 02:25:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210224330.25933@fbirervta.pbzchgretzou.qr>
References: <20090220162831.1d0bf3d4@extreme>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41092 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZBUBZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:25:56 -0500
In-Reply-To: <20090220162831.1d0bf3d4@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2009-02-21 01:28, Stephen Hemminger wrote:

>Fix build failure of iptables utilities on debian/ubuntu, maybe other distros.
>The values INT_MIN and INT_MAX are used by many filters and these
>are defined in limits.h

No this is not right IMO, limits.h should be included for the same 
reason you would not do that to kernel's .h files.
Instead, limits.h should go in the .c files.
