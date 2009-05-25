From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Link problems with libxtables
Date: Mon, 25 May 2009 20:37:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905252036330.30491@fbirervta.pbzchgretzou.qr>
References: <c97a47b90905211727h6841648fu83004ba81e5bf3eb@mail.gmail.com> <c97a47b90905211728p68fdaf94jf0b7214c12271a57@mail.gmail.com> <alpine.LSU.2.00.0905221147010.4453@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33918 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZEYShR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2009 14:37:17 -0400
In-Reply-To: <alpine.LSU.2.00.0905221147010.4453@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


cc kaber, to apply

On Friday 2009-05-22 11:47, Jan Engelhardt wrote:
>
>>I am having problems using a member function of libxtables:
>>
>>g++ main.cpp Firewall.cpp Rule.cpp Match.cpp IP4Addr.cpp -lxtables -liptc
>>/tmp/cce5IKHM.o: In function `print_match(xt_entry_match const*,
>>ipt_ip const*, int)':
>>Firewall.cpp:(.text+0x326): undefined reference to
>>`xtables_find_match(char const*, xtables_tryload,
>>xtables_rule_match**)'
>>collect2: ld returned 1 exit status
>>make: *** [all] Error 1
>>
>>I understand this is most likely a link problem, can someone point me
>>in the right direction ?
>
>We need this
>
parent a869eab48f6cf27ffc9b7ed5b2303ff2bd3e943c (v1.4.3.2-4-ga869eab)
commit ab63b538b69379236f9cc1be9040e342eef433fb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri May 22 11:46:55 2009 +0200

xtables: use extern "C"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index a399f90..4d4ca0a 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -203,6 +203,10 @@ struct xtables_globals
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
@@ -295,4 +299,8 @@ extern void _init(void);
 
 #endif
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif /* _XTABLES_H */
-- 
# Created with git-export-patch


