From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC, PATCH] Dump conntrack ID in event messages.
Date: Sat, 10 May 2008 15:24:07 +0200
Message-ID: <4825A1F7.2040904@trash.net>
References: <> <1210361074-7548-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58491 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYEJNYo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2008 09:24:44 -0400
In-Reply-To: <1210361074-7548-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> Conntrack ID is not put (anymore ?) in event messages. This causes current ulogd2
> code to fail because it uses the ID to build a hash in userspace. This hash is
> used to be able to output the starting time of a connection.
> 
> Conntrack ID can be used in userspace application to maintain an easy match
> between kernel connections list and userspace one. It may worth to add it if
> there is no performance related issue.

Strange, I was sure we already changed this in 2.6.25.

Applied, thanks Eric.
