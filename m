From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE: fix --to-ports parser
Date: Fri, 14 May 2010 13:27:25 +0200
Message-ID: <4BED339D.60007@trash.net>
References: <20100219033019.GB25665@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42827 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0ENL1Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 07:27:25 -0400
In-Reply-To: <20100219033019.GB25665@wo.int.altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dmitry V. Levin wrote:
> Rewrite port range validator to use xtables_strtoui() and
> xtables_param_act().  Original check failed to recognize
> such port range errors as "1a-2" and "1-2a".
> Also, original parser erroneously denied using port 0,
> which is now allowed.

This one doesn't apply anymore, could you please rediff and resend?
Thanks!

