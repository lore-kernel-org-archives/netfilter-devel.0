From: Rustam <rfhamzin@gmail.com>
Subject: Query statictic  in version 1.4.9
Date: Fri, 26 Nov 2010 10:50:29 +0500
Message-ID: <1086921800.20101126105029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38443 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0KZFub convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 00:50:31 -0500
Received: by ewy5 with SMTP id 5so791808ewy.19
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Nov 2010 21:50:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, Netfilter-devel.

Please tell me the version iptables 1.4.9 is there any support options =
statictic? Or is it something else to replace?

Why can not a similar line:
IPTABLES-I FORWARD-m udp-p udp-m string - hex-string "| 7F FF FF FF AB =
|" - algo kmp \
- from 40 - to 44-m statictic - mode random - probability 0.09-j DROP

iptables v1.4.9: Couldn't load match `statictic ': / usr / libexec / xt=
ables /
libipt_statictic.so: cannot open shared object file: No such file or di=
rectory

--=20
=D1 =F3=E2=E0=E6=E5=ED=E8=E5=EC,
 Rustam                          mailto:rfhamzin@gmail.com

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
