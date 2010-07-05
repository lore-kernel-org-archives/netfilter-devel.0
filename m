From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: LED: fix man page fragment inclusion
Date: Mon, 05 Jul 2010 10:41:32 +0200
Message-ID: <4C319ABC.5040904@trash.net>
References: <684658.18910.qm@web112308.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab0GEIlb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:41:31 -0400
In-Reply-To: <684658.18910.qm@web112308.mail.gq1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sergei Zhirikov wrote:
> No, it was the correct patch. The Makefile looks for NFPROTO_UNSPEC in the source file in order to decide whether the manpage fragment should be included.
>   

I see, thanks. Please make a formal submission, including a
Signed-off-by: line.
