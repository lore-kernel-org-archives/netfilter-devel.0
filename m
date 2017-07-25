From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] conntrack: labels: Avoid crash when labels file is not installed
Date: Mon, 24 Jul 2017 21:55:08 -0300
Message-ID: <20170725005508.30587-1-marcos.souza.org@gmail.com>
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33016 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdGYAzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 20:55:18 -0400
Received: by mail-qt0-f193.google.com with SMTP id u19so422562qtc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 17:55:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When CONNLABEL_CFG isn't available (/etc/xtables/connlabel.conf),
conntrack tool crashes:

[marcos@Icarus ~]$ conntrack -l something
nfct_labelmap_new: No such file or directory
Segmentation fault (core dumped)

I can see this problem in Fedora 26, because connlabel.conf does not
come along the conntrack/libnetfilter packages. This problem happens because
conntrack calls nfct_labelmap_new, which resides on
libnetfilter_conntrack. So this lib returns NULL because CONNLABEL_CFG
is not present, and then NULL is assigned to the global var called
labelmap on conntrack. Later, get_label is called, passing NULL to the
library, and __label_get_bit is called and deferences labelmap without
check, which leads to a crash.

With this patch on libnetlfilter_conntrack, the crash does not happen anymore,
and an error message is displayed:

[marcos@Icarus conntrack-tools]$
LD_LIBRARY_PATH=/mnt/data/gitroot/libnetfilter_conntrack/src/.libs/
conntrack -l something
nfct_labelmap_new: No such file or directory
conntrack v1.4.4 (conntrack-tools): unknown label 'something'
Try `conntrack -h' or 'conntrack --help' for more information.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
This is my first patch to netfilter and conntrack-tools, so please let
me know if I sent to the right place, or if the patch needs more work.

That "No Such file..." comes from a perror on conntrack, when
labelmap_init returns NULL.

Thanks!

 src/conntrack/labels.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
index 8048076..6d811ad 100644
--- a/src/conntrack/labels.c
+++ b/src/conntrack/labels.c
@@ -51,7 +51,11 @@ static unsigned int hash_name(const char *name)
 
 int __labelmap_get_bit(struct nfct_labelmap *m, const char *name)
 {
-	unsigned int i = hash_name(name);
+	unsigned int i;
+	if (!m)
+		return -1;
+
+	i = hash_name(name);
 	struct labelmap_bucket *list = m->map_name[i];
 
 	while (list) {
-- 
2.13.3

