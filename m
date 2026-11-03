Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793689989;
	b=mD++Bzc76zQsUYtqrmCwRKU5MWWIIFbGxX7yDWi/ANA49aQpD0yqTKgmAqJrWkjpqAdS
	 RqQUk5lFAJFsyRYvFRd6/akgy3/uR0tyXEja6puHsUyUBHLyjkmBlZXRrpkpxwI3SMK/F
	 45wUYYfOV4D7mdXHleUntWqYEUHkwtUTTTLfuqU2raQEXx+urhfffth+IwyhDX1K0765p
	 g2CvYOm7eks0xGcHn4G0hBxWMNvhpt3GCPSYe9ANTQmOCmYveV0xsFYsFKsLTJml1rdk8
	 ZFKjLGemxP+EmKqsY2KWAFsph8YRkzdqLle/dBOCyd3MPKovzYzUWmPr19m1v3JQz9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793689989;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=PaFlHvWqWIMp5XO5fWoIiRVJSkm82zkkUOMdvr6ckrs=;
	b=hpqiUhs7Yy/3fyK1KDARSvrKHwbr/uvt4WmEiVQOAeSoXkwmu7GQH4M5q+DFHkP7ws+g
	 NzYAExEF3t2e3/CV9XHDhivboO9i3bJmk6b2Tavh4r1ba8STAcxZakj+5gX4jipmB3kdP
	 6XyH+FFZo2LRJVL1GhllpI38FDbXemrnSA5nX+OsjXECsrvwge0XuKc6pdQEwNleOKB8t
	 zR5wdbLsXDM4V5EB+vnsAJtvCEIqAHo2NB1FC5e/PPXMizDKCAlVmIz07IgnU3LTPIe0j
	 MemDKXrTbLlUpwCCVI3WW15um/wleSykk4F7zOSNdJHMAcSIOIABv9E+BGhoVzIQxZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=RWeGR72K;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7B2606A324
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 07:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A7B2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=RWeGR72K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793689976; bh=PaFlHvWqWIMp5XO5fWoIiRVJSkm82zkkUOMdvr6ckrs=;
	h=From:To:Cc:Subject:Date;
	b=RWeGR72KMxh9cp+ekHTBkU9xzGqMrH9USgYiH6yCAgO57reXFfUTpOzt/dw+hYWCs
	 RRNRhH+t0waYNtuAYCMiz9KKA8jL9FekG67M5/kUcd1MnWv9c8JcpqMPWg0VOCskk2
	 wJ3zN6Pp/QCMvRIEfNXf8LF23V/Jn0Y2n89wXqng=
Received: from answer ([180.213.162.109])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 3362663A; Tue, 03 Nov 2026 15:12:54 +0800
X-QQ-mid: xmsmtpt1793689974tkjl6eid9
Message-ID: <tencent_967DC9B5CD5AA2FCB62C2C3C5E8C19C14306@qq.com>
X-QQ-XMAILINFO: M1JY6XCfJolWZQk0R/XtIygfMF28DjMdrlI74t+KDb+hrdLBiFiNElFuHc6oG6
	 CnkP2eUjxHnahJ+h1zjWEmbixvxrvh5xqKGcxhKjNr65lbYaGWGtmCj1ZI52g69ZyU8VyndVICpG
	 Xvz9FK3e2TkO4/0wRc4PY5rLcsl3L1AJpQNE1PUKI2pV/F3aptSGSmRajZlnzmhHi2uQK18mS5KD
	 xpHx0UEmABiNGkpd4QgvoXmNqZGS3hGbfQbhfvp+vS4DeVhq4SYc4dVfIpvYP358t+QTnJPNJhZ4
	 sGgHVOgVHD4gW9DZ4xZljGQb64PHV/Qv+JfVa+wcZZ1Wor/xM6sL/42yxESFIgQCexQkw/qQuxO+
	 FASQ/3mBLirgmakgUGz9EUf5zUT0ZHAdFzYdNBVVcIhXX4ZGO3gMRdIYow2XDl4PPFHZydBHw42c
	 ixCrbQw4y8p/E0TK+8BJgV5uP+t/akXDm/pY4JMtFJiONHbcIVtC3/Q8d+isXNKj5MyW1inaxb+j
	 PMZCsKfp9E4LLHkLdaOf/KEXrqU85uD81DYxTPIq+ZVvG2O48nT8rkWcZNJp+X3XhgPrGk93fvh2
	 82lZppY76ZCwg83NZfJjPWo5KcslOLWKr+hsD9ggCBoTJUlPJJDlx3x1Zn0liLkUyg0MOjtSf3B7
	 0DVvx8wYsgdi2BPCL0x+V19lYQ8qSGUctQmkplFI43vbfhB4tW2/6ojjvfsIyK7EUuvHHfRUry7j
	 sa+ahQCh2eL8/xQEL3l47LV6nmMZjv3ea3hf9kavSWP9q1i6wf92uOQiqNAG9sUtlelcksf3jxxf
	 DjF/V06wQgjeZl8uBJqvu/5WdAbF4tabOVnujY/azxj1qLRKPOSG1EQ1tj0cDETxsw2UfU0wNg8Q
	 JM+aSWxeio1TSsi/Q3PDbEov3zh3EE4XKd+HOXo6PXJdDEVQPd374qIPDNs5k8qLKHtYMJFt3gs2
	 nA7hvrsUCvL3FkUqZYdbdjdaSfFaf8SWQaV549bfkOK1bbQMF9p0MbmyLHu02U
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: 1041320071@qq.com
To: netfilter-devel@vger.kernel.org
Cc: jiangjixiang <jiangjixiang@kylinos.cn>
Subject: [PATCH] ebtablesu: add O_NOFOLLOW to prevent symlink attack
Date: Tue,  3 Nov 2026 15:12:52 +0800
X-OQ-MSGID: <20261103071252.839-1-1041320071@qq.com>
X-Mailer: git-send-email 2.55.0.windows.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: jiangjixiang <jiangjixiang@kylinos.cn>

The FIFO pipe path /tmp/ebtables-vX.Y.Z/ebtablesd_pipe is in a
world-writable directory. A local unprivileged user can pre-place
a symlink at this path. When ebtablesu is invoked by root, the
open(O_WRONLY) call follows the symlink and overwrites an
arbitrary pre-existing file.

Adding O_NOFOLLOW makes open() fail with ELOOP if the last
component of the path is a symbolic link, preventing the attack.

Signed-off-by: jiangjixiang <jiangjixiang@kylinos.cn>
---
 ebtablesu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ebtablesu.c b/ebtablesu.c
index 3cee145..b1e0ec3 100644
--- a/ebtablesu.c
+++ b/ebtablesu.c
@@ -66,7 +66,7 @@ int main(int argc, char *argv[])
 		return -1;
 	}
 
-	if ((writefd = open(EBTD_PIPE, O_WRONLY, 0)) == -1) {
+	if ((writefd = open(EBTD_PIPE, O_WRONLY | O_NOFOLLOW, 0)) == -1) {
 		fprintf(stderr, "Could not open the pipe, perhaps ebtablesd is "
 		        "not running or you don't have write permission (try "
 		        "running as root).\n");
-- 
2.55.0.windows.3

