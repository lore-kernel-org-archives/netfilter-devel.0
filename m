From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: Combine ipt_TTL and ip6t_HL source
Date: Wed, 18 Feb 2009 18:39:05 +0100
Message-ID: <499C47B9.8060008@trash.net>
References: <1234972949-12036-1-git-send-email-jengelh@medozas.de> <1234972949-12036-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58793 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZBRRjI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:39:08 -0500
In-Reply-To: <1234972949-12036-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Suggested by: James King <t.james.king@gmail.com>
> 
> Similarly to commit c9fd49680954714473d6cbd2546d6ff120f96840, merge
> TTL and HL. Since HL does not depend on any IPv6-specific function,
> no new module dependencies would arise.
> 
> With slight adjustments to the Kconfig help text.

Applied, thanks.
