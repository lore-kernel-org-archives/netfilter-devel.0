From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nefilter: nfnetlink: add nfnetlink_set_err and use it
 in	ctnetlink
Date: Mon, 16 Mar 2009 15:13:03 +0100
Message-ID: <49BE5E6F.2020708@trash.net>
References: <20090305163208.14553.517.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46004 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZCPONJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:13:09 -0400
In-Reply-To: <20090305163208.14553.517.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds nfnetlink_set_err() to propagate the error to netlink
> broadcast listener in case of memory allocation errors in the
> message building.

> +void nfnetlink_set_err(u32 group, int error)
> +{
> +	netlink_set_err(nfnl, 0, group, error);
> +}
> +EXPORT_SYMBOL_GPL(nfnetlink_set_err);

Please make the pid argument controllable by the caller as well. This
is necessary to avoid double error notifications when an error occurs
in response to a user-request triggering notifications.
