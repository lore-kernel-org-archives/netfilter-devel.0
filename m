From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not
 truncate packets
Date: Wed, 20 Jul 2016 10:25:21 +0200
Message-ID: <20160720082521.GA1336@salvia>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-4-git-send-email-zlpnobody@163.com>
 <20160719181600.GD6116@salvia>
 <60a932e7.d60.15605635cca.Coremail.zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50936 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbcGTIZg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 04:25:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 570BD114804
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 10:25:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 46EFAFAB5A
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 10:25:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A174AFAB5F
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 10:25:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <60a932e7.d60.15605635cca.Coremail.zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 07:00:13AM +0800, Liping Zhang wrote:
> At 2016-07-20 02:16:00, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:
> >On Mon, Jul 18, 2016 at 08:44:17PM +0800, Liping Zhang wrote:
> >> From: Liping Zhang <liping.zhang@spreadtrum.com>
> >> 
> >> There's a similar problem in xt_NFLOG, and was fixed by commit 7643507fe8b5
> >> ("netfilter: xt_NFLOG: nflog-range does not truncate packets"). Only set
> >> copy_len here does not work, so we should enable NF_LOG_F_COPY_LEN also.
> >
> >Applied, thanks.
> >
> >Will you send me a patch for nftables userspace to enable this flag?
> >
> >It would be good to update the translation to make sure --nflog-size
> >map to snaplen and ignore --nflog-range.
> 
> I find that nftables already support this feature, the following command mean to truncate packets
> to 100 bytes before logging to the userspace:
>   #nft add rule filter input log group 0 snaplen 100
> 
> Before my patch, it does not work.
> And after apply my patch, it works as expected.

If I git grep NF_LOG_F_COPY_LEN from the nftables.git tree, I don't
see any reference to this flag being set.

Then, nft_log kernel has been actually working fine since the
beginning. It would be good anyway if we set this flag on from
userspace to leave things in consistent state.
