From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] iptables: fix error reporting with wrong/missing
 arguments
Date: Wed, 19 Nov 2008 10:28:53 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811191027340.30388@fbirervta.pbzchgretzou.qr>
References: <20081118234311.15750.80335.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46612 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYKSJ24 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:28:56 -0500
In-Reply-To: <20081118234311.15750.80335.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-19 00:43, Pablo Neira Ayuso wrote:
>@@ -1888,9 +1888,26 @@ int do_command6(int argc, char *argv[], char **=
table, ip6tc_handle_t *handle)
> 					continue;
> 				}
>=20
>-				if (!m)
>+				if (!m) {
>+					if (c =3D=3D '?') {
>+						if (optopt) {
>+							exit_error(
>+							   PARAMETER_PROBLEM,
>+							   "option `%s' "
>+							   "requires an "
>+							   "argument",
>+							   argv[optind-1]);
>+						} else {
>+							exit_error(
>+							   PARAMETER_PROBLEM,
>+							   "unknown option "
>+							   "`%s'",
>+							   argv[optind-1]);
>+						}
>+					}
> 					exit_error(PARAMETER_PROBLEM,
> 						   "Unknown arg `%s'", optarg);
>+				}

I think it is time to give attention to CodingStyle section 1:

	=E2=80=9CThe answer to that is that if you need more than 3 levels of
	indentation, you're screwed anyway, and should fix your
	program.=E2=80=9D

Maybe this could be put into a separate function somehow than trying
to squeeze everything between colums 64 and 80?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
