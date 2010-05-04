From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH] Document --state UNTRACKED
Date: Tue, 04 May 2010 11:48:54 +0200
Message-ID: <4BDFED86.5000408@plouf.fr.eu.org>
References: <201005040832.00376.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Simon Lodal <simonl@parknet.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:59126 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab0EDJs6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 May 2010 05:48:58 -0400
In-Reply-To: <201005040832.00376.simonl@parknet.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Simon Lodal a =E9crit :
>=20
> +.B UNTRACKED
> +meaning that the packet is not tracked at all, which happens if you =
use
> +the NOTRACK target in mangle table.

s/mangle/raw/

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
