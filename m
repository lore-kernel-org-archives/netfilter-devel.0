From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: xtables: obtain random bytes earlier,
 in checkentry
Date: Mon, 04 Jan 2010 16:29:15 +0100
Message-ID: <4B42094B.50506@trash.net>
References: <1260044785-20962-1-git-send-email-jengelh@medozas.de> <1260044785-20962-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36385 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0ADP3R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:29:17 -0500
In-Reply-To: <1260044785-20962-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> We can initialize the random hash bytes on checkentry. This is
> preferable since it is outside the hot path.
> 
> Reference: http://bugzilla.netfilter.org/show_bug.cgi?id=621

Also applied, thanks.
