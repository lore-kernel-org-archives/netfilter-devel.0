From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: interface based conntrack entry
Date: Tue, 18 Mar 2008 01:49:37 +0100
Message-ID: <47DF11A1.5020401@plouf.fr.eu.org>
References: <CAC6870A2B8FE846AD24D7E75B05F90A3F1960@moe.nextone.local> <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local> <20080317232543.GB4003@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-231-monday.dmz.nerim.net ([195.5.254.231]:63370 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752052AbYCRE2b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:28:31 -0400
Received: from mallaury.nerim.net (smtp-101-monday.noc.nerim.net [62.4.17.101])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id 15BB3B741B
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2008 01:51:30 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by mallaury.nerim.net (Postfix) with ESMTP id D45E44FD2D
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2008 01:49:37 +0100 (CET)
In-Reply-To: <20080317232543.GB4003@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Eric Leblond a =E9crit :
>=20
> On Monday, 2008 March 17 at 16:13:45 -0400, Sohan Shetty wrote:
>>
>> Here, our box is connected to two distinct networks 192.168.1/24 [..=
=2E]
>=20
> There is no such patch. A similar question was asked some time ago an=
d
> if I remember well, the conclusion was the setup was too weird from a=
=20
> firewall point-of-view.

s/weird/broken by design/

The purpose of prefixes is to identify networks. If you use the same=20
prefix on distinct networks, expect trouble.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
