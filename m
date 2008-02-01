From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 22/30] Add set_sockbuf_len()
Date: Fri, 01 Feb 2008 04:50:37 +0100
Message-ID: <47A2970D.2010208@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190129.323941901@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33985 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903AbYBADun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:50:43 -0500
In-Reply-To: <20080130190129.323941901@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> +int
> +set_sockbuf_len(int fd, int rcv_len, int snd_len)

AFAIK, there's a similar function in libnfnetlink which uses
SO_RCVBUF_FORCE instead.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
