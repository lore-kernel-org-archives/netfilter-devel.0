Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28407128826
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712663225; cv=none; b=qKNlMUBKOD0jh8eAUD4VRB7mwINKk/TPZ4LKvpRnnI8skt+ltCpaVZlHzEkgT8XALVyUP9z1SlODSJOHpG85jlO68oXDkuLbxeujqPXSefLVKV5rZgupdUTNbGA+kgzEgsI22ngJraaNA8/LgzSvohNyLbjddpADDlMeXHwD35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712663225; c=relaxed/simple;
	bh=PygwlUOw/QNpLBkWIpfGpjs0c4AIn/lJxmTe+w8cBDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QgZsixu7DoVPBOLlD6Qjcv7RQHlNJ0aet3QiKDM7SHKnptgE8LCeRVIY763q9e5j3MaKo4P1Q4+ypaKwjyw/bdGBvxoExc2AfJtBUr5tHuLI48mQy80mhWJ23Jv+zT4/qFJmQkrmwV9nRejT12v0Co8JskLaLlilOJjMSZBAe3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=J1CWFnyJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="J1CWFnyJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vf1v5aAFl6V0aUV5MXt8YX9KWCjTbO4LOHhRreGMBCU=; b=J1CWFnyJiS8yQ3GAzJXm7Ft7JZ
	6tbPvVsPZ7/dbIplMDt4YbmWncCIzZArMuP9/ADbMvffUvKcHkaRkDK396VSjo6Bslpmp6Rhu3Wl7
	BlxDBTpcYt6u7aYreNe9EpCWhJx2Qiggc8ctAyjd7ZejUGhKxdr09BaVa58PKRe+n2jbfPaGNgWrz
	0uXeY0vaE1Y99dB723qAtk9eJ4s0luU+3u4P8VCO+wDkQYpsxXZwGtqb5iOVOZwvrCCVyQz4wnb+e
	JaOSxOqCv2CA4nN2hX8518XT3E/RPK8Mg0mSSwFzRqrDWh4J4/M3yRz+HmqP8oU7kIDFIm+PLSfQd
	U3cr9lEA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ru9gs-000000000gP-2TG3;
	Tue, 09 Apr 2024 13:31:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: gorbanev.es@gmail.com
Subject: [iptables PATCH] xshared: Fix parsing of empty string arg in '-c' option
Date: Tue,  9 Apr 2024 13:31:01 +0200
Message-ID: <20240409113101.672-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling iptables with '-c ""' resulted in a call to strchr() with an
invalid pointer as 'optarg + 1' points to past the buffer. The most
simple fix is to drop the offset: The global optstring part specifies a
single colon after 'c', so getopt() enforces a valid pointer in optarg.
If it contains a comma at first position, packet counter value parsing
will fail so all cases are covered.

Reported-by: gorbanev.es@gmail.com
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1741
Fixes: 60a6073690a45 ("Make --set-counters (-c) accept comma separated counters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/iptables.t | 5 +++++
 iptables/xshared.c    | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/extensions/iptables.t b/extensions/iptables.t
index b4b6d677abab1..5d6d3d15cc5fd 100644
--- a/extensions/iptables.t
+++ b/extensions/iptables.t
@@ -4,3 +4,8 @@
 -i eth+ -o alongifacename+;=;OK
 ! -i eth0;=;OK
 ! -o eth+;=;OK
+-c "";;FAIL
+-c ,3;;FAIL
+-c 3,;;FAIL
+-c ,;;FAIL
+-c 2,3 -j ACCEPT;-j ACCEPT;OK
diff --git a/iptables/xshared.c b/iptables/xshared.c
index b998dd75aaf05..b1997ea35f8f8 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1885,7 +1885,7 @@ void do_parse(int argc, char *argv[],
 			set_option(p->ops, &cs->options, OPT_COUNTERS,
 				   &args->invflags, invert);
 			args->pcnt = optarg;
-			args->bcnt = strchr(args->pcnt + 1, ',');
+			args->bcnt = strchr(args->pcnt, ',');
 			if (args->bcnt)
 			    args->bcnt++;
 			if (!args->bcnt && xs_has_arg(argc, argv))
-- 
2.43.0

