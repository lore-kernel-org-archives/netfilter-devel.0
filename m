From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: log invalid new icmpv6 packet with nf_log_packet().
Date: Mon, 09 Feb 2009 18:17:32 +0100
Message-ID: <4990652C.3010708@trash.net>
References: <49821831.6000609@inl.fr> <1233262742-4891-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59804 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbZBIRRf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:17:35 -0500
In-Reply-To: <1233262742-4891-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds a logging message for invalid new icmpv6 packet.

I've queued this one for 2.6.30 since its not really a fix.
Thanks.
