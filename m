From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 	finding.
Date: Thu, 15 Apr 2010 12:36:05 +0200
Message-ID: <4BC6EC15.4070205@trash.net>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net> 	<n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com> 	<1271162669.16881.301.camel@edumazet-laptop> <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com> 	<1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net> <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60712 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0DOKgG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:36:06 -0400
In-Reply-To: <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Tue, Apr 13, 2010 at 9:25 PM, Patrick McHardy <kaber@trash.net> wrote:
>>> Yes, that is why vmalloc() is perfect for this case. No extra memory for
>>> management, but one pointer for each page of memory.
>> I agree, if it works for conntrack, it certainly also works for
>> nfnetlink_queue.
>>
> 
> I need to allocate memory in atomic section, so vmalloc() can't be used. :(

Why?
