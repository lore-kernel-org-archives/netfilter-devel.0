From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/13] Loosen source address check on IPv4 output
Date: Mon, 01 Oct 2007 00:12:31 +0200
Message-ID: <47001F4F.10008@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205152.10969.59108.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXI3WQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:16:12 -0400
In-Reply-To: <20070930205152.10969.59108.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> ip_route_output() contains a check to make sure that no flows with
> non-local source IP addresses are routed. This obviously makes using
> such addresses impossible.
>
> This patch introduces a flowi flag which makes omitting this check
> possible. The new flag provides a way of handling transparent and
> non-transparent connections differently.
>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Acked-by: Patrick McHardy <kaber@trash.net>

