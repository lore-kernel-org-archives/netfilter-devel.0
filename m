From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 12:46:44 +0200
Message-ID: <4BD02914.9030100@trash.net>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de> <1271856071-32179-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62828 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0DVKqr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:46:47 -0400
In-Reply-To: <1271856071-32179-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Netfilter traditionally used debug prints that were omitted unless
> someone explicitly defined DEBUG. Recently that has no longer been the
> case (see explanation in commit v2.6.30-rc2-184-g4ccb457). Switch our
> pr_debug calls to pr_devel.

The intention of CONFIG_DYNAMIC_DEBUG is exactly to make those debug
statements available dynamically. I presume the mentioned distribution
had a reason to enable that option. Why should we undermine that by
turning debug statements into "devel" statements?

