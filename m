From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Thu, 13 Jan 2011 16:40:55 +0100
Message-ID: <4D2F1D07.9090301@netfilter.org>
References: <20110113123030.3407.59986.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36399 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab1AMPlB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:41:01 -0500
In-Reply-To: <20110113123030.3407.59986.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/01/11 13:30, Pablo Neira Ayuso wrote:
> This patch adds flow-based timestamping for conntracks. This
> conntrack extension is disabled by default. Basically, we use
> two 64-bits variables to store the creation timestamp once the
> conntrack has been confirmed and the other to store the deletion
> time.

Sorry, this patch does not apply, I'll fix it and will resend.
