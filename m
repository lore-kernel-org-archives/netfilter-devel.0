From: Jyotiswarup Raiturkar <jyotisr5@googlemail.com>
Subject: CONMARK and SNAT
Date: Thu, 28 Oct 2010 17:04:23 +0530
Message-ID: <AANLkTimxtJ+A1FTtiU1ubCx8u7LBPA54A9JhT9p0esep@mail.gmail.com>
References: <AANLkTin8DL4gEKmFoVwD=h6v=QOSKKneSAmg=YqHV8bN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab0J1Led convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:34:33 -0400
Received: by wyf28 with SMTP id 28so1806282wyf.19
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2010 04:34:32 -0700 (PDT)
In-Reply-To: <AANLkTin8DL4gEKmFoVwD=h6v=QOSKKneSAmg=YqHV8bN@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I want to setup a simple generic rule=A0 :

If (connection has CONMARK =3D xx),=A0 than set TARGET as SNAT --to-sou=
rce xx

i.e. I want all packets to be SNATed to the CONMARK..

Is this possible?

-Jyotiswarup Raiturkar
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
