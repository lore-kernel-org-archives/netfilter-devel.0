From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xtables: do not grab random bytes at __init
Date: Mon, 04 Jan 2010 16:27:48 +0100
Message-ID: <4B4208F4.9060501@trash.net>
References: <1260044785-20962-1-git-send-email-jengelh@medozas.de> <1260044785-20962-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0ADP1u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:27:50 -0500
In-Reply-To: <1260044785-20962-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> References: http://bugzilla.netfilter.org/show_bug.cgi?id=621
> 
> "It is deliberately not done in the init function, since we might not
> have sufficient random while booting."

Applied, thanks.
