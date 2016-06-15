From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: add endless jump loop tests
Date: Wed, 15 Jun 2016 13:59:01 +0200
Message-ID: <20160615115901.GA31077@salvia>
References: <1465822435-39991-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44135 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbcFOL7J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 07:59:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7702C9BF2C8
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:59:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63CFC1B3270
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:59:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 967AC1B3282
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:59:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465822435-39991-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 13, 2016 at 08:53:55PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Add some tests for endless jump loop validation.

Applied, thanks for adding new tests to catch this problem.
