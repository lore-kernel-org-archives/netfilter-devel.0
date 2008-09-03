From: Peter Hallberg <hallberg68@hotmail.com>
Subject: RE: Request: Remove duplicate file names in the kernel source
Date: Wed, 3 Sep 2008 13:24:43 +0200
Message-ID: <BLU122-W261AA0AFBCAB6F13BD5D7CDA5E0@phx.gbl>
References: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl>
 <20080902.160601.109446139.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc4-s4.blu0.hotmail.com ([65.55.111.143]:41288 "EHLO
	blu0-omc4-s4.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYICLax convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:30:53 -0400
In-Reply-To: <20080902.160601.109446139.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> We can't change these, especially the ones under include/linux,
> without breaking userspace as userspace includes these files.

At least you can change the other files.

> I find it strange that you want to study an advanced OS using such a
> primitive filesystem :-)

That kind of comment is plain stupid unless you accept a patch to remov=
e FAT, NTFS and a few more from Linux.
_________________________________________________________________
Hetaste modetipsen & h=E4rligaste sk=F6nhetstesterna!
http://salongk.msn.se/--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
