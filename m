From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: Make nflog quiet when no one listen in userspace.
Date: Sun, 08 Jun 2008 20:30:44 +0200
Message-ID: <484C2554.9020301@trash.net>
References: <> <1212919510-6499-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43431 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYFHSay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:30:54 -0400
In-Reply-To: <1212919510-6499-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The message "nf_log_packet: can't log since no backend logging module loaded
> in! Please either load one, or disable logging explicitly" was displayed for
> each logged packet when no userspace application is listening to nflog events.
> The message seems to warn for a problem with a kernel module missing but as
> said before this is not the case. I thus propose to suppress the message (I
> don't see any reason to flood the log because a user application has crashed.)

Yes, that message has annoyed me on multiple occasions as well.
Applied, thanks Eric.
