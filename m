From: Eric Leblond <eleblond@inl.fr>
Subject: Re: Caching packets with libipq
Date: Fri, 16 Jan 2009 08:22:47 +0100
Message-ID: <1232090567.3789.2.camel@ice-age>
References: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: David Murray <30179198@student.murdoch.edu.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:40212 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZAPHW7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:22:59 -0500
In-Reply-To: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

H,

Le vendredi 16 janvier 2009 =E0 10:41 +0900, David Murray a =E9crit :
> Hi,
>
> I am currently writing this using libipq. The reason that I am not=20
> using the newer libnetfilter is because there seems to be way more=20
> documentation and examples for libipq rather than libnetfilter. Using=
=20
> libipq I am able to print out packet details and NF_ACCEPT or NF_DROP=
,=20
> however, the problem I am having is with copying and storing packets.

What about:
	http://www.nufw.org/doc/libnetfilter_queue/

Real question: what is missing here ?

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
