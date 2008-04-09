From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] [NETFILTER]: Rename ipt_recent to xt_recent
Date: Wed, 09 Apr 2008 14:45:04 +0200
Message-ID: <47FCBA50.9010408@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYDIMpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:45:10 -0400
In-Reply-To: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Like with other modules (such as ipt_state), ipt_recent.h is changed
> to forward definitions to (IOW include) xt_recent.h, and xt_recent.c
> is changed to use the new constant names.

Applied. One question:

> --- a/net/ipv4/netfilter/ipt_recent.c
> +++ b/net/netfilter/xt_recent.c

I like this format since it only shows the real differences
made during the move. I'm wondering how to apply it so it
also performs the rename though.
