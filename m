From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: kernel header divergence
Date: Sat, 21 Feb 2009 02:27:32 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902210226440.25933@fbirervta.pbzchgretzou.qr>
References: <20090220163038.5235871d@extreme>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59149 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZBUB1d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:27:33 -0500
In-Reply-To: <20090220163038.5235871d@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-21 01:30, Stephen Hemminger wrote:

>The headers in iptables command source (include/linux) are different than
>the headers produced by the kernel header sanitation process:
>  make headers_install
>
>Has someone looked into rectifying this? 

They were last resynced before the workshop IIRC, and in fact, the 
headers are allowed to diverge a bit. Is it a large change that gets 
introduced by resyncing to 2.6.29?
