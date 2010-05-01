From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Sat, 01 May 2010 18:42:29 +0200
Message-ID: <4BDC59F5.90802@trash.net>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com> 	<4BCDC0F4.5070904@trash.net> <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com> 	<4BCEF100.10006@trash.net> <q2r412e6f7f1004301705pff7d9ba2ncb7251b50c885cc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47713 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0EAQmi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 May 2010 12:42:38 -0400
In-Reply-To: <q2r412e6f7f1004301705pff7d9ba2ncb7251b50c885cc6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Wed, Apr 21, 2010 at 8:35 PM, Patrick McHardy <kaber@trash.net> wrote:
>> All existing users I know of process packets in order, so there's
>> no need to worry about duplicate IDs.
>>
>> Does it really matter in your case? I mean, how long do you intend
>> to keep packets in userspace? Even with 10 Mpps (which you're *very*
>> unlikely to reach with userspace queueing) it still won't wrap
>> around for ~430s.
> 
> Although it may not happen, we'd better deal with it. I have found a
> way to speed up duplicate IDs lookup. Since the IDs in a bucket are in
> order, we can first check if the new ID is in the range of first_ID
> and last_ID, and in most cases, we don't need to travel the whole
> bucket.

They are not necessarily in order since the ID counter will eventually
wrap, but elements are always appened (at least currently).
