From: "V. Lavrov" <lve@guap.ru>
Subject: BUG: kernel 3.10 + ipset + NET_NS
Date: Mon, 09 Sep 2013 14:05:44 +0400
Message-ID: <522D9D78.7080802@guap.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.guap.ru ([91.151.188.3]:23795 "EHLO ns1.guap.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3IIKaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:30:15 -0400
Received: from [10.0.0.64] ([10.0.0.64])
	(user=lve mech=CRAM-MD5 bits=0)
	by mail.guap.ru (8.14.7/8.14.4) with ESMTP id r89A5iWs003330
	for <netfilter-devel@vger.kernel.org>; Mon, 9 Sep 2013 14:05:44 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipset does not support NET_NS. All containers have a common ipsets.

Host:
root@ls-gw2:~# ipset -V
ipset v6.19, protocol version: 6
root@ls-gw2:~# uname -r
3.10.10
iroot@ls-gw2:~# pset -N xxx hash:ip
root@ls-gw2:~# ipset -A xxx 1.1.1.1

LXC:

root@orig:~# ipset -L xxx
Name: xxx
Type: hash:ip
Revision: 1
Header: family inet hashsize 1024 maxelem 65536
Size in memory: 8280
References: 0
Members:
1.1.1.1
root@orig:~# ipset -A xxx 2.2.2.2

Host:

root@ls-gw2:~# ipset -L
Name: xxx
Type: hash:ip
Revision: 1
Header: family inet hashsize 1024 maxelem 65536
Size in memory: 8296
References: 0
Members:
1.1.1.1
2.2.2.2

