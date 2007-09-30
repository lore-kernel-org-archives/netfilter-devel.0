From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] Implement IP_TRANSPARENT socket option
Date: Mon, 01 Oct 2007 00:12:37 +0200
Message-ID: <47001F55.3080801@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205202.10969.93467.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXI3WQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:16:17 -0400
In-Reply-To: <20070930205202.10969.93467.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> This patch introduces the IP_TRANSPARENT socket option: enabling that will make
> the IPv4 routing omit the non-local source address check on output. Setting
> IP_TRANSPARENT requires NET_ADMIN capability.
>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Acked-by: Patrick McHardy <kaber@trash.net>
