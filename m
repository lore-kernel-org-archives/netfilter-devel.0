From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] NFQUEUE: Fix bug with order of fanout and bypass
Date: Wed, 27 Apr 2016 19:08:43 +0200
Message-ID: <20160427170843.GA7237@salvia>
References: <20160414152557.GA5338@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbcD0RIy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:08:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3D154B19D
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B315AD81
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D980AFAB4E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:08:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414152557.GA5338@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 08:55:58PM +0530, Shivani Bhardwaj wrote:
> NFQUEUE had a bug with the ordering of fanout and bypass options which
> was arising due to same and odd values for flags and bypass when used
> together. Because of this, during bitwise ANDing of flags and
> NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
> NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
> whenever it was used before bypass because then flags would be 1.

Applied, but please follow up with the test file update.

Thanks Shivani.
