From: Arif Hossain <aftnix@gmail.com>
Subject: Building xt_LOGMARK from xtables-addons fails
Date: Fri, 03 Aug 2012 19:20:14 +0600
Message-ID: <1344000014.1765.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57490 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HCNbD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:31:03 -0400
Received: by ggnl2 with SMTP id l2so820640ggn.19
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Aug 2012 06:31:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to build my modules with xtables_addons. I'm not using
distribution's kernel-header package.

I've configured with "./configure --with-kbuild=<my_kernel's source>

After issuing "make", it reports:

In file included
from /usr/local/src/xtables-addons/extensions/xt_LOGMARK.c:18:
/usr/local/src/xtables-addons/extensions/compat_xtables.h:17:4: warning:
#warning You have CONFIG_NF_CONNTRACK enabled, but
CONFIG_NF_CONNTRACK_MARK is not (please enable).

 
but i've enabled CONFIG_NF_CONNTRACK_MARK :

[root@s1 linux]# grep 'NF_CONNTRACK_MARK' .config
CONFIG_NF_CONNTRACK_MARK=y

What's it i'm missing?




-- 
Cheers

aft
aftnix@gmail.com

