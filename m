From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] Allow binding to non-local addresses if IP_TRANSPARENT
 is set
Date: Mon, 01 Oct 2007 00:12:44 +0200
Message-ID: <47001F5C.3030108@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205212.10969.61938.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48960 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXI3WQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:16:25 -0400
In-Reply-To: <20070930205212.10969.61938.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> Setting IP_TRANSPARENT is not really useful without allowing non-loca=
l
> binds for the socket. To make user-space code simpler we allow these =
binds
> even if IP_TRANSPARENT is set but IP_FREEBIND is not.
>
> Signed-off-by: T=C3=B3th L=C3=A1szl=C3=B3 Attila <panther@balabit.hu>
>  =20

Acked-by: Patrick McHardy <kaber@trash.net>
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
