From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: sysctl support of logger choice.
Date: Mon, 23 Mar 2009 13:17:28 +0100
Message-ID: <49C77DD8.3060101@trash.net>
References: <1237331756.2708.41.camel@ice-age>	 <1237332458-25202-1-git-send-email-eric@inl.fr>	 <49C2143F.8070606@trash.net> <1237499165.3955.6.camel@ghlodit.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZCWMRe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 08:17:34 -0400
In-Reply-To: <1237499165.3955.6.camel@ghlodit.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le jeudi 19 mars 2009 =E0 10:45 +0100, Patrick McHardy a =E9crit :
>> Eric Leblond wrote:
>>> This patchs adds support of modification of the used logger via sys=
ctl.
> ...
>>> By echoing "NONE" to a /proc/sys/net/netfilter/nf_log/PROTO file, t=
he
>>> logger corresponding to this PROTO is set to NULL.
>>>
> ...
>>> +	if (write) {
>>> +		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
>> What is the motivation here for not doing a full comparison?
>> Suggested change: use strcmp
>=20
> Hmmm that's correct. There is no motivation at all for insensitive
> check. I should have done this.
>=20
> The rest of the modifications are ok for me.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
