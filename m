From: "Loganaden Velvindron" <logan@hackers.mu>
Subject: Re: [PATCH] Fix musl compatibility
Date: Mon, 29 Feb 2016 08:21:02 -0500
Message-ID: <4a77358cc887f29232c7a8ab304196d0.squirrel@email.powweb.com>
References: <20160222115115.GA17349@mx.elandsys.com>
    <20160229125418.GA15995@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Loganaden Velvindron" <logan@hackers.mu>,
	netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from walmailout08.yourhostingaccount.com ([65.254.253.234]:56870
	"EHLO walmailout08.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbcB2Nwg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 08:52:36 -0500
Received: from mailscan02.yourhostingaccount.com ([10.1.15.2] helo=walmailscan02.yourhostingaccount.com)
	by walmailout08.yourhostingaccount.com with esmtp (Exim)
	id 1aaNlz-0001Gr-KS
	for netfilter-devel@vger.kernel.org; Mon, 29 Feb 2016 08:22:03 -0500
Received: from [10.114.3.33] (helo=walimpout13)
	by walmailscan02.yourhostingaccount.com with esmtp (Exim)
	id 1aaNlz-0004cU-F4
	for netfilter-devel@vger.kernel.org; Mon, 29 Feb 2016 08:22:03 -0500
In-Reply-To: <20160229125418.GA15995@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Mon, Feb 22, 2016 at 03:51:15AM -0800, Loganaden Velvindron wrote:
>> Add missing constants for libxt_TCPOPTSTRIP.c, in case they are not
>> defined.
>>
>> (Original patch from VoidLinux)
>
> OK, applied. Thanks.
>

Thank you Pablo !





