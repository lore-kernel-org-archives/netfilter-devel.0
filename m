From: "=?ISO-8859-1?Q?Mart=EDn_Ferrari?=" <martin.ferrari@gmail.com>
Subject: Re: [PATCH 5/5] Remove randomness from IP selection
Date: Mon, 28 Jan 2008 17:27:26 -0200
Message-ID: <b9800b70801281127i63f70d1ay7e78ed1df7b1fae6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:13925 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYA1T12 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:27:28 -0500
Received: by an-out-0708.google.com with SMTP id d31so393659and.103
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jan 2008 11:27:26 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have recently upgraded an old router running Debian Sarge (kernel
2.6.8), which brought kernel 2.6.18. And after that, I nice feature of
SNAT I've been using disappeared.

Searching in google, I found the mentioned patch
(http://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017=
472.html).
Very old, I know, but I'd still like to recover that functionality
(not necessarily randomness, round-robin is enough). I wonder if
there's a way of doing that without modifying the code to use the
source port as input to the hashing function, as I prefer to stick
with unmodified kernels.

Other question this raises is, what is the purpose of SAME if SNAT is
using always the same source IP.

Thanks.

Please CC me.

--=20
Mart=EDn Ferrari
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
