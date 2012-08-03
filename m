From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Building xt_LOGMARK from xtables-addons fails
Date: Fri, 3 Aug 2012 16:46:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208031644080.3676@frira.zrqbmnf.qr>
References: <1344000014.1765.4.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:33998 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2HCOq0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:46:26 -0400
In-Reply-To: <1344000014.1765.4.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-08-03 15:20, Arif Hossain wrote:

>I've configured with "./configure --with-kbuild=<my_kernel's source>
>In file included
>from /usr/local/src/xtables-addons/extensions/xt_LOGMARK.c:18:
>/usr/local/src/xtables-addons/extensions/compat_xtables.h:17:4: warning:
>#warning You have CONFIG_NF_CONNTRACK enabled, but
>CONFIG_NF_CONNTRACK_MARK is not (please enable).
>
>[root@s1 linux]# grep 'NF_CONNTRACK_MARK' .config
>CONFIG_NF_CONNTRACK_MARK=y

Only thing I can think of is that you are looking at the wrong .config
and/or that you changed your .config without building a kernel with it.
