From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: ctnetlink: report error if event message
 allocation fails
Date: Fri, 17 Apr 2009 17:47:58 +0200
Message-ID: <49E8A4AE.3000808@trash.net>
References: <20090417090010.11291.31173.stgit@Decadence> <20090417090527.11291.46129.stgit@Decadence> <49E84924.9010000@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZDQPsB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:48:01 -0400
In-Reply-To: <49E84924.9010000@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
>> This patch fixes an inconsistency that results in no error reports
>> to user-space listeners if we fail to allocate the event message.
> 
> I was missing the expectation part. New patch attached.

Applied, thanks Pablo.
