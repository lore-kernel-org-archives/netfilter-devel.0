From: Mistick Levi <gmistick@gmail.com>
Subject: iptables rule matching error
Date: Mon, 16 Aug 2010 23:06:56 +0300
Message-ID: <AANLkTin-QPu+vaZaRy62J80qwVbz1XiazCvi9iYZ1tR3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52179 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0HPUG6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:06:58 -0400
Received: by vws3 with SMTP id 3so3741705vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2010 13:06:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm experiencing a problem with iptables...
I add a rule to a chain with a few matches, and afterwards when i want
to delete it, i must give it the exact order of matches i gave it
before, otherwise it says it cant find the rule.

Anyone else know this error? And if it's not an error, but there for
performance, should'nt it be fixed?
I'd like that change to be my first patch to iptables... so if you
guys think the change is appropriate i'll get on it.

Example:
iptables -A FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
-m udp --dport 555 -m physdev --physdev-out eth0
iptables -D FORWARD -s 192.168.2.2 -d 192.168.3.3 -p udp ! --fragment
-m physdev --physdev-out eth0 -m udp --dport 555

Kind Regards
Yechiel Levi
