From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 03/30] Replace timer code by working version
Date: Fri, 01 Feb 2008 04:42:54 +0100
Message-ID: <47A2953E.2040600@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190126.735398130@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60985 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753787AbYBADnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:43:11 -0500
In-Reply-To: <20080130190126.735398130@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Replace existing timer code by simple and more importantly working
> version.  Current resolution is one second, which may be easily
> extended if need be.

You lose precision here using time(), I think the way to go are the
timeradd(), timercmp(), timersub(), etc. functions that lives in
sys/time.h. I have a patch for those here that I want to test.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
