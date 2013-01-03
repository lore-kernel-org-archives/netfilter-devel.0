From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: Re: [PATCH] iptables: allow IPv6 port NAT without address NAT
Date: Thu, 3 Jan 2013 11:17:23 +0100
Message-ID: <50E55AB3.3040100@sophos.com>
References: <20130102155244.GB5133@uweber-WS> <20130103001306.GB27394@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3.sophos.com ([216.47.234.212]:43510 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3ACKR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:17:28 -0500
In-Reply-To: <20130103001306.GB27394@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 01/03/13 01:13, Pablo Neira Ayuso wrote:
> Hi Ulrich,
>
> On Wed, Jan 02, 2013 at 04:52:44PM +0100, Ulrich Weber wrote:
>> correct parsing of IPv6 port NAT without address NAT
>> and also print brackets for port only IPv6 NAT.
> I think we can go further with some extra sanity checkings, something
> like:
>
> parse_to(...)
> [...]
>          start =3D strchr(arg, '[');
>          if (start =3D=3D NULL)
>                  xtables_error(PARAMETER_PROBLEM,
>                                "IPv6 address has to be enclosed in br=
ackets");

That will force the use of [] and might break existing scripts.
Lets try another way and relax the parsing,
by assuming one colon as port only information.

Will send another patch...

Cheers
Ulrich

--=20
Ulrich Weber | ulrich.weber@sophos.com | Senior Software Engineer
Astaro - a Sophos company | Amalienbadstr 41 | 76227 Karlsruhe | German=
y
Phone +49-721-25516-0 | Fax =96200 | www.astaro.com

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
