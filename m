From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH, RFC] Modify NFLOG to be able to use it with older
 libnetfilter_log
Date: Tue, 22 Apr 2008 06:59:51 +0200
Message-ID: <480D70C7.904@trash.net>
References: <12088147772676-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYDVE75 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:59:57 -0400
In-Reply-To: <12088147772676-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> NFLOG has been modified to support GID display. There is a problem as this
> feature is only available in latest subversion of libnetfilter_log. This
> patch made this feature optional:
>  * It detects if system support the nflog_get_gid() function
>  * Compilation of nflog_get_gid() related code is conditional

Applied, thanks.
