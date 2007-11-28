From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] LOG target - log GID
Date: Wed, 28 Nov 2007 10:13:39 +0100
Message-ID: <474D3143.8080309@trash.net>
References: <4693DD17.9020406@ae.poznan.pl> <474D30A8.3070208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Maciej So?tysiak <maciej.soltysiak@ae.poznan.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41167 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXK1JNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:13:45 -0500
In-Reply-To: <474D30A8.3070208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[CCed new list]

Maciej So?tysiak wrote:
> Hi,
>
> While I was browsing through the files in my home directory I stumbled 
> upon my patch from
> May 2003 that adds to the LOG target an option to log UID and GID.
>
> I noticed that someone already has done that in the past 4 years ;-)
> However currently LOG only logs UID. My patch used to log GID too, so
> what do you say about applying the patches attached.
>
> log_gid_kern.diff - patch ipt_LOG.c and ip6t_LOG.c
> log_gid_user.diff - patch libipt_LOG.c and libip6t_LOG.c


Just noticed these old patches. Please send me a Signed-off-by: line
and I'm going to apply them.


