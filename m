From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.3.1
Date: Tue, 24 Mar 2009 21:12:56 +0000
Message-ID: <200903242112.56886.steven@springl.ukfsn.org>
References: <49C8DB3B.909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:35415 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZCXVWF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:22:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id D4171212FB
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 21:12:57 +0000 (GMT)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (l2.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-X08iyDLAGL for <netfilter-devel@vger.kernel.org>;
	Tue, 24 Mar 2009 21:12:57 +0000 (GMT)
Received: from l3.home (l3.home [IPv6:2002:542d:c701:1:250:daff:fe6d:bbdd])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 34BE4212F2
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 21:12:57 +0000 (GMT)
In-Reply-To: <49C8DB3B.909@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is there a problem with mss in this release?

If I specify rule:

-A OUTPUT -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1000:1500 -j A=
CCEPT

I get error:

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Invalid mss '1000' spec=
ified.

It appears that mss values less than 65536 are rejected, while values o=
f 65536=20
or greater are accepted. Is this not the wrong way around?

Regards

Steven.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
