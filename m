From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] Make the afinfo structure optional in nf_queue and
 nf_reinject
Date: Fri, 04 Feb 2011 14:27:53 +0100
Message-ID: <4D4BFED9.7090605@trash.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-2-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46658 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1BDN2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:28:08 -0500
In-Reply-To: <1296743540-8148-2-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03.02.2011 15:32, Pierre Chifflier wrote:
> Packets coming from the bridge do not have an afinfo registered,
> so make the call to get the structure optional.

This patch looks fine to me.

Regarding your crash - in what chain are you queueing the packet?
We also need the exact backtrace.
