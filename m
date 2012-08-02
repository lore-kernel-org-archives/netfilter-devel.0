From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Subject: Re: skb_warn_bad_offload with kernel 3.5 (maybe gso/bridge related
 ?)
Date: Thu, 02 Aug 2012 17:08:07 +0200
Message-ID: <501A97D7.1090206@univ-nantes.fr>
References: <50194875.5030009@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtptls1-loi.cpub.univ-nantes.fr ([193.52.103.112]:53879 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810Ab2HBPIN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:08:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 262FC43A040
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Aug 2012 17:08:12 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-loi.cpub.univ-nantes.fr [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id tyYZjYcNDtwH for <netfilter-devel@vger.kernel.org>;
	Thu,  2 Aug 2012 17:08:07 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:1d8c:883b:e0c:970b] (unknown [IPv6:2001:660:7220:0:1d8c:883b:e0c:970b])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id C57EC403818
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Aug 2012 17:08:07 +0200 (CEST)
In-Reply-To: <50194875.5030009@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 01/08/2012 17:17, Yann Dupont a =E9crit :
> Hello everybody,
>
Just a quick follow up :

[..]
> As the problem seems more or less gso related, I've deactivated gso=20
> for the moment. I'll see in the night if we still have errors reporte=
d.

Indeed, deactivating gso on the network interfaces cure the symptom,=20
running ok since yesterday.
Cheers,

--=20
Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
