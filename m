From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 1/4] Make iptables-restore usable over a pipe
Date: Mon, 12 May 2008 20:39:24 +0200
Message-ID: <48288EDC.20605@trash.net>
References: <1210616433.3442.28.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50235 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYELSkC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:40:02 -0400
In-Reply-To: <1210616433.3442.28.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> The attached patch flushes stdout between commands to make output
> operations (-L etc) in iptables-restore usable over a pipe. stdio by
> defaut buffers output if not connected to a terminal.

Applied, thanks.
