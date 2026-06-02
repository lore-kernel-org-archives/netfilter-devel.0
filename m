Received: from send100.i.mail.ru (send100.i.mail.ru [89.221.237.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289FC2EBDFA
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.221.237.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780404638; cv=none; b=STNclM2zp4LUhFYjCw1FI54L2W0NfVLPNGiE01IxNSQHnkXjBtnJTGXaRpBstZvSEGB9kXyR/fGQSN5MEjpJDuNeOpRhs4h3xZPDad7jiTz0dYRYRPE02SL+lq6e/bCnp5YeR52ElRAT8xMyniEkXyy3jWOlZeLBCeUQj9LTS4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780404638; c=relaxed/simple;
	bh=UseZUKwHIopBlchBx6I7LsJIwuXsPWbeGhnmx7FmVjE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sMRLH3UohGsMchP6DxZ2vYXCuAfLLjPX3hF4jQJoUPc2zm8veeS6rBEkRy1y7EEf01eedNlpfZGwskE9ySGj5TdtMgNZSs6rsnZQHH2W7SU+dy1LxDjUxENzYPv41NCcy3F549LIMgGQ9cKEufF8oqFiHKd1/+BZ2V7tBW4nGFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.ru; spf=pass smtp.mailfrom=mail.ru; dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b=Q5bk+OFo; dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b=KsKpgnC+; arc=none smtp.client-ip=89.221.237.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b="Q5bk+OFo";
	dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b="KsKpgnC+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru;
	s=mail4; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:X-Cloud-Ids;
	bh=BJ+MFKQjheod5LPo/XlFfd/v4koMOadt0v+31GfSHE8=; t=1780404635; x=1780494635; 
	b=Q5bk+OFo2qGtwZiR1X2ofZ98xv8C3kEmdTTT/5wOD/gJRSplGz5K7AsfB4xXDnNhG1mfyHPKcjI
	Bx++9iTeRYzVmy3FTpRi+aR0lgP7jluz59gPUw9AaJ777ZvW1CDcFGqocpwJvUnStW+sdyx4OHOpU
	GLF5l2DynMjj7LluwSrCRLOuie9eE8tgHKygInfqlYnkWOK16raeAlhdU0perQtCb8DkKkotJEzdk
	g0mxuDs4KYgwJccBCQhLaCoaRI3ZJEG8jV2D346E8jUC99immR0UbXOX73pQ+bZJHnXI7OyRB2roj
	056nEiOslKliHEOEZkcY0b5yocLpgwW2xbgQ==;
Received: from [10.113.64.254] (port=51640 helo=send242.i.mail.ru)
	by exim-fallback-554f498d9f-8k9t7 with esmtp (envelope-from <ozhigov_dv@mail.ru>)
	id 1wUOL6-00000000Wku-1ciK
	for netfilter-devel@vger.kernel.org; Tue, 02 Jun 2026 15:35:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru;
	s=mail4; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc:
	To:From:From:Sender:Reply-To:To:Cc:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
	X-Cloud-Ids:Disposition-Notification-To;
	bh=BJ+MFKQjheod5LPo/XlFfd/v4koMOadt0v+31GfSHE8=; t=1780403724; x=1780493724; 
	b=KsKpgnC+I+Sjbj8W8Y82uc8BWMD6y8TZIJHQPMTgOWlWOeO5uVpUgRSgAWeiMNCW1YdGWmXW73L
	QDWSPs78u9pJTYKfyQcnpEo8GTJ1Td/JBwc8stmgEq5b3uGo5fAceTewC1IaP059+RPm/S9RJBVVo
	AqcNq+QGgj1frSEUq0IoAPeTVPjj+IFXqktabsvgP48IJ4eThZ+1JWKdIskL2QIKMIKVYBfrqtG3k
	MspAgjgIIjv/wcFtwKm1/s7aMdSCO24XoFwtmS5lnR5WoVCmh3PWgTe8lWsknOg5hCPAlPDAorngH
	AqQHRGReWRAACfusa0L9JlO15FtEQrlSLiUA==;
Received: by exim-smtp-5b85998476-lxxsz with esmtpa (envelope-from <ozhigov_dv@mail.ru>)
	id 1wUOKo-00000000Qh5-2zYq; Tue, 02 Jun 2026 15:35:07 +0300
From: Denis Ozhigov <ozhigov_dv@mail.ru>
To: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Cc: Denis Ozhigov <ozhigov_dv@mail.ru>
Subject: [PATCH conntrack-tools] conntrackd: remove redundant retry checks
Date: Tue,  2 Jun 2026 19:34:59 +0700
Message-ID: <20260602123459.61617-1-ozhigov_dv@mail.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9402BF17F4A9A44D6AD82277AB1EF80057AC569570370E8A800894C459B0CD1B920B788D1CED637224BD03525DDD6C896AA6F03788B3C51AFB95CD50ECDD0D7DB2A808E2AF9A6ECDE
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7F6EE1C40B2E8BE15EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637AC83A81C8FD4AD23D82A6BABE6F325AC2E85FA5F3EDFCBAA7353EFBB55337566EB41390B1F37380D30485BCFED458C970017AE89AFF118C9D75B65FD641D4EFF8EEF46B7454FC60B9742502CCDD46D0D5FF72824B19451C6F6B57BC7E64490618DEB871D839B73339E8FC8737B5C224911E5B64A728E1589CC7F00164DA146DAFE8445B8C89999729449624AB7ADAF37F6B57BC7E64490611E7FA7ABCAF51C92176DF2183F8FC7C0731955DFF79023228941B15DA834481F9449624AB7ADAF37BA3038C0950A5D3613377AFFFEAFD2691661749BA6B97735743E0D640D0E8E397B076A6E789B0E97A8DF7F3B2552694AD5FFEEA1DED7F25D49FD398EE364050F599709FD55CB46A61133410A2FE6C23AB3661434B16C20ACC84D3B47A649675FE827F84554CEF5019E625A9149C048EE9ECD01F8117BC8BEE2021AF6380DFAD18AA50765F790063735872C767BF85DA227C277FBC8AE2E8BBE5942AC52E9A9BD75ECD9A6C639B01B4E70A05D1297E1BBCB5012B2E24CD356
X-C1DE0DAB: 0D63561A33F958A59DF3BE03A6F6DC975002B1117B3ED6961FDDB3E93CB97F0D47A99E6294EE8661823CB91A9FED034534781492E4B8EEADD3CF082B023A3D3CC79554A2A72441328621D336A7BC284946AD531847A6065AED8438A78DFE0A9EBDAD6C7F3747799A
X-C8649E89: 1C3962B70DF3F0AD73CAD6646DEDE191716CD42B3DD1D34C77DD89D51EBB774225B6776AC983F447FC0B9F89525902EE6F57B2FD27647F25E66C117BDB76D659EE089C4B5E877D8661095E8F847DE26ED047D8033DF4C186DB21763F660F927F1955FBD40F1DB2E3B8341EE9D5BE9A0AB5947BB2A277409F1CA0C3A9EC42509B69CA24BBC8DA7CAA6536EB022892E5344C41F94D744909CE3C99B9F197B4D9655B9940FC5A3F7BF7C3981EEBE9DB10F943082AE146A756F3
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu53w8ahmwBjZKM/YPHZyZHvz5uv+WouB9+ObcCpyrx6l7KImUglyhkEat/+ysWwi0gdhEs0JGjl6ggRWTy1haxBpVdbIX1nthFXMZebaIdHP2ghjoIc/363UZI6Kf1ptIMVYrk7BQKFwEtr9RRRbJDCQQZIEzKl1WhXA==
X-Mailru-Sender: 08BBF1EE6535AE3A16ECE199505852BBA30056C2BB409E0405970805E13D7B1E0348EA36DFA05A9CCA5B4E1B029398FB5F00F779B0BF40445A39863662308CDAC489A80E22418143148FC85903CABB4E3CE4D15F63901AC85669E6D8CC9CC193B4A721A3011E896F
X-Mras: Ok
X-Mailru-Src: fallback
X-7564579A: 78E4E2B564C1792B
X-77F55803: 6242723A09DB00B487EF4F2ACC83E26BB702F02B268DA649098182A82DE37EB3049FFFDB7839CE9E1ABCD4B305FA151C1FCB7838C88208AFB4A30E4DE127DAE0E0E8E43350B6733AC8B9C115BA55AFC1
X-7FA49CB5: 0D63561A33F958A5F419CC462B1AA1055002B1117B3ED696339BBD8059BFC16EDF65068396D3048702ED4CEA229C1FA827C277FBC8AE2E8B80A48A619DF0B2C7
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu53w8ahmwBjZKM/YPHZyZHvz5uv+WouB9+OYcBso8Zm+oliTz8oZwnDrFsY77LZRcHyw5ht0smWrfSeTW5FiI8avd9v29gUBslpEZ9wIMwqVP4jLQVQ+dVm7x9BpDHadBV9RMjI809PraZM5NQ6W8lbv1JL5Mz79Jz0g==
X-Mailru-MI: 20000000020000000000000800
X-Mras: Ok

The condition is already checked in the outer if-block, making the inner
'if' statement unnecessary.

Signed-off-by: Denis Ozhigov <ozhigov_dv@mail.ru>
---
 src/cache-ct.c        |  6 ++----
 src/cache-exp.c       |  6 ++----
 src/external_inject.c | 12 ++++--------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/src/cache-ct.c b/src/cache-ct.c
index f56e450..f38642c 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -199,10 +199,8 @@ retry:
 		if (errno == EEXIST && retry == 1) {
 			ret = nl_destroy_conntrack(tmp->h, ct);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
-				if (retry) {
-					retry = 0;
-					goto retry;
-				}
+				retry = 0;
+				goto retry;
 			}
 			dlog(LOG_ERR, "commit-destroy: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
diff --git a/src/cache-exp.c b/src/cache-exp.c
index 63e3440..972ecab 100644
--- a/src/cache-exp.c
+++ b/src/cache-exp.c
@@ -195,10 +195,8 @@ retry:
 		if (errno == EEXIST && retry == 1) {
 			ret = nl_destroy_expect(tmp->h, exp);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
-				if (retry) {
-					retry = 0;
-					goto retry;
-				}
+				retry = 0;
+				goto retry;
 			}
 			dlog(LOG_ERR, "commit-destroy: %s", strerror(errno));
 			dlog_exp(STATE(log), exp, NFCT_O_PLAIN);
diff --git a/src/external_inject.c b/src/external_inject.c
index 920d7c4..ad661dc 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -70,10 +70,8 @@ retry:
 		if (errno == EEXIST && retry == 1) {
 			ret = nl_destroy_conntrack(inject, ct);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
-				if (retry) {
-					retry = 0;
-					goto retry;
-				}
+				retry = 0;
+				goto retry;
 			}
 			external_inject_stat.add_fail++;
 			dlog(LOG_WARNING,
@@ -200,10 +198,8 @@ retry:
 		if (errno == EEXIST && retry == 1) {
 			ret = nl_destroy_expect(inject, exp);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
-				if (retry) {
-					retry = 0;
-					goto retry;
-				}
+				retry = 0;
+				goto retry;
 			}
 			exp_external_inject_stat.add_fail++;
 			dlog(LOG_WARNING,
-- 
2.43.0

