From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: arbitrary address mask matching
Date: Mon, 10 Aug 2009 10:48:58 +0200
Message-ID: <4A7FDEFA.3020009@plouf.fr.eu.org>
References: <4A7F5CF1.8030708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58479 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbZHJItA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:49:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 12E2939DE95
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 10:48:58 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XbfGaJdO6RZw for <netfilter-devel@vger.kernel.org>;
	Mon, 10 Aug 2009 10:48:57 +0200 (CEST)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by poutre.nerim.net (Postfix) with ESMTP id 0C8DD39DE94
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 10:48:56 +0200 (CEST)
In-Reply-To: <4A7F5CF1.8030708@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Christoph A. a =E9crit :
>=20
> iptables -A OUTPUT -d 10.10.97.1/255.255.255.253 -m iprange --dst-ran=
ge
> 10.10.97.1-10.10.97.7 -j REJECT
>=20
> this should match on 10.10.97.1,3,5,7 but matches only 1 and 3

253 is binary 11111101, so this is the expected behaviour.
BTW, what is the use of iprange in this rule ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
