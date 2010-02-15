From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: dmesg analyse
Date: Mon, 15 Feb 2010 09:12:23 +0100
Message-ID: <1266221543.2939.15.camel@edumazet-laptop>
References: <533455460.20100214205439@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f216.google.com ([209.85.218.216]:39065 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0BOIM3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:12:29 -0500
Received: by bwz8 with SMTP id 8so2499147bwz.38
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 00:12:28 -0800 (PST)
In-Reply-To: <533455460.20100214205439@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 14 f=C3=A9vrier 2010 =C3=A0 20:54 +0300, Kuzin Andrey a =C3=
=A9crit :
> Hello list !
> Here is part of my dmesg log...

> [770666.464746] UDP: bad checksum. From 89.85.97.98:42656 to 212.45.5=
=2E114:63925 ulen 285
> [770701.508607] UDP: bad checksum. From 150.101.211.131:28465 to 212.=
45.5.114:8069 ulen 111
> [770839.036065] UDP: bad checksum. From 91.193.68.134:64594 to 212.45=
=2E5.114:35955 ulen 331
> [770880.708220] UDP: bad checksum. From 91.193.68.134:64594 to 212.45=
=2E5.114:35955 ulen 331
> [770929.042927] UDP: bad checksum. From 95.84.232.203:63126 to 212.45=
=2E5.114:26128 ulen 331
> [770934.980900] UDP: bad checksum. From 95.84.232.203:63126 to 212.45=
=2E5.114:26128 ulen 331
> [770953.541793] UDP: bad checksum. From 95.84.232.203:63126 to 212.45=
=2E5.114:26128 ulen 331
> [770967.215508] UDP: bad checksum. From 95.84.232.203:63126 to 212.45=
=2E5.114:26128 ulen 331
> [771099.549203] UDP: bad checksum. From 91.193.68.134:64594 to 212.45=
=2E5.114:35955 ulen 331


> Third.
> I think UDP protocol is very noisy with "bad checksum" and "short
> packet" messages. This messages really needed ?

These messages are not logged if you do :

echo 0 >/proc/sys/net/core/warnings

(or add in /etc/sysctl.conf )
net.core.warnings =3D 0



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
