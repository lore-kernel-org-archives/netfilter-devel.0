From: Patrick McHardy <kaber@trash.net>
Subject: Re: Is the libnetfilter_queue thread-safe?
Date: Mon, 26 Jan 2009 14:21:57 +0100
Message-ID: <497DB8F5.80600@trash.net>
References: <web-4707182@mail.primecreation.com> <1232696125.22893.5.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jacky Luk <jacky.luk@primecreation.com>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43686 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZAZNWB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:22:01 -0500
In-Reply-To: <1232696125.22893.5.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le vendredi 23 janvier 2009 =E0 12:02 +0800, Jacky Luk a =E9crit :
>> Hi,
>>
>> I would like to ask a question about the=20
>> libnetfilter_queue. Is the libnetfilter_queue thread-safe?=20
>=20
> Is had yet to be decide :/ From my experience on NuFW, you can use it
> with multithreaded programs and you can have a reading thread and a
> writing thread working together on the same queue.

I think it should be as long as you don't change anything related
to the handle while using it. The remaining parts are merely a
stateless communication mechanism, there's no reason why they
shouldn't be thread-safe.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
