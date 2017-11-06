From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests/monitor: Print error "this requires root" and exit
Date: Mon,  6 Nov 2017 21:04:05 +0530
Message-ID: <20171106153405.6294-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:53941 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbdKFPeV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:34:21 -0500
Received: by mail-pg0-f67.google.com with SMTP id s2so8467275pge.10
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Nov 2017 07:34:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If executed without root privileges, print error "this requires root!"
and exit.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/monitor/run-tests.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 23d4e21..1adabda 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -8,6 +8,11 @@ mydiff() {
 	diff -w -I '^# ' "$@"
 }
 
+if [ "$(id -u)" != "0" ] ; then
+	echo "this requires root!"
+	exit 1
+fi
+
 testdir=$(mktemp -d)
 if [ ! -d $testdir ]; then
 	echo "Failed to create test directory" >&2
-- 
2.11.0

