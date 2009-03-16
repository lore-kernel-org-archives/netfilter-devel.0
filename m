From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: print the list of register loggers.
Date: Mon, 16 Mar 2009 14:56:01 +0100
Message-ID: <49BE5A71.7020500@trash.net>
References: <499DD499.50704@inl.fr> <1235080458-6623-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZCPN4E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:56:04 -0400
In-Reply-To: <1235080458-6623-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies the proc output to add display of registered
> loggers. The content of /proc/net/netfilter/nf_log is modified. Instead
> of displaying a protocol per line with format:
> 	proto:logger
> it now displays:
> 	proto:logger (comma_separated_list_of_loggers)
> NONE is used as keyword if no logger is used.

Applied, thanks.
