Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC53C9EFE
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 07:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867684; cv=none; b=UKUYEZXyUu66VKshUk9AJ2UvpS6TcSM9d4ozB74O/yaydYFtEQeFM0rwqGCgnPcrgnG4zoQVwTA4TfZqg/5W0w/dj6JsZcg99m/f5rY85kIWc7biAmwiJ7pToLoijWydXvYgY1b/Y6u5JjPToeXWM8AQtHpmo6QiYZ0OyotLeBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867684; c=relaxed/simple;
	bh=JK3vMBK8UHeA1TK+phgEXqqveS6CTnCtpQP/9e2HXAw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YhUhnzE2n5BfWwc6MR6ZkDyUv3OYwWhmINZint56Ji2+ERWdwJpnXuPDaH3UVhTBrvNJ07WiRFT6bcgEWVkSo7tTpe4+411gwjyFtFbPcG7Z+y4CM3P/J56SW0do4FxdBfOSEdl3egxWNf0msIx5c4I7RWDfyYf1GBVL30h20Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fd+UuQOW; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fd+UuQOW"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bdb3eb93e20so1038178766b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 00:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779867681; x=1780472481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=iJmUlyodHIY3ZSca+vhxjpKE5AMxc/UzzVLzF0J88i0=;
        b=fd+UuQOWNvbAbf5Hjn/aixJqndLx8Ssq9abJEW/4QtMjBHK8CEopbYPQfp1Doa0OID
         yl52JAdSthDvH8VUBzNZBfR1u22ZYPWyEFR5014yJCs3HVkLwSHUAqvlKklDQkFFzQeW
         B//vkX/hyWShMBDIBLfOV0XitQeEkINOsLte9nlw7VylAC/4BcNoV6jjdSl/N72GI/BV
         w+0WvMu4OV4EYZfxlpp3pL4L+3BMR069fiosZ3Cis9ow2KX5MatPb+b1aNGnuI8oV+2S
         m3zZV6lE06RH2ioiepyItc77BeiSCNfQ+vZVWm8U3D4DK30FHpkyGA6z0HCVifrTRxgx
         LYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779867681; x=1780472481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJmUlyodHIY3ZSca+vhxjpKE5AMxc/UzzVLzF0J88i0=;
        b=NTZQEFNU9Vgm0tkbST4nBULfkznWiCgwuJDYYNttLmjYL8g1dPItw5thhaRYhHGFW+
         PogBFoh1O9X4NcUMRg0Je3aDVAn5FltaLMuN7eg2He8mrXFUezI+ja9RdcKFYUPzL0od
         PSZeSPq0f4yg9pEGxd+mJGMcOpzK46duz22fzWxScSPjomjb49s2k3VJdk8n6zkELl0r
         1PBg5DfBl14jq71mzepwfkoSb0tsz9OhKLj749AQiodn3D+Kp90jcm2G4M4461EJQG9S
         rdzZhN/3KfauWPv494PF21hTjhN2+3TXfJJkLr5itZmqxy5N7b47ciuitHJ+ga4N6CIj
         GZTA==
X-Gm-Message-State: AOJu0YzO6eBJPa2sHNxY4DESUTVZkZTJq3CKtoZRgkD0eZSfilb8Hmz5
	+4gFcLlI7LEHh4ISxvoaWEKKfyPf6y5z416Wo/2ZroeuWUXMvU1BBZMiFD6pmg==
X-Gm-Gg: Acq92OH/OUJiyGKKSOXLycxVpBs+2xXFCH/WNqDmNGvBQcWFZ5LeqjHhdDVMAt1cJhK
	CopvQiLl1Fe1oChHF2YpIeBFqLgBxE3YRmRaJlMaJC97XFajRT5oTXociIyHjqShRtUHMpXuRl0
	jdCSs4RwGMDIFgsCSSLTV0yieHAMBUyf4ZblsveTpIaL2lC/SvHg0McGpJxOgFDuQ9qQ/RmrCbl
	5mDNjXBMrtSxr+di1JsCD2QrMOOfj5u+Ur3EJFaCrzaCd9/ugFkPu7pvitOU1GvjRC1ksrjRITp
	cMSNBVwVuYey1f2JCP2ktQ1wOB2Kzvgrxw0vvsgr8bAB/ZJNJsQe8WdHnT3VqpR3+NsVuQSZjJL
	aWMIRIOdtOwPlhZAWJxsSsqsRwSsSdJ6uUVcqGQy9LqY7IYFB0Wne9V7zbetVme8BbIFsBXDHtR
	fCXpVK3u7YQ1FHLvHaoQ3+F+/u2qSyQ2QCk+Nz9ssUYx2wzxM17+lV5SXmyRQvtTIG4fvDOXUsL
	xEX2vWXCXwj8PbSsniGvR/cIaK1sFu2ns9xSErhZW7v+HDrO+YQMYSikLH3wibo3JHf
