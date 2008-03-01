From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Does Redirect/NAT change the destination port of reverse tuple
 ?
Date: Sat, 01 Mar 2008 13:22:21 +0100
Message-ID: <47C94A7D.4040408@plouf.fr.eu.org>
References: <005101c87ac0$c0d34580$4279d080$@com> <47C7F1F7.9030406@plouf.fr.eu.org> <006701c87acf$63edd8d0$2bc98a70$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-236-saturday.dmz.nerim.net ([195.5.254.236]:65474 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbYCAMY1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:24:27 -0500
Received: from kraid.nerim.net (smtp-106-saturday.nerim.net [62.4.16.106])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id 9D5AE14E09
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Mar 2008 13:24:20 +0100 (CET)
In-Reply-To: <006701c87acf$63edd8d0$2bc98a70$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah a =E9crit :
>=20
>> NAT may implicitly change the original source port in order to=20
>> avoid a clash with an existing connection.
>=20
> Hmm... So if I need original source IP and port in proxy (like
> SO_ORIGINAL_DST, something SO_ORIGINAL_SRC) I should trust conntrack =
not the
> socket info, correct ?

I guess so, unless it exists some option similar to SO_ORIGINAL_DST,=20
which is IMHO a ugly hack.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
