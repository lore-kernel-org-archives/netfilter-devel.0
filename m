From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_log: use %s format string for
 buffer
Date: Mon, 6 Jan 2014 14:21:13 +0100
Message-ID: <20140106132113.GA8714@localhost>
References: <1388966656-12414-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57880 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbaAFNVX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:21:23 -0500
Content-Disposition: inline
In-Reply-To: <1388966656-12414-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 01:04:16AM +0100, Daniel Borkmann wrote:
> Some invocations of nf_log_packet() use arg buffer directly instead of
> "%s" format string with follow-up buffer pointer. Currently, these two
> usages are not really critical, but we should fix this up nevertheless
> so that we don't run into trouble if that changes one day.

applied, thanks.
