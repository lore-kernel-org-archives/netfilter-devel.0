From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] [LIBNETFILTER_CONNTRACK] api: remove dead code	(nfexp_parse_expect)
Date: Thu, 08 Oct 2009 18:03:39 +0200
Message-ID: <4ACE0D5B.80704@netfilter.org>
References: <20091007123624.5204.92195.stgit@lb64> <20091007123911.5204.10713.stgit@lb64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hannes Eder <heder@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49173 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbZJHQLF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:11:05 -0400
In-Reply-To: <20091007123911.5204.10713.stgit@lb64>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hannes Eder wrote:
> Signed-off-by: Hannes Eder <heder@google.com>
> ---
> I am not sure about this one, it just popped up after making
> symbols that are just used in file scope static.  This might be
> a function the you would like to export, so a proper fix would be
> adding it to the header file.

Oh, I see. I think that we also need to export nfexp_build* functions to
provide an API similar to the conntrack API. Let me think what to do
with this. So far, nobody has used them though.
