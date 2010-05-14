From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] REDIRECT: Fix --to-ports parser
Date: Fri, 14 May 2010 13:25:56 +0200
Message-ID: <4BED3344.1060101@trash.net>
References: <20100219013122.GA31860@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42802 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab0ENLZ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 07:25:59 -0400
In-Reply-To: <20100219013122.GA31860@wo.int.altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dmitry V. Levin wrote:
> Rewrite port range validator to use xtables_strtoui() and
> xtables_param_act().  Original check failed to recognize
> several types of port range errors, including:
> "-1", "-1a", "-1-a", "a-1", "1a-2", "1-2a", etc.
> Also, original parser erroneously denied using port 0,
> which is now allowed.

Sorry for the delay, I missed this patch. This looks good me,
applied.
