From: basteon <basteon@gmail.com>
Subject: xtables crashed
Date: Sat, 14 Nov 2009 11:53:54 +1000
Message-ID: <328fe7150911131753x38a1b46dg5e16e2cf08efc357@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:50947 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZKNBxs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:53:48 -0500
Received: by iwn8 with SMTP id 8so3098565iwn.33
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2009 17:53:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello every1,
why if I tried to use this code, I've got segfault everytime?
int main(void){
printf("AFTER\n");
xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
printf("BEFORE\n");
exit(1);
}
my compilation flags...
gcc -Wall -ggdb -o table -I/usr/iptables-1.4.4/include/
-L/usr/iptables-1.4.4/lib/ -liptc -lxtables iptest.c
and trace...
AFTER
==23806== Invalid read of size 4
==23806==    at 0x80484E6: main (iptest.c:23)
==23806==  Address 0x14 is not stack'd, malloc'd or (recently) free'd
==23806==
==23806== Process terminating with default action of signal 11 (SIGSEGV)
==23806==  Access not within mapped region at address 0x14
==23806==    at 0x80484E6: main (iptest.c:23)
--23806-- REDIR: 0x40c4790 (free) redirected to 0x4022ad0 (free)
==23806==
==23806== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 19 from 1)
==23806==
==23806== 1 errors in context 1 of 1:
==23806== Invalid read of size 4
==23806==    at 0x80484E6: main (iptest.c:23)
==23806==  Address 0x14 is not stack'd, malloc'd or (recently) free'd
--23806--
--23806-- supp:     19 dl-hack3-cond-1
==23806==
==23806== IN SUMMARY: 1 errors from 1 contexts (suppressed: 19 from 1)
