From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [libnftnl PATCH] libnftnl: update Arturo Borrero Gonzalez email
Date: Mon, 10 Oct 2016 12:26:34 +0200
Message-ID: <147609519447.740.14521876477211442433.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58104 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751401AbcJJKsG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Oct 2016 06:48:06 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 0D16851F2C3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Oct 2016 10:26:30 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SbhJN0yecFfH for <netfilter-devel@vger.kernel.org>;
        Mon, 10 Oct 2016 12:26:23 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id F1A0C51F243
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Oct 2016 12:26:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update Arturo Borrero Gonzalez email address.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 examples/nft-chain-parse-add.c |    2 +-
 examples/nft-rule-parse-add.c  |    2 +-
 examples/nft-ruleset-get.c     |    2 +-
 examples/nft-set-parse-add.c   |    2 +-
 examples/nft-table-parse-add.c |    2 +-
 src/expr/masq.c                |    2 +-
 src/expr/redir.c               |    2 +-
 src/ruleset.c                  |    2 +-
 src/utils.c                    |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-add.c
index dd27343..6d6d989 100644
--- a/examples/nft-chain-parse-add.c
+++ b/examples/nft-chain-parse-add.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2014 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by
diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-add.c
index 90f1da7..e6946c8 100644
--- a/examples/nft-rule-parse-add.c
+++ b/examples/nft-rule-parse-add.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by
diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index 9e997c2..9e80bb6 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2013 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * based on previous code from:
  *
diff --git a/examples/nft-set-parse-add.c b/examples/nft-set-parse-add.c
index 550e8f4..2882f14 100644
--- a/examples/nft-set-parse-add.c
+++ b/examples/nft-set-parse-add.c
@@ -4,7 +4,7 @@
  * Based on nft-set-xml-add from:
  *
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by
diff --git a/examples/nft-table-parse-add.c b/examples/nft-table-parse-add.c
index 28cb276..cb4bcc6 100644
--- a/examples/nft-table-parse-add.c
+++ b/examples/nft-table-parse-add.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 32b5ad9..7c235d3 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2014 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
diff --git a/src/expr/redir.c b/src/expr/redir.c
index d5bc179..43538d5 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2014 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
diff --git a/src/ruleset.c b/src/ruleset.c
index 233ff0e..b6ca565 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  * (C) 2013 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/src/utils.c b/src/utils.c
index f0f5467..3e44960 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -1,6 +1,6 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published

