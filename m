From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 patch
Date: Fri, 06 Jun 2008 01:29:34 +0200
Message-ID: <484876DE.8070807@netfilter.org>
References: <200803221533.35790.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40228 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760100AbYFEX3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:29:40 -0400
In-Reply-To: <200803221533.35790.Hugo.Mildenberger@t-online.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Hugo,

Hugo Mildenberger wrote:
> Pablo,
> 
> is the ulogd2 project maintained anymore? Or is it a 
> dead project? I have a big patch ready.

It's alive, still under development. We plan to release a new beta soon.

> *fix a number heap corruption issues in ulogd2
> 
> *provide a module invariant checking function which 
> warns e.g. about issues like possible heap corruption 
> by suspect module implementations
> 
> *provide rewritten, state driven config file parser 
> based on flex capable of detecting wrongly spelled or 
> obsoleted parameters in config sections.
> 
> *provide named stacks as an optional feature (which may 
> be used as a stem for generating output filenames, 
> while it is already used for more clear error messages)
> 
> *add SIGUSR1 (reconfigure) support for all existing 
> modules
> 
> *corrected some SIGUSR1 logfile reopen issues
> 
> *introduce gcc printf-style argument checking on 
> ulogd_log function
> 
> *include lineno and filename information in ulogd 
> messages

Such a patchset would be great to have before releasing 2.0beta2 (we're
on the way to do it).

> I waited for the patches provided by eric Leblond in 
> netfilter-devel to be included in svn, but there are 
> none until today. So, what is the correct way to send a 
> patch upstream? 

Any plan to post it to the netfilter-devel ML?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

