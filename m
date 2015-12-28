From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_REJECT: Add translation to nft
Date: Mon, 28 Dec 2015 13:17:29 +0100
Message-ID: <20151228121729.GA19188@salvia>
References: <20151227044248.GA5043@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59301 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbbL1MRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 07:17:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D0C141392A5
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:17:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0972DA85D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:17:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0062CDA862
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:17:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151227044248.GA5043@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 27, 2015 at 10:12:48AM +0530, Shivani Bhardwaj wrote:
> Add translation for target REJECT to nftables.

Applied, thanks.

> +static int REJECT_xlate(const struct xt_entry_target *target,
> +			struct xt_buf *buf, int numeric)
> +{
> +	const struct ipt_reject_info *reject
> +				= (const struct ipt_reject_info *)target->data;

BTW, always keep the operand on the original line that you're
breaking, ie.

	const struct ipt_reject_info *reject =
                (const struct ipt_reject_info *)target->data;

This also applies to things like:

        if (a != 10 &&
            b != 20 &&
            c != 30)

Please, follow up with a translation for libip6t_REJECT. Thanks.
