From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] selinux: use nf_register_hooks()
Date: Mon, 21 Jul 2008 18:30:10 +0200
Message-ID: <4884B992.1040100@trash.net>
References: <20080721162503.GB13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	jmorris@namei.org, eparis@parisplace.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41936 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYGUQaM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:30:12 -0400
In-Reply-To: <20080721162503.GB13264@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  security/selinux/hooks.c |   27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)

I can pick this up or it can go through the SELinux tree.
Stephen, James?

