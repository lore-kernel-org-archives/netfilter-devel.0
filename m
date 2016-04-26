From: Lion Yang <lion@aosc.io>
Subject: [Documentation] SNAT in INPUT chain
Date: Tue, 26 Apr 2016 22:17:57 +0800
Message-ID: <670551461680277@web23j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward16j.cmail.yandex.net ([5.255.227.235]:45309 "EHLO
	forward16j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbcDZO0M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 10:26:12 -0400
Received: from web23j.yandex.ru (web23j.yandex.ru [IPv6:2a02:6b8:0:1619::323])
	by forward16j.cmail.yandex.net (Yandex) with ESMTP id 070C82186B
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 17:17:57 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter after about (linux kernel) 2.4.x (or 2.6.x?) [1] can put SNAT=
 into hook NF_IP_LOCAL_IN.
However, official docs(including 'man') doesn't change, so far.

It's hard to me to write something correctly and precisely in English.
Would someone improve the docs please?

ps: Maybe add some descriptions about 'where did the de-SNAT and de-DNA=
T processes placed.' is a good idea.

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dc68cd6cc21eb329c47ff020ff7412bf58176984e
--=9A
IV.26.16
Lion Yang
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
