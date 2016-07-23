From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_connlabel: add unit test
Date: Sat, 23 Jul 2016 13:14:16 +0200
Message-ID: <20160723111416.GA12896@salvia>
References: <1469257899-27058-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36541 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbcGWLO2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:14:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9B1D7E7DA8
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:14:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8CD52DA8F3
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:14:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3B628FAB53
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:14:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469257899-27058-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 23, 2016 at 03:11:39PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Add some unit tests for connlabel match extension:
>   # ./iptables-test.py extensions/libxt_connlabel.t
>   extensions/libxt_connlabel.t: OK
>   1 test files, 7 unit tests, 7 passed

Applied, thanks!
