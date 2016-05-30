From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] datatype: fix parsing of tchandle type
Date: Mon, 30 May 2016 11:59:30 +0200
Message-ID: <20160530095930.GA20674@salvia>
References: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbcE3J7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:59:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9E99A1FE28D
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:59:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 90B9115D635
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:59:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 657D615D64D
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:59:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 29, 2016 at 06:08:07PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Properly detect tchandle strings in the lexer without quotation marks,
> otherwise nft will complain the syntax error like this:
> 
>   # nft add rule filter test meta priority set 1:2
>   <cmdline>:1:41-41: Error: syntax error, unexpected colon, expecting end of file or newline or semicolon
>   add rule filter test meta priority set 1:2
>                                           ^

This is breaking several tests under tests/py/ (see nft-tests.py
script), so I'll keep this back by now. Let me have a look into this.
