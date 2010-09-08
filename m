From: Stig Thormodsrud <stig@vyatta.com>
Subject: change to max length of jump target
Date: Wed, 08 Sep 2010 11:23:56 -0700
Message-ID: <4C87D4BC.8090802@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:50336 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0IHSXh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:23:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.vyatta.com (Postfix) with ESMTP id AB995182893F
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2010 11:18:00 -0700 (PDT)
Received: from mail.vyatta.com ([127.0.0.1])
	by localhost (mail.vyatta.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wbvWpstArz2p for <netfilter-devel@vger.kernel.org>;
	Wed,  8 Sep 2010 11:18:00 -0700 (PDT)
Received: from [10.3.0.115] (eng-115.vyatta.com [10.3.0.115])
	by mail.vyatta.com (Postfix) with ESMTPSA id E8FC418280D3
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2010 11:17:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I'm in the process of upgrading to iptables 1.4.9 and noticed that the
max jump target has changed from 30 characters to 28 characters.  For
example I can still create a 29 character chain but can't create a jump
target to it:

root@r1:~# iptables -t filter --new-chain A2345678901234567890123456789

root@r1:~# iptables -L A2345678901234567890123456789
Chain A2345678901234567890123456789 (0 references)
target     prot opt source               destination

root@r1:~# iptables -t filter --insert VYATTA_IN_HOOK 1 --in-interface
eth3 --jump A2345678901234567890123456789
iptables v1.4.9: Invalid target name `A2345678901234567890123456789' (28
chars max)
Try `iptables -h' or 'iptables --help' for more information.


This worked in 1.4.4.   In the code I see these changes:


git show 491c1660 include/linux/netfilter/x_tables.h
commit 491c1660fced08e2d1a08c101c63af04250275d0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jun 7 10:59:03 2010 +0200

    includes: sync header files from Linux 2.6.35-rc1

    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

diff --git a/include/linux/netfilter/x_tables.h
b/include/linux/netfilter/x_tabl
index ccb5641..fa2d957 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,9 +1,10 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
-
+#include <linux/kernel.h>
 #include <linux/types.h>

 #define XT_FUNCTION_MAXNAMELEN 30
+#define XT_EXTENSION_MAXNAMELEN 29
 #define XT_TABLE_MAXNAMELEN 32




and:


git show 0cb675b8 iptables.c
commit 0cb675b8f18c4b074d4c69461638820708e98100
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jun 7 11:50:25 2010 +0200

    xtables: another try at chain name length checking

    Since XT_EXTENSION_MAXNAMELEN is now available, make use of it
    and clear the confusion.

    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

diff --git a/iptables.c b/iptables.c
index 19c2af5..efe993e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -460,10 +460,10 @@ parse_target(const char *targetname)
                xtables_error(PARAMETER_PROBLEM,
                           "Invalid target name (too short)");

-       if (strlen(targetname) > XT_FUNCTION_MAXNAMELEN - 1)
+       if (strlen(targetname) >= XT_EXTENSION_MAXNAMELEN)
                xtables_error(PARAMETER_PROBLEM,
                           "Invalid target name `%s' (%u chars max)",
                           targetname, XT_EXTENSION_MAXNAMELEN - 1);



Is the change from > to >= a mistake or is max length change intentional?

thanks,

stig
