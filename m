From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: ctnetlink: fix scheduling while atomic
Date: Wed, 21 Jan 2009 12:20:01 -0800 (PST)
Message-ID: <20090121.122001.126504033.davem@davemloft.net>
References: <4977009E.3020806@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40268
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbZAUUT7 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:19:59 -0500
In-Reply-To: <4977009E.3020806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>
Date: Wed, 21 Jan 2009 12:01:50 +0100

>     netfilter: ctnetlink: fix scheduling while atomic
>    =20
>     Caused by call to request_module() while holding nf_conntrack_loc=
k.
>    =20
>     Reported-and-tested-by: K=F6vesdi Gy=F6rgy <kgy@teledigit.hu>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
