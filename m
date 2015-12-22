From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add translation to nft
Date: Tue, 22 Dec 2015 18:01:51 +0100
Message-ID: <20151222170151.GA20841@salvia>
References: <20151221173559.GA8787@gmail.com>
 <CAOkSjBiJ+wWWyt+4ewjEJyMN79C6Navd19Av6n6LVo0tfyd-Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36155 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbbLVRBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 12:01:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A441C23CF6F
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:01:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 969AADA873
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:01:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17E5ADA875
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:01:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBiJ+wWWyt+4ewjEJyMN79C6Navd19Av6n6LVo0tfyd-Ow@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 01:47:57PM +0100, Arturo Borrero Gonzalez wrote:
> On 21 December 2015 at 18:35, Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> >
> > +static void nflog_print_xlate(const struct xt_nflog_info *info,
> > +                             char *prefix, struct xt_buf *buf)
> > +{
> > +       if (info->prefix[0] != '\0')
> > +               xt_buf_add(buf, "%slog prefix \\\"%s\\\" ",
> > +                          prefix, info->prefix);
> > +       if (info->group)
> > +               xt_buf_add(buf, "%slog group %u ", prefix, info->group);
> 
> if info->group is not set, you should probably default to 0, since
> this group info is mandatory in nftables to consider this logging the
> same type of NFLOG (ie, use nfnetlink_log).
> 
> For reference, see:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/netfilter/nft_log.c#n67

Thanks Arturo.

Please Shivani, address Arturo's feedback and send me an incremental
patch to fix this.
