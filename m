From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Tue, 24 May 2016 11:44:09 +0200
Message-ID: <20160524094409.GA2344@salvia>
References: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
 <20160517103842.GA3324@salvia>
 <CAMArcTUm9PeVD3+Vq7g0OffqxUZQJYRJs304jAF90LXH1Xj1YA@mail.gmail.com>
 <20160524092351.GA2105@salvia>
 <CA+6hz4p6Tf8+Hy2hThCYOtU1MP-+ptF5t63QVRqH2TUi__bL+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbcEXJoW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:44:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 53B03114802
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:44:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BEA313473D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:44:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BE67A15D627
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:44:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4p6Tf8+Hy2hThCYOtU1MP-+ptF5t63QVRqH2TUi__bL+Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tue, May 24, 2016 at 05:36:30PM +0800, Feng Gao wrote:
> Yes, right.
> 
> You mean the module forbid the user enters the duplicated ports now.

OK, if this is OK to you I'll submit this, thanks for reviewing.

BTW:

A: No, please don't do it.
Q: Is it fine to top-post in this mailing list? [1]

:)

[1] https://en.wikipedia.org/wiki/Posting_style
