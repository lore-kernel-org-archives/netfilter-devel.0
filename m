From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask
 patch
Date: Wed, 26 Mar 2008 14:18:18 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803261414310.22661@fbirervta.pbzchgretzou.qr>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com>
 <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr> <20080326102852.GA29291@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55641 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYCZNST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:18:19 -0400
In-Reply-To: <20080326102852.GA29291@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-03-26 11:28, Micha=B3 Miros=B3aw wrote:

> On Wed, Mar 26, 2008 at 08:44:20AM +0100, Jan Engelhardt wrote:
>> +		return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
>
> BTW, isn't this way faster:
>
> 	return a & htonl(~(~(u_int32_t)0 >> l));

=46aster (and safe) is, and it was part of a previously suggested patch=
es,

static inline __be32 maskl(__be32 a, unsigned int l)
{
 	return a & prefixlen_netmask_map[l].ip;
}

where prefixlen_netmask_map is a precomputed list of mask addresses.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
