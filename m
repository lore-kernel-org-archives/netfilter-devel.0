From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 07/15] Renice to -1 on startup
Date: Sat, 02 Feb 2008 22:47:19 +0100
Message-ID: <47A4E4E7.1090105@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205108.158529737@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53515 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107AbYBBVra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:47:30 -0500
In-Reply-To: <20080202205108.158529737@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Thus possibly preventing e.g. ctnetlink from overruns on busy sites.
> 
> TODO: make this conditional

Indeed, a patch for that would be nice. Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
