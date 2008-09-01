From: Patrick McHardy <kaber@trash.net>
Subject: Re: Update comments
Date: Mon, 01 Sep 2008 14:22:52 +0200
Message-ID: <48BBDE9C.10608@trash.net>
References: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808151857110.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33592 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYIAMWy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:22:54 -0400
In-Reply-To: <alpine.LNX.1.10.0808151857110.26696@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 6ca22c9d159540a558acb21bf80fe4960b656b59
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Aug 15 18:41:08 2008 -0400
> 
> Update comments
> 
> A number of comments are redundant, some outdated and others outright
> wrong in their own way. Remove and fixup.

Applied, thanks. I got two rejects though, so these parts are
missing:

Hunk #1 FAILED at 5.
1 out of 7 hunks FAILED -- saving rejects to file 
extensions/libxt_hashlimit.c.rej

Hunk #1 FAILED at 1.
1 out of 6 hunks FAILED -- saving rejects to file 
extensions/libxt_limit.c.rej
