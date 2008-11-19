From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] iptables: fix error reporting with wrong/missing
 arguments
Date: Wed, 19 Nov 2008 11:05:04 +0100
Message-ID: <4923E4D0.6020003@netfilter.org>
References: <20081118234311.15750.80335.stgit@Decadence> <alpine.LNX.1.10.0811191027340.30388@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48076 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752679AbYKSKJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:09:54 -0500
In-Reply-To: <alpine.LNX.1.10.0811191027340.30388@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-11-19 00:43, Pablo Neira Ayuso wrote:
>> @@ -1888,9 +1888,26 @@ int do_command6(int argc, char *argv[], char =
**table, ip6tc_handle_t *handle)
>> 					continue;
>> 				}
>>
>> -				if (!m)
>> +				if (!m) {
>> +					if (c =3D=3D '?') {
>> +						if (optopt) {
>> +							exit_error(
>> +							   PARAMETER_PROBLEM,
>> +							   "option `%s' "
>> +							   "requires an "
>> +							   "argument",
>> +							   argv[optind-1]);
>> +						} else {
>> +							exit_error(
>> +							   PARAMETER_PROBLEM,
>> +							   "unknown option "
>> +							   "`%s'",
>> +							   argv[optind-1]);
>> +						}
>> +					}
>> 					exit_error(PARAMETER_PROBLEM,
>> 						   "Unknown arg `%s'", optarg);
>> +				}
>=20
> I think it is time to give attention to CodingStyle section 1:
>=20
> 	=E2=80=9CThe answer to that is that if you need more than 3 levels o=
f
> 	indentation, you're screwed anyway, and should fix your
> 	program.=E2=80=9D
>=20
> Maybe this could be put into a separate function somehow than trying
> to squeeze everything between colums 64 and 80?

Putting this code into a function will not make any better for the whol=
e
section of code under the "default" tag in the switch - which is indeed
already horrible as it looks like a real Spanish chorizo [1].

Of course, you are free to send a patch to cleanup not only this part,
but the whole default section of the switch. I'd be please to apply it.

[1] http://en.wikipedia.org/wiki/Chorizo

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
