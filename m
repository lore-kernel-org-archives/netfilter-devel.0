From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: inconsistent address treatment.
Date: Thu, 23 Dec 2010 20:52:03 +0100
Message-ID: <4D13A863.70600@plouf.fr.eu.org>
References: <4D1358C0.4060704@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:63576 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0LWTwI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:52:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 2501D39DF0A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Dec 2010 20:52:05 +0100 (CET)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2vlML36UbWqZ for <netfilter-devel@vger.kernel.org>;
	Thu, 23 Dec 2010 20:52:04 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by poutre.nerim.net (Postfix) with ESMTP id 1C7A239DEE2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Dec 2010 20:52:04 +0100 (CET)
In-Reply-To: <4D1358C0.4060704@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Stephen Clark a =E9crit :
>=20
> Why the inconsistency in the way addresses are treated. I can use -d=20
> 2.2.2.2/32
>   but not --to-source 205.201.149.214/32

Because -d takes a prefix and --to-source takes an address range.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
