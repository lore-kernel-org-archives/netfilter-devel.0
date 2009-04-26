From: Eric Leblond <eleblond@inl.fr>
Subject: Re: Trouble with nfq_get_timestamp
Date: Sun, 26 Apr 2009 19:06:58 +0200
Message-ID: <1240765618.6955.1.camel@ice-age>
References: <17e3a8f80904260943j5ff13304paa523fe88db4344a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:36072 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZDZRsr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:48:47 -0400
In-Reply-To: <17e3a8f80904260943j5ff13304paa523fe88db4344a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Le dimanche 26 avril 2009 =E0 18:43 +0200, Kristian Evensen a =E9crit :
> Hello,
>=20
> I am currently writing a small user space application where I need th=
e
> timestamp of the packets. In the callback-function, I use
> nfq_get_timestamp and  provide it with the pointer to a timeval-struc=
t
> and the nfq_data sent to the callback function. However, the function
> always returns -1 and failes. The get_id() and so forth works
> perfectly, so I am wondering if anybody has any hints or knows how to
> solve this?

Are your packet coming from localhost ? It I remember correctly
timestamp is only setup for forwarded (or input) packets.

BR,
--=20
Eric Leblond <eleblond@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
