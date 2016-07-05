From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix off-by-one in DecodeQ931
Date: Tue, 5 Jul 2016 10:54:36 +0200
Message-ID: <20160705085311.GA2332@salvia>
References: <577960db.564e370a.24a9.375a@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Toby DiPasquale <toby@cbcg.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbcGEIyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 04:54:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 20C95C22E9
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 10:54:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F511FAB4F
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 10:54:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADB659EBD4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 10:54:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <577960db.564e370a.24a9.375a@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tobias,

On Wed, Jul 13, 2016 at 02:59:00PM -0400, Toby DiPasquale wrote:
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Please add a description to your patch and include your Signed-off-by.

For more info, have a look at:

http://lxr.free-electrons.com/source/Documentation/SubmittingPatches

Thanks.
