From: Laura Garcia <nevola@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] extensions: libxt_statistic: Add
 translation to nft
Date: Tue, 1 Mar 2016 16:56:59 +0100
Message-ID: <20160301155657.GB3838@sonyv>
References: <20160229212216.GA29706@sonyv>
 <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
 <20160301101331.GA2714@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36504 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbcCAP5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:57:04 -0500
Received: by mail-wm0-f50.google.com with SMTP id n186so43878331wmn.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 07:57:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160301101331.GA2714@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 11:13:31AM +0100, Pablo Neira Ayuso wrote:
> 
> I would like to have them merged upstream, no need to wait to fully
> support every extension, we can document these limitations in the wiki
> and the commit log.
> 
> IIRC, if the .xlate indirection returns 0, then it means no
> translation is available. We can use that for things that we don't
> support yet.
>

Hi Pablo, should I have to include this in the patch?

Thanks.

