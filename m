From: Jan Andrejkovic <jandrejk@gmail.com>
Subject: xtables - how to use kernel headers not located in /usr/include/ ?
Date: Fri, 19 Nov 2010 03:30:00 +0000
Message-ID: <AANLkTimyOo-GMg0CYnnBs4QDeneq5XGV4YO8kVNLL116@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50905 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0KSDaC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:30:02 -0500
Received: by iwn35 with SMTP id 35so4279923iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2010 19:30:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys,

I'm trying to cross-compile xtables 1.4.7 for my arm device, I get
compilation error:
/usr/include/netinet/ip.h:47: error: redefinition of =91struct iphdr=92

I think the error is related with the fact that kernel source I need
to compile with is located elsewhere and not in /usr/include

How can I influence xtables to use specified kernel headers path?

So far I tried ./configure --with-ksource=3D/mypath and setting
KERNEL_DIR=3D/mypath, but without luck.

Thank you very much,

Jan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
