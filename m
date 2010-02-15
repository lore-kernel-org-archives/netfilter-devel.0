From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_recent: inform user when hitcount is too
 large
Date: Mon, 15 Feb 2010 16:32:20 +0100
Message-ID: <4B796904.5000605@trash.net>
References: <1265992318-14872-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0BOPcY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:32:24 -0500
In-Reply-To: <1265992318-14872-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> It is one of these things that iptables cannot catch and which can
> cause "Invalid argument" to be printed. Without a hint in dmesg, it is
> not going to be helpful.

Applied, thanks.

