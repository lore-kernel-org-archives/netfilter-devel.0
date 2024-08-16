Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2CEECC;
	Fri, 16 Aug 2024 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770026; cv=none; b=lHICqadG0o7fbB6vXuJwQOfiSsfNpY2HjTQrxtKWeNWKj/7ULeU4yhh/vw0nC1iXxUfMb6SIR0whJxuqxss3xqJcdPikfMG5upsFsaVcqNrMjmpsc+1ysSklGE+oIjUS8Z0/F5ecuSIpnpOgOTYWNejA5b2jmn+8GSRtZ56pokY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770026; c=relaxed/simple;
	bh=jYu1hQ3GbO6rFkdtn1RqFe9xx1Q1L0UDXL3rPi7xvPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLDkcM5iRuKbAmtk03iD0nYXMWpp2s3gAa4WS3yzO8mfms7RfepQjV9Vk1r8pcHsEJvdWqWl0XRoxJ4KV5TRWt95I/qmgjJCZ70uWD1yll+k+zZduH2z48LnMr1coMX6LZIT78SJl8NZOFvT2EnedJPYqMdhCqCr8NeiLAnEHmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WlNts326Lz1T7PK;
	Fri, 16 Aug 2024 08:59:49 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 4500C18010A;
	Fri, 16 Aug 2024 09:00:21 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 09:00:19 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 4/4] selftests/landlock: Add realworld workload based on find tool
Date: Fri, 16 Aug 2024 08:59:43 +0800
Message-ID: <20240816005943.1832694-5-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
References: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Implement script that measures Landlock overhead for workload in which
find tool is executed on Linux source code folder. This workload is tested
with 5, 10 depth values and few number of layers.

This workload is useful to measure Landlock overhead under different
number of layers and different keys of the filesystem ruleset.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 .../landlock/bench/bench_find_on_linux.sh     | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100755 tools/testing/selftests/landlock/bench/bench_find_on_linux.sh

diff --git a/tools/testing/selftests/landlock/bench/bench_find_on_linux.sh b/tools/testing/selftests/landlock/bench/bench_find_on_linux.sh
new file mode 100755
index 000000000000..ae53c265c444
--- /dev/null
+++ b/tools/testing/selftests/landlock/bench/bench_find_on_linux.sh
@@ -0,0 +1,84 @@
+#!/usr/bin/env bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright © 2024 Huawei Tech. Co., Ltd.
+#
+# Measure openat(2) overhead for workload that executes find tool on Linux source
+# code with different depths and numbers of ruleset layers.
+
+# cf. tools/testing/selftests/kselftest.h
+KSFT_PASS=0
+KSFT_FAIL=1
+KSFT_XFAIL=2
+KSFT_XPASS=3
+KSFT_SKIP=4
+
+REL_DIR=$(dirname $(realpath $0))
+FIND=/usr/bin/find
+LINUX_SRC=$(realpath $REL_DIR/../../../../../)
+BENCH_CMD=$REL_DIR/run.sh
+TOPOLOGY=.topology
+TMP=.tmp
+
+# read
+READ_ACCESS=4
+
+# $1 - Linux src files path
+# $2 - Maximum depth of files
+# $3 - If $3 == 0 then only files of depth $2 is used in ruleset.
+#      Otherwise, ruleset uses files of depth 1-$2 and ruleset layer
+#      of each file matches depth of the file.
+# $4 - Name of the file in which topology would be saved
+gen_linux_src_topology()
+{
+	n_layers=$2
+	if [[ $3 -eq 0 ]]; then
+		n_layers=1
+		find $1 -mindepth $2 -maxdepth $2 -fprintf $4 '1 %p\n'
+	else
+		find $1 -mindepth 1 -maxdepth $2 -fprintf $4 '%d %p\n'
+	fi
+
+	# Allow access to FIND
+	for depth in $(seq 1 $n_layers);
+	do
+		echo $depth /usr/bin/find >> $4
+		echo $depth /usr/bin/file >> $4
+		echo $depth /lib >> $4
+		echo $depth /etc >> $4
+	done
+}
+
+if [ ! -f "$BENCH_CMD" ]; then
+	echo $BENCH_CMD does not exist
+	exit $KSFT_SKIP
+fi
+
+if [ ! -f "$FIND" ]; then
+	echo $FIND does not exist
+	exit $KSFT_SKIP
+fi
+
+# $1 - depth
+# $2 - If $2 == 0 then only files of depth $2 is used in ruleset.
+#      Otherwise, ruleset uses files of depth 1-$2 and ruleset layer
+#      of each file matches depth of the file.
+# $3 - Number of iterations of this sample
+run_sample()
+{
+	n_layers=$1
+	if [[ $2 -eq 0 ]]; then
+		n_layers=1
+	fi
+
+	echo Running find on $n_layers layers, $1 depth, $3 iterations...
+	gen_linux_src_topology $LINUX_SRC $1 $2 $TOPOLOGY
+
+	$BENCH_CMD -s -r $3 -b -t fs:$TOPOLOGY:$READ_ACCESS -e openat \
+		$FIND $LINUX_SRC -mindepth $1 -maxdepth $1 -exec file '{}' \;
+}
+
+run_sample 5 0 10
+run_sample 5 1 10
+run_sample 10 0 500
+run_sample 10 1 500
-- 
2.34.1

