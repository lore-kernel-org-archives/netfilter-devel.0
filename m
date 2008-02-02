From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 00/15] ulogd V2 improvements, round 2
Date: Sat, 02 Feb 2008 23:52:52 +0100
Message-ID: <47A4F444.6090409@netfilter.org>
References: <20080202204826.267107164@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44545 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762650AbYBBWxS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:53:18 -0500
In-Reply-To: <20080202204826.267107164@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Because the NFCT-related changes depend on a patchlet to
> libnetfilter-conntrack which might actually not be applied, I'll
> suggest to convert the code base to libnl sooner.  Any objections?

No objections with using libnl but, as I told you in one of my previous
emails, you can remove your small patch dependency by using libnfnetlink
and libnetfilter_conntrack correctly.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
