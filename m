From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] Fix multiple usage of DB output plugin.
Date: Mon, 21 Apr 2008 14:11:32 +0200
Message-ID: <480C8474.5060908@trash.net>
References: <12087315222557-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbYDUMLi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:11:38 -0400
In-Reply-To: <12087315222557-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> Due to the modifications done to be able to use multiple time the SOURCE
> plugin, a single instance of database output plugin could not anymore be
> used in separate stack. This patch fixes this by limiting the effect of
> the previous modification on SOURCE plugin.


This seem to fix a crash I was getting with the latest SVN version.
Applied, thanks.
