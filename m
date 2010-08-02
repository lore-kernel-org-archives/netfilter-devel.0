From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH iptables] libxt_quota: don't ignore the quota value on
 deletion
Date: Mon, 02 Aug 2010 18:03:46 +0200
Message-ID: <4C56EC62.6030109@trash.net>
References: <1279945844-24068-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62858 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0HBQDq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:03:46 -0400
In-Reply-To: <1279945844-24068-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.07.2010 06:30, Changli Gao wrote:
> don't ignore the quota value on deletion, then we can remove a special rule
> everytime.

Applied to iptables-next, thanks.
