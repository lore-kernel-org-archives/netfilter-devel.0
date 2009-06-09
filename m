From: Patrick McHardy <kaber@trash.net>
Subject: Re: [net-next] socket: added mtinfo with 'transparent' flag
Date: Tue, 09 Jun 2009 15:18:25 +0200
Message-ID: <4A2E6121.9060408@trash.net>
References: <4A2E5AA2.8020206@trash.net> <1244553110-12145-1-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62912 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbZFINSZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:18:25 -0400
In-Reply-To: <1244553110-12145-1-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> Added new revision of the 'socket' match supporting flags.
> 
> If the XT_SOCKET_TRANSPARENT flag is set, enabled 'transparent'
> socket option is required for the socket to be matched.

Applied, thanks.

> +#ifndef _XT_SOCKET_H_match
> +#define _XT_SOCKET_H_match

and removed _match.
