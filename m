From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] ip[6]tables: show --protocol instead of --proto in usage
Date: Wed, 20 Mar 2013 15:14:06 +0100
Message-ID: <5149C42E.4040900@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050208020601000006090209"
Cc: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050208020601000006090209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Good day!

As the man page shows --protocol not --proto, also do so in the usage 
text displayed by ip[6]tables -h.

Attached patch does the change.

Best regards

Mart

--------------050208020601000006090209
Content-Type: text/plain; charset=windows-1252;
 name="Show-protocol-instead-of-proto-in-usage-text.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Show-protocol-instead-of-proto-in-usage-text.patch"

>From b93b66aed17fb53fd3c5b4787694f1bf99a585a6 Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Wed, 20 Mar 2013 14:51:03 +0100
Subject: [PATCH] Show --protocol instead of --proto in usage text.

---
 iptables/ip6tables.c |    2 +-
 iptables/iptables.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4cfbea3..d150a7b 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -237,7 +237,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "Options:\n"
 "    --ipv4	-4		Error (line is ignored by ip6tables-restore)\n"
 "    --ipv6	-6		Nothing (line is ignored by iptables-restore)\n"
-"[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
+"[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
 "[!] --source	-s address[/mask][,...]\n"
 "				source specification\n"
 "[!] --destination -d address[/mask][,...]\n"
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 085eea1..79fa37b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -231,7 +231,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "Options:\n"
 "    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)\n"
 "    --ipv6	-6		Error (line is ignored by iptables-restore)\n"
-"[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
+"[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
 "[!] --source	-s address[/mask][...]\n"
 "				source specification\n"
 "[!] --destination -d address[/mask][...]\n"
-- 
1.7.2.5


--------------050208020601000006090209--
