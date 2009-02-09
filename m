From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/6] rework of nf_log refactoring
Date: Mon, 09 Feb 2009 18:43:03 +0100
Message-ID: <49906B27.9040004@trash.net>
References: <1231312622.4137.7.camel@ice-age>	 <1231358734-20958-5-git-send-email-eric@inl.fr>	 <alpine.LSU.2.00.0901080054080.29344@fbirervta.pbzchgretzou.qr> <1231452093.10299.2.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60363 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZBIRnF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:43:05 -0500
In-Reply-To: <1231452093.10299.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le jeudi 08 janvier 2009 =E0 00:56 +0100, Jan Engelhardt a =E9crit :
>> On Wednesday 2009-01-07 21:05, Eric Leblond wrote:
>>> --- a/net/netfilter/nf_log.c
>>> +++ b/net/netfilter/nf_log.c
>>> @@ -172,13 +172,26 @@ static int seq_show(struct seq_file *s, void =
*v)
>>> {
>>> 	loff_t *pos =3D v;
>>> 	const struct nf_logger *logger;
>>> +	struct nf_logger *t;
>>> +	char loggers_string[256];
>>> +	int len =3D 256;
>=20
> Thanks Jan for your help. I've updated the patchset to follow
> your remarks. It uses seq_printf instead of a strncat for the
> proc modification and I've added the __read_mostly attribute.
>=20
> Last modification of the patchset is a fix a of a bug in sysctl
> handling.

I'm not sure whether I'm looking at the latest version. Could you
resend all logging patches I haven't applied yet please?

My tree for 2.6.30 (not merged up with the patches for 2.6.29 yet,
but I'll take care of any conflicts myself) is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
