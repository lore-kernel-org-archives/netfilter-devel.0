From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 17/17] v6: rename do_command() to do_command6()
Date: Mon, 04 Apr 2011 21:48:12 +0200
Message-ID: <4D9A207C.8080003@trash.net>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>	<1301632053-3694-17-git-send-email-zenczykowski@gmail.com>	<4D99CA61.1070503@trash.net> <BANLkTikk81Vb+s=mGdL+DwGuZ6xeZJmJAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58432 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1DDTsO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:48:14 -0400
In-Reply-To: <BANLkTikk81Vb+s=mGdL+DwGuZ6xeZJmJAQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 04.04.2011 21:33, schrieb Maciej =C5=BBenczykowski:
>> Also applied, thanks.
>>
>> If you plan to submit more patches in the future, I'd appreciate it
>> if you would combine simple patches that basically all do the same
>> things like the v4 and v6 renames into a single larger patch.
>=20
> Ok, I was assuming review would be easier with simpler patches.
> Does your request also hold true if I provide a git repo to pull from=
?

That's always preferred, but I think it would still make sense to
fold a bunch of renames that happen for the same purpose into a
single patch. If it gets to large, one patch for v4 and one for v6
would also be fine.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
