From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/6] tests/py: fix style
Date: Mon, 4 Jan 2016 12:32:02 +0100
Message-ID: <20160104113202.GB2045@salvia>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
 <1451904236-4481-2-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35024 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbcADLcK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 06:32:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 74589130FC3
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:32:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B950DA809
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:32:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F2566DA795
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2016 12:32:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1451904236-4481-2-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 11:43:52AM +0100, Pablo M. Bermudo Garay wrote:
> - Adjust lines to 120 columns style

Netfilter project coding style sticks to 80 columns. I'd rather keep
that.

BTW, I suggest next time you keep this style cleanup patches at the
end of the patchset that you submit.

Apart from that, the patchset looks good and I'd like to see this
integrated into master.
