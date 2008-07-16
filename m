From: Patrick McHardy <kaber@trash.net>
Subject: Re: some way to use NF_CT_EXPECT_PERMANENT in userspace
Date: Wed, 16 Jul 2008 14:46:59 +0200
Message-ID: <487DEDC3.2010702@trash.net>
References: <6cb26d8b0807150934u14798afaj9c4be6472091b116@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: wang feng <feng.wangs@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYGPMrE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:47:04 -0400
In-Reply-To: <6cb26d8b0807150934u14798afaj9c4be6472091b116@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

wang feng wrote:
> Hello,
> from api the attributes we can set for expectation only inclusive
> src,dst ip,port, and timeout, but from the kernel code like infunction
> "nf_ct_find_expectation" there is  also a structure named
> "nf_conntrac_expect" with flags settings with NF_CT_EXPECT_PERMANENT
> which enable a permanent expectation, can the userland api in some
> ways to enable this feature too?

No, we currently don't have the necessary attribute to set expectation
flags. Should be trivial to add though.
