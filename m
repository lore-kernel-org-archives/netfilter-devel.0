From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] tests: add *.got files to .gitignore
Date: Thu, 10 Dec 2015 18:28:34 +0100
Message-ID: <20151210172834.GA4705@salvia>
References: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38882 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbbLJR2p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 12:28:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8C7F78E7B2
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:28:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F1100DA3F5
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:28:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 11298DA245
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:28:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 01, 2015 at 11:45:21PM +0100, Pablo M. Bermudo Garay wrote:
> During tests execution, some *.payload.got files may be generated. To
> avoid annoyances, this commit adds the pattern to .gitignore. Also, the
> file "dup.t.payload.got", that was presumably included by mistake, has
> been deleted.

Series from 1 to 3 applied, thanks.

I have slightly mangled patch 2/3 to effectively remove some lines
that don't make sense to have at this stage.
