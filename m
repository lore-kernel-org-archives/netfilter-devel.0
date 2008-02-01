From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 07/30] Renice to -1 on startup
Date: Fri, 01 Feb 2008 04:47:38 +0100
Message-ID: <47A2965A.6090504@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.273612103@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40877 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754024AbYBADro (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:47:44 -0500
In-Reply-To: <20080130190127.273612103@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Thus possibly preventing e.g. ctnetlink from overruns on busy sites.

Also interesting, do you really observe a real improvement? I'll try
this with conntrackd tomorrow in my testbed.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
