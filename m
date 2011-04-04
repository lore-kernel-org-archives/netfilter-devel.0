From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 17/17] v6: rename do_command() to do_command6()
Date: Mon, 04 Apr 2011 15:40:49 +0200
Message-ID: <4D99CA61.1070503@trash.net>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-17-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52576 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1DDNk4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:40:56 -0400
In-Reply-To: <1301632053-3694-17-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.04.2011 06:27, Maciej =C5=BBenczykowski wrote:
> (actually only applies to two comments, since the
> function has long been called do_command6)
>=20

Also applied, thanks.

If you plan to submit more patches in the future, I'd appreciate it
if you would combine simple patches that basically all do the same
things like the v4 and v6 renames into a single larger patch.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
