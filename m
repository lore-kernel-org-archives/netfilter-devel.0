From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] Check u32 load in u8 attributes
Date: Fri, 12 Aug 2016 01:36:34 +0200
Message-ID: <20160811233634.GA5208@salvia>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51590 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbcHKXgs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:36:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0C5A91878BE
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:36:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F16341B3245
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:36:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0B7B6DA7E8
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:36:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 05:29:34PM +0200, Laura Garcia Liebana wrote:
> The following patchset adds a check during the load of an u32 value
> into an u8 attribute which can cause an overflow.

Could you collapse them all in one single patch?

You can probably use this title:

        netfilter: nf_tables: Check for overflow of u8 fields from u32 netlink attributes

And explicitly refer to 4da449ae1df in the description to link it to
this one.

Thanks.
