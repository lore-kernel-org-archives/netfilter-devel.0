From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] netfilter: nfnetlink_acct: report overquota to
 the right netns
Date: Thu, 18 Aug 2016 00:26:49 +0200
Message-ID: <20160817222649.GB2798@salvia>
References: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
 <1471101182-15294-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48746 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbcHQW0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 18:26:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0A93E8E90
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0F151B332B
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AF5CFFAB4F
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:26:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471101182-15294-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 13, 2016 at 11:13:02PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We should report the over quota message to the right net namespace
> instead of the init netns.

Also applied, thanks.
