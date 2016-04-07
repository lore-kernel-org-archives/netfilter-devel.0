From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] conntrack: Replace remaining occurances of --src, --dst
 options with --orig-src, --orig-dst
Date: Thu, 7 Apr 2016 19:24:55 +0200
Message-ID: <570697E7.7090705@chello.at>
References: <1459838692-17303-1-git-send-email-mart.frauenlob@chello.at>
 <20160407094025.GA1919@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-3.mx.upcmail.net ([62.179.121.150]:10733 "EHLO
	vie01a-dmta-at02-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049AbcDGRZB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:25:01 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoDfq-0007rI-4C
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 19:24:54 +0200
In-Reply-To: <20160407094025.GA1919@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.04.2016 11:40, Pablo Neira Ayuso wrote:
> On Tue, Apr 05, 2016 at 08:44:52AM +0200, Mart Frauenlob wrote:
>> The old options --src and --dst were still defined at two places.
>> Replaced with according --orig-src and --orig-dst entry.
>
> --src is valid shortcut.
>
> This breaks backward compatibility.
>


ok, so I'll update the docs, to also show --src?
