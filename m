From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: icmp_error_message return?
Date: Mon, 01 Nov 2010 22:06:42 +0300
Message-ID: <48821288638402@web131.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward15.mail.yandex.net ([95.108.130.119]:55883 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0KATNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:13:09 -0400
Received: from web131.yandex.ru (web131.yandex.ru [95.108.131.155])
	by forward15.mail.yandex.net (Yandex) with ESMTP id E040B4459D82
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Nov 2010 22:06:42 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by web131.yandex.ru (Yandex) with ESMTP id DA0F01B80A6
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Nov 2010 22:06:42 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Maybe I'm wrong, but the last line of icmp_error_message() from
net/ipv4/netfilter/nf_conntrack_proto_icmp.c seems illogical to me.
Should it be return NF_ACCEPT, instead of -NF_ACCEPT?

--
wbr, Oleg
