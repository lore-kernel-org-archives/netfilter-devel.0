From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 04/15] Add IFI list
Date: Sat, 02 Feb 2008 22:36:24 +0100
Message-ID: <47A4E258.2060907@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205107.726859754@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50155 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754103AbYBBVgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:36:35 -0500
In-Reply-To: <20080202205107.726859754@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Index: ulogd-netfilter/src/ifi.c
> ===================================================================
> --- /dev/null
> +++ ulogd-netfilter/src/ifi.c

AFAICS, this file implements something similar to the ifname2index API
which lives in libnfnetlink. Why don't you that instead? See the
utils/iftest.c file under libnfnetlink for an example.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
