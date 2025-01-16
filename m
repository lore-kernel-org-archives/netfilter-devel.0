Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801798635B
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2025 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737044175; cv=none; b=T1SYlmo0E+DfbPqPlF39MGEdIMwePYKZbpVAxOdgPWRNF6W00iiJkxrjZ4YDkZpgFWoXjF3Nu/DKV1igPbBPnR7MPuZvDdyub07VUAUwbipPDjZGHfh9T6jBBw2Misf33qdcvgpSr/1Pb7iFU4gyOmVeYEVaCfDYKWEvfWUkUKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737044175; c=relaxed/simple;
	bh=XJK/niuQcguqUIIblmvVW8kW7J3IqpBspEToIGDjSrw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Xk8tZ0/jTUkpcvIrCXAsZrjT+rbiSPTycl+nOeryUsLwGUCCWW3h+x6QR7/eh1+8GckR/XL4PBWD60uXyFKmO4UTgXmvY8JdY2MTNNrTR4PtDajSSr+jj7jybg0XH8cb52Ux7Aox5qVzBKy9c7Z2N95loQCoCCzbWqOu27jxCj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: use mount --bind to change cgroupsv2 root
Date: Thu, 16 Jan 2025 17:16:05 +0100
Message-Id: <20250116161605.1782172-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of remount which fails with SKIP in one of my test boxes because
cgroupsv2 rootfs is busy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/packetpath/cgroupv2 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/packetpath/cgroupv2 b/tests/shell/testcases/packetpath/cgroupv2
index 20bd18ae3b4f..80a6c24c0817 100755
--- a/tests/shell/testcases/packetpath/cgroupv2
+++ b/tests/shell/testcases/packetpath/cgroupv2
@@ -126,7 +126,7 @@ if [ "$doit" != "setup-done" ];then
 	rc=$?
 else
 	want_inode=$(stat --printf=%i "/sys/fs/cgroup/nft-test1a/")
-	mount -t cgroup2 cgroup2 /sys/fs/cgroup
+	mount --bind /sys/fs/cgroup/nft-test1a/ /sys/fs/cgroup/
 
 	# /sys/fs/cgroup/  should now match "/sys/fs/cgroup/nft-test1a/cgroup.procs"
 	rootinode=$(stat --printf=%i "/sys/fs/cgroup/")
@@ -138,6 +138,8 @@ else
 
 	do_initial_setup
 	run_test
+
+	umount --bind /sys/fs/group/
 fi
 
 exit $rc
-- 
2.30.2

