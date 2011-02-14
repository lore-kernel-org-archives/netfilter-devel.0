From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [connlimit] Revert 44bd4de9
Date: Mon, 14 Feb 2011 16:58:19 +0100
Message-ID: <4D59511B.8040703@trash.net>
References: <4D594A8D.5040600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55607 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1BNP6V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:58:21 -0500
In-Reply-To: <4D594A8D.5040600@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.02.2011 16:30, schrieb Stefan Berger:
> I have to revert the early loop termination in connlimit since it
> generates problems when an iptables statement does not use -m state
> --state NEW before the connlimit match extension.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Your patch didn't apply. I did a manual revert and added your
changelog, thanks.
