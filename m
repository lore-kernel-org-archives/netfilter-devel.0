From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_conntrack] src: Make the library compile
 under clang
Date: Wed, 17 Aug 2016 17:05:49 +0200
Message-ID: <20160817150549.GA11225@salvia>
References: <1471208341-24673-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34158 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQPGx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:06:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 36453D163A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:05:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1A19AFF2FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:05:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 00F7EDA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:05:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471208341-24673-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 14, 2016 at 01:59:01PM -0700, Kevin Cernekee wrote:
> clang treats "char buffer[size]" inside a union as VLAIS unless |size|
> is const:
> 
> src/conntrack/api.c:992:8: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
>                 char buffer[size];
>                      ^

Applied, thanks.
