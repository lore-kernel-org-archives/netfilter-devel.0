From: Max Kellermann <max@duempel.org>
Subject: [ths@networkno.de: Bug#474768: Conntrack FTBFS due to warning handled as error]
Date: Tue, 8 Apr 2008 07:04:28 +0200
Message-ID: <20080408050428.GA17133@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:40012 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYDHFEa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 01:04:30 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

we got another build failure, please review and commit the patch.

Max


----- Forwarded message from Thiemo Seufer <ths@networkno.de> -----

From: Thiemo Seufer <ths@networkno.de>
To: submit@bugs.debian.org
Subject: Bug#474768: Conntrack FTBFS due to warning handled as error
X-Virus-Scanned: Debian amavisd-new at swift.blarg.de
X-Spam-Flag: NO
X-Spam-Score: -1.9
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5 tests=[AWL=0.100, BAYES_00=-3,
	MY_DSL=1]
List-Owner: <mailto:netfilter-maintainers-owner@ned.snow-crash.org>
X-No-Auth: unauthenticated sender
Reply-To: Thiemo Seufer <ths@networkno.de>, 474768@bugs.debian.org
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Date: Mon, 07 Apr 2008 17:30:01 +0000
X-Debian-PR-Source: conntrack
Resent-Date: Mon, 07 Apr 2008 17:30:04 +0000
X-ned.snow-crash.org-MailScanner: Found to be clean, Found to be clean
X-ned.snow-crash.org-MailScanner-SpamCheck: not spam,	SpamAssassin (Wertung=-2.436, benoetigt 4.5, autolearn=not spam,	AWL 0.16, BAYES_00 -2.60, UNPARSEABLE_RELAY 0.00), not spam (whitelisted),
	SpamAssassin (Wertung=-2.44, benoetigt 4.5, autolearn=not spam,
	AWL 0.16, BAYES_00 -2.60, UNPARSEABLE_RELAY 0.00)
X-MailScanner-From: netfilter-maintainers-bounce-18-e81e0a38933e21e9c959d60f6f3f863f@ned.snow-crash.org

Package: conntrack
Version: 0.9.6-2
Severity: serious
Tags: patch

Conntrack FTBFS on armel, mips and powerpc due to:

[...]
 cc1: warnings being treated as errors
 read_config_lex.c:4451: error: 'input' defined but not used
 make[2]: *** [read_config_lex.o] Error 1
 make[2]: Leaving directory `/build/buildd/conntrack-0.9.6/src'
 make[1]: *** [all-recursive] Error 1
 make[1]: Leaving directory `/build/buildd/conntrack-0.9.6'
 make: *** [build-stamp] Error 2

I believe other architectures will also start to fail once they
(re-)build conntrack with gcc-4.3. The appended patch fixes the
problem. Tested with a build on mips.


Thiemo


--- conntrack-0.9.6.original/src/read_config_lex.l	2008-03-08 11:25:30.000000000 +0000
+++ conntrack-0.9.6/src/read_config_lex.l	2008-04-07 17:47:53.000000000 +0100
@@ -23,6 +23,7 @@
 %}
 
 %option yylineno
+%option noinput
 %option nounput
 
 ws		[ \t]+



-- 
To unsubscribe, send mail to netfilter-maintainers-unsubscribe@ned.snow-crash.org.

----- End forwarded message -----
