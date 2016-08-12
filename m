From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] utils: Don't return directly from
 SNPRINTF_BUFFER_SIZE
Date: Fri, 12 Aug 2016 15:37:11 +0200
Message-ID: <20160812133711.GA2036@salvia>
References: <1471005590-18276-1-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <psutter@redhat.com>,
	Arturo Borrero <arturo.borrero.glez@gmail.com>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43996 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbcHLNhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 09:37:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 29FE3D163B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 15:37:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1109DFF2D6
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 15:37:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 06E8EFAB4F
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 15:37:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471005590-18276-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 02:39:50PM +0200, Phil Sutter wrote:
> From: Phil Sutter <psutter@redhat.com>
> 
> Apart from being a bad idea in general, the return statement contained
> in that macro in some cases leads to returning from functions without
> properly cleaning up, thereby causing memory leaks.
> 
> Instead, just sanitize the value in 'ret' to not harm further calls of
> snprintf() (as 'len' will eventually just become zero).

Applied, thanks.
