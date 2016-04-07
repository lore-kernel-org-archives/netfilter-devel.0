From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] conntrack: Rename option --protonum to --proto.
Date: Thu, 7 Apr 2016 19:26:31 +0200
Message-ID: <57069847.3010709@chello.at>
References: <1459891918-2283-1-git-send-email-mart.frauenlob@chello.at>
 <20160407094207.GB1919@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:52844 "EHLO
	vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756863AbcDGR0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:26:34 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoDhO-0001X1-L6
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 19:26:30 +0200
In-Reply-To: <20160407094207.GB1919@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.04.2016 11:42, Pablo Neira Ayuso wrote:
> On Tue, Apr 05, 2016 at 11:31:58PM +0200, Mart Frauenlob wrote:
>> Usage shows --protonum, while the man page talks about --proto.
>> Should be --proto in usage too. --protonum remains valid,
>> but is marked deprecated in source.
>
> You better fix the manpage. Please, don't unnecessarily deprecate
> things. Thanks.
>

ok, I'll update docs to show both.
