From: "Jose Antonio Olivera Ortega" <josea.olivera@gmail.com>
Subject: ip_route_me_harder at NF_IP_PREROUTING stage
Date: Thu, 8 Jan 2009 16:45:39 +0100
Message-ID: <1cf0e6b70901080745v2a2506adj2716ac3150b02156@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:53177 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZAHPpl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:45:41 -0500
Received: by bwz10 with SMTP id 10so6699657bwz.13
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Jan 2009 07:45:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

is it neccesary to execture ip_route_me_harder after handling  packets
(alter addresses) at NF_IP_PRE_ROUTING stage?

I look fordward to hearing from you soon.

Respectfully,

Jos=E9 Antonio Olivera.

--=20
Jose Antonio Olivera Ortega
Mobile Phone: +34667447797
EMail Address: JoseA.Olivera@gmail.com
Skype user: JoseA.Olivera
--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
