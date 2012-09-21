From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>
Subject: How to add wildcard netmask to ipset?
Date: Fri, 21 Sep 2012 10:35:19 +0300
Message-ID: <CAK6Qs9=Q4tpOjB6JfcSS3fbnyQdAv_Oqcz4zzqqZx5e10PvrAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-us.mail.com ([74.208.122.35]:38908 "HELO
	mailout-us.mail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756410Ab2IUHmC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:42:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

We are using ipset and we want to add wildcard netmasks to ipset. We
are using hash:net to store our ips. Ipset does not accept adding
netmasks so when adding a network like 192.168.1.0/255.255.255.0 we
convert it to 192.168.1.0/24 CIDR notation and add. But a network like
192.168.2.0/255.0.255.0 cannot be converted to CIDR nor can be added
to ipset. What can we do?

--=20
=C4=B0brahim Ercan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