X-Received: by 2002:a17:907:ea9:b0:b9d:8697:73b8 with SMTP id a640c23a62f3a-bdd23bed030mr871685766b.22.1779867680762;
        Wed, 27 May 2026 00:41:20 -0700 (PDT)
Received: from localhost (dslb-002-205-016-123.002.205.pools.vodafone-ip.de. [2.205.16.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bddc3151ff7sm583337466b.23.2026.05.27.00.41.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 00:41:20 -0700 (PDT)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] examples: rtnl: fix rtnl-link-dump* extra header
Date: Wed, 27 May 2026 09:41:17 +0200
Message-ID: <20260527074117.57746-1-jonas.gorski@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RTM_GETLINK takes an ifinfomsg, not a rtgenmsg header, so use the
correct type.

Als fix the family to AF_UNSPEC, as this is what is effectively
requested.

This just happened to work as rtgenmsg::rtgen_family aliases
ifinfomsg::ifi_family, and the kernel only checks the family for
PF_BRIDGE or not.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 examples/rtnl/rtnl-link-dump.c  | 6 +++---
 examples/rtnl/rtnl-link-dump2.c | 6 +++---
 examples/rtnl/rtnl-link-dump3.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/examples/rtnl/rtnl-link-dump.c b/examples/rtnl/rtnl-link-dump.c
index 031346fbf61a..c9ab445349a5 100644
--- a/examples/rtnl/rtnl-link-dump.c
+++ b/examples/rtnl/rtnl-link-dump.c
@@ -84,16 +84,16 @@ int main(void)
 	char buf[MNL_SOCKET_DUMP_SIZE];
 	unsigned int seq, portid;
 	struct mnl_socket *nl;
+	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
-	struct rtgenmsg *rt;
 	int ret;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
 	nlh->nlmsg_seq = seq = time(NULL);
-	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
-	rt->rtgen_family = AF_PACKET;
+	ifm = mnl_nlmsg_put_extra_header(nlh, sizeof(struct ifinfomsg));
+	ifm->ifi_family = AF_UNSPEC;
 
 	nl = mnl_socket_open(NETLINK_ROUTE);
 	if (nl == NULL) {
diff --git a/examples/rtnl/rtnl-link-dump2.c b/examples/rtnl/rtnl-link-dump2.c
index 890e51ad43d0..c33d4e010052 100644
--- a/examples/rtnl/rtnl-link-dump2.c
+++ b/examples/rtnl/rtnl-link-dump2.c
@@ -57,16 +57,16 @@ int main(void)
 	char buf[MNL_SOCKET_DUMP_SIZE];
 	unsigned int seq, portid;
 	struct mnl_socket *nl;
+	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
-	struct rtgenmsg *rt;
 	int ret;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
 	nlh->nlmsg_seq = seq = time(NULL);
-	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
-	rt->rtgen_family = AF_PACKET;
+	ifm = mnl_nlmsg_put_extra_header(nlh, sizeof(struct ifinfomsg));
+	ifm->ifi_family = AF_UNSPEC;
 
 	nl = mnl_socket_open(NETLINK_ROUTE);
 	if (nl == NULL) {
diff --git a/examples/rtnl/rtnl-link-dump3.c b/examples/rtnl/rtnl-link-dump3.c
index a381da1bd697..0dd1a1c8834d 100644
--- a/examples/rtnl/rtnl-link-dump3.c
+++ b/examples/rtnl/rtnl-link-dump3.c
@@ -57,16 +57,16 @@ int main(void)
 	char buf[MNL_SOCKET_DUMP_SIZE];
 	unsigned int seq, portid;
 	struct mnl_socket *nl;
+	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
-	struct rtgenmsg *rt;
 	int ret;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
 	nlh->nlmsg_seq = seq = time(NULL);
-	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
-	rt->rtgen_family = AF_PACKET;
+	ifm = mnl_nlmsg_put_extra_header(nlh, sizeof(struct ifinfomsg));
+	ifm->ifi_family = AF_UNSPEC;
 
 	nl = mnl_socket_open(NETLINK_ROUTE);
 	if (nl == NULL) {
-- 
2.54.0

