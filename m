From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: rectify XT_FUNCTION_MAXNAMELEN usage
Date: Tue, 27 Apr 2010 15:35:25 +0200
Message-ID: <4BD6E81D.7060300@trash.net>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de> <1271856071-32179-3-git-send-email-jengelh@medozas.de> <4BD02998.707@trash.net> <alpine.LSU.2.01.1004261447250.28260@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab0D0Nf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:35:27 -0400
In-Reply-To: <alpine.LSU.2.01.1004261447250.28260@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> netfilter: x_tables: rectify XT_FUNCTION_MAXNAMELEN usage
> 
> There has been quite a confusion in userspace about
> XT_FUNCTION_MAXNAMELEN; because struct xt_entry_match used MAX-1,
> userspace would have to do an awkward MAX-2 for maximum length
> checking (due to '\0'). This patch adds a new define that matches the
> definition of XT_TABLE_MAXNAMELEN - being the size of the actual
> struct member, not one off.

Applied, thanks Jan.
