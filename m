From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Sat, 1 May 2010 08:05:29 +0800
Message-ID: <q2r412e6f7f1004301705pff7d9ba2ncb7251b50c885cc6@mail.gmail.com>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
	<4BCDC0F4.5070904@trash.net> <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com>
	<4BCEF100.10006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38721 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0EAAFu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:05:50 -0400
Received: by pvg7 with SMTP id 7so444360pvg.19
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2010 17:05:49 -0700 (PDT)
In-Reply-To: <4BCEF100.10006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 21, 2010 at 8:35 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
>
> All existing users I know of process packets in order, so there's
> no need to worry about duplicate IDs.
>
> Does it really matter in your case? I mean, how long do you intend
> to keep packets in userspace? Even with 10 Mpps (which you're *very*
> unlikely to reach with userspace queueing) it still won't wrap
> around for ~430s.

Although it may not happen, we'd better deal with it. I have found a
way to speed up duplicate IDs lookup. Since the IDs in a bucket are in
order, we can first check if the new ID is in the range of first_ID
and last_ID, and in most cases, we don't need to travel the whole
bucket.

>
> Alternatively we could round the hash size to the next power of
> two to avoid this.
>

It is a better idea. Thanks.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
