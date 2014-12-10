From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [conntrack-tools PATCH] Fix file descriptor leak in channel_open()
 on error
Date: Wed, 10 Dec 2014 22:56:35 +0100
Message-ID: <5488C193.2030707@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:49661 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaLJV4i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:56:38 -0500
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs04.intra2net.com (Postfix) with ESMTP id 031812200FE
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 22:56:37 +0100 (CET)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id AACCE2AC55
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 22:56:36 +0100 (CET)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: smtp-auth-user)
	by intranator.m.i2n (Postfix) with ESMTPSA id 8BE292AC54
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 22:56:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Detected by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 src/channel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/channel.c b/src/channel.c
index 8b7c319..acbfa7d 100644
--- a/src/channel.c
+++ b/src/channel.c
@@ -109,6 +109,7 @@ channel_open(struct channel_conf *cfg)
 
 	if (ioctl(fd, SIOCGIFMTU, &ifr) == -1) {
 		free(c);
+		close(fd);
 		return NULL;
 	}
 	close(fd);
-- 
1.9.3

