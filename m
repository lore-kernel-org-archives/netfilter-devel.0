From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
Date: Mon, 21 Aug 2017 21:01:55 +0200
Message-ID: <1503342115.9868.5.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-2-eric@regit.org> <20170821081050.GA2982@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:52578 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753768AbdHUTB7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 15:01:59 -0400
In-Reply-To: <20170821081050.GA2982@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-08-21 at 10:10 +0200, Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> On Sat, Aug 19, 2017 at 05:24:03PM +0200, Eric Leblond wrote:
> > If one of the command is failing we should return an error.
> 
> Is this fixing up a real issue or it is something you need in a
> follow
> up patch?

Not really for current users of the function. But I think but it is an
issue as the result of the function is success even when it fails.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
