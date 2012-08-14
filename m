From: Jan Krcmar <honza801@gmail.com>
Subject: Xtables-addons: man/SYSRQ sample script
Date: Tue, 14 Aug 2012 11:48:24 +0200
Message-ID: <CAKneAXmP=_xR5UQzawtiN-9pRvTnX00fRP6num6=Q7RtCKzJxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59250 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2HNJsZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:48:25 -0400
Received: by eaac11 with SMTP id c11so70330eaa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Aug 2012 02:48:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

please add the information to the man page of xtables-addons section SYSRQ

using ipv6 one must use non-shortened format, otherwise it does not work

eg.
2001:0db8:0000:0000:0000:ff00:0042:8329

not
2001:0db8::ff00:0042:8329
the xt_SYSRQ module logs "Bad digest, expected..."

as the man page says "IPv6 adress should be in the form recommended by
RFC 5952".
this rfc recommends "4.2.1.  Shorten as Much as Possible" but this
does not correct for this module

i'm using xtables-addons v1.45, archlinux, kernel 3.4.8-1

thanks
fous
