From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: add expectation deletion events
Date: Tue, 19 Oct 2010 10:20:10 +0200
Message-ID: <4CBD54BA.3040306@trash.net>
References: <20101014120209.3062.89240.stgit@decadence> <4CB876D5.208@trash.net> <4CB8847E.4030004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0JSIUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:20:13 -0400
In-Reply-To: <4CB8847E.4030004@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.10.2010 18:42, schrieb Pablo Neira Ayuso:
> On 15/10/10 17:44, Patrick McHardy wrote:
>> Am 14.10.2010 14:02, schrieb Pablo Neira Ayuso:
>>> This patch allows to listen to events that inform about
>>> expectations destroyed.
>>
>> This looks fine, but I'm wondering why we're not delivering
>> events for expectations created and destroyed by helpers using
>> nf_conntrack_expect_related()/nf_conntrack_unexpect_related().
> 
> We already deliver events for new expectations. Wrt. destroyed
> expectations, nf_ct_unexpect_related() internally calls
> nf_ct_unlink_expect(), so they are also delivered.

I see. Applied, thanks Pablo.
