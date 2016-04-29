From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [PATCH] examples: load modules when adding chains or tables
Date: Fri, 29 Apr 2016 13:33:29 +0200
Message-ID: <ae1c0688-55c5-017e-7c84-983242ee43b2@bmw-carit.de>
References: <1461924454-19498-1-git-send-email-wagi@monom.org>
 <20160429101811.GA16070@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:58581 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbcD2LjD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 07:39:03 -0400
In-Reply-To: <20160429101811.GA16070@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/29/2016 12:18 PM, Pablo Neira Ayuso wrote:
> On Fri, Apr 29, 2016 at 12:07:34PM +0200, Daniel Wagner wrote:
>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>
>> Tell the kernel to load the necessary modules by adding
>> the NLM_F_CREATE flag.
> 
> Applied, thanks for following up on this.

np. you saved me time debugging, so it's a fair deal :)
