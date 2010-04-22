From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: rectify XT_FUNCTION_MAXNAMELEN usage
Date: Thu, 22 Apr 2010 12:48:56 +0200
Message-ID: <4BD02998.707@trash.net>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de> <1271856071-32179-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62854 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0DVKs5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:48:57 -0400
In-Reply-To: <1271856071-32179-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> There has been quite a confusion in userspace about
> XT_FUNCTION_MAXNAMELEN. Change it to match the definition of
> XT_TABLE_MAXNAMELEN - being the size of the actual struct member.

iptables userspace uses XT_FUNCTION_MAXNAMELEN - 1 for checking
the length of names. Changing the definition now will change
the behaviour of userspace code.

If you want to clean this up, I'd suggest to introduce a new
define and use that.
