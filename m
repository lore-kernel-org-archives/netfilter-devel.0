From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue 4/4] Switch documentation style to doxygen.
Date: Mon, 22 Dec 2008 13:32:39 +0100
Message-ID: <494F88E7.8040105@netfilter.org>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>	 <1229722591-7836-5-git-send-email-eric@inl.fr>	 <494F6FB5.3090204@netfilter.org> <1229943343.26038.2.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57617 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753737AbYLVMuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:50:17 -0500
In-Reply-To: <1229943343.26038.2.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le lundi 22 d=C3=A9cembre 2008 =C3=A0 11:45 +0100, Pablo Neira Ayuso =
a =C3=A9crit :
>> Eric Leblond wrote:
>>> This patch modifies the documentation format to switch to doxygen
>>> format. This leads to a interesting and useful output. An example
>>> can be found at the following url:
>>> 	http://www.nufw.org/doc/libnetfilter_queue/
>> I was thinking about using kerneldoc utility, but doxygen is better =
at
>> this moment.
>=20
> Good choice, doxygen is really fine and the documentation task was qu=
iet
> painful ;)

Indeed. I was looking for something that can generate things in docbook
format which I don't know if doxygen supports.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
