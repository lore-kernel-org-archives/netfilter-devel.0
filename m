From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] tproxy: add lookup type checks for UDP in nf_tproxy_get_sock_v4()
Date: Thu, 21 Oct 2010 12:48:36 +0200
Message-ID: <4CC01A84.9090505@trash.net>
References: <20101020112142.6538.25550.stgit@este.odu> <20101020112142.6538.2526.stgit@este.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54371 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab0JUKsi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:48:38 -0400
In-Reply-To: <20101020112142.6538.2526.stgit@este.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 20.10.2010 13:21, schrieb KOVACS Krisztian:
> Also, inline this function as the lookup_type is always a literal
> and inlining removes branches performed at runtime.

Applied, thanks.
