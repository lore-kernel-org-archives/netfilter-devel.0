From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Proposed fix for getaddrinfo() issue
Date: Wed, 25 May 2011 14:16:25 +0200
Message-ID: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:51271 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1EYMQe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 08:16:34 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id 9BF9A232B1
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2011 14:16:32 +0200 (CEST)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (innominate.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3mEcrWZz1RhN for <netfilter-devel@vger.kernel.org>;
	Wed, 25 May 2011 14:16:32 +0200 (CEST)
Received: from lutz.bln.innominate.local (lutz.bln.innominate.local [10.1.0.160])
	by home.innominate.com (Postfix) with ESMTP id 7E9FC2306B
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2011 14:16:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The proposed patch provides a solution for the issue of getaddrinfo()
failing to resolv numeric port numbers if neither the socket type
or the protocol have been provided.
Observed with uClibc, other libraries may or may not have this
issue:
  http://gitorious.org/0xdroid/bionic/blobs/9ab75d4cc803e91b7f1b656ffbe2ad32c52a86f9/libc/netbsd/net/getaddrinfo.c
  -> look for "ANDROID-SPECIFIC CHANGE TO MATCH GLIBC" :-)

Comments are welcome.
  [PATCH] Provide family and protocol to make getaddrinfo happy
