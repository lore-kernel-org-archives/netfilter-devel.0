From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip{,6}tables_security: fix future section mismatch
Date: Mon, 21 Jul 2008 18:31:01 +0200
Message-ID: <4884B9C5.9060904@trash.net>
References: <20080721162546.GC13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	jmorris@namei.org, eparis@parisplace.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYGUQbD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:31:03 -0400
In-Reply-To: <20080721162546.GC13264@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Currently not visible, because NET_NS is mutually exclusive with SYSFS
> which is required by SECURITY.

Applied, thanks.
