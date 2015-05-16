From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ulogd2 PATCH 3/4] ulogd: Use (FILE *)(-1) as dummy logfile when
 logging to syslog
Date: Sat, 16 May 2015 17:01:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505161658530.8092@nerf40.vanv.qr>
References: <20150516130459.GD14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:52544 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbEPPBw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 11:01:52 -0400
In-Reply-To: <20150516130459.GD14201@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2015-05-16 15:37, Felix Janda wrote:

>-static FILE syslog_dummy;
>+#define SYSLOG_DUMMY ((FILE *)(-1))

^This will likely introduce a "cast to pointer from integer of different 
size" warning on LP64 targets.

syslog_dummy = fopen("/dev/null", "w");

would be, at the cost of one more open fd, a "nice" solution,
since syslog_dummy is guaranteed to be unique, without making
any assumptions about any magic value(s) being unused.

That, or turn the assumptive macro into
	#define SYSLOG_DUMMY ((FILE *)(intptr_t)-1)
