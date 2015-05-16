From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [ulogd2 PATCH 3/4] ulogd: Use (FILE *)(-1) as dummy logfile when
 logging to syslog
Date: Sat, 16 May 2015 17:36:02 +0200
Message-ID: <20150516153344.GA3410@euler>
References: <20150516130459.GD14201@euler>
 <alpine.LSU.2.20.1505161658530.8092@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:59640 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbEPPgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 11:36:25 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1505161658530.8092@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2015-05-16 15:37, Felix Janda wrote:
> 
> >-static FILE syslog_dummy;
> >+#define SYSLOG_DUMMY ((FILE *)(-1))
> 
> ^This will likely introduce a "cast to pointer from integer of different 
> size" warning on LP64 targets.
> 
> syslog_dummy = fopen("/dev/null", "w");
> 
> would be, at the cost of one more open fd, a "nice" solution,
> since syslog_dummy is guaranteed to be unique, without making
> any assumptions about any magic value(s) being unused.

This seems seems like a cleaner approach.
Preparing a new patch...

> That, or turn the assumptive macro into
> 	#define SYSLOG_DUMMY ((FILE *)(intptr_t)-1)

Thanks,
Felix
