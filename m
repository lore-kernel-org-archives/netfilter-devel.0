From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 6/8] netfilter: IPv6: initialize TOS field in REJECT
 target module
Date: Thu, 12 May 2011 17:33:05 +0900
Message-ID: <1305189185.10374.28.camel@nexus.oss.ntt.co.jp>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
	 <1305021959-2980-7-git-send-email-pablo@netfilter.org>
	 <1305090777.5570.7.camel@nexus.oss.ntt.co.jp>
	 <4DCB98E7.4010804@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Shinya SATO <sato.shinya@oss.ntt.co.jp>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50418 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1ELIdH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 04:33:07 -0400
In-Reply-To: <4DCB98E7.4010804@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2011-05-12 at 10:23 +0200, Pablo Neira Ayuso wrote:
> On 11/05/11 07:12, Fernando Luis V=C3=A1zquez Cao wrote:
> > Thank you for taking care of these patches, I really appreciate it.
> >
> > I noticed that they have just been picked up by Linus. Could we get=
 them
> > into the -stable and -longterm trees too?
> >
> > 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5 (netfilter: IPv6: fix DSCP=
 mangle code)
> > 4319cc0cf5bb894b7368008cdf6dd20eb8868018 (netfilter: IPv6: initiali=
ze TOS field in REJECT target module)
>=20
> OK, I'll pass them to -stable as soon as I find some spare time.

Thank you Pablo. By doing so they are more likely to trickle down to
enterprise distributions and Debian, which we are using.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
