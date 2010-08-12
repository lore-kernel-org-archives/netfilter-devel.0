From: Nort Obor <obornort@googlemail.com>
Subject: ipset-4.2 compilation fails with recent kernel
Date: Thu, 12 Aug 2010 07:31:39 +0200
Message-ID: <AANLkTi=cY4pJpVELPg9Pfjf=HB8kaWHDUuuWrtT1DJ8Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55894 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0HLFbk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:31:40 -0400
Received: by yxg6 with SMTP id 6so276906yxg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2010 22:31:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

trying to compile ipset-4.2 / linux-2.6.35 with gcc-4.5.1, i get:

...
make[1]: Entering directory `/usr/src/linux-2.6.35'
  CC [M]  /usr/src/ipset/kernel/ip_set.o
  CC [M]  /usr/src/ipset/kernel/ipt_set.o
/usr/src/ipset/kernel/ipt_set.c:89:20: warning: 'struct
xt_match_param' declared inside parameter list
/usr/src/ipset/kernel/ipt_set.c:89:20: warning: its scope is only this
definition or declaration, which is probably not what you want
/usr/src/ipset/kernel/ipt_set.c: In function 'match':
/usr/src/ipset/kernel/ipt_set.c:95:45: error: dereferencing pointer to
incomplete type
/usr/src/ipset/kernel/ipt_set.c: At top level:
/usr/src/ipset/kernel/ipt_set.c:215:2: warning: initialization from
incompatible pointer type
/usr/src/ipset/kernel/ipt_set.c:217:2: warning: initialization from
incompatible pointer type
make[2]: *** [/usr/src/ipset/kernel/ipt_set.o] Error 1
...


tia!
