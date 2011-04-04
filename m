From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/17] xtables_ip6addr_to_numeric: fix typo in comment
Date: Mon, 04 Apr 2011 15:31:29 +0200
Message-ID: <4D99C831.1010208@trash.net>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-3-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52352 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1DDNbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:31:35 -0400
In-Reply-To: <1301632053-3694-3-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.04.2011 06:27, Maciej =C5=BBenczykowski wrote:
> An IPv6 address consists of eight hexadecimal 16-bit values seperated
> by colons, or alternatively, six (not five) of these followed by a co=
lon
> and an IPv4 address in standard dotted decimal quad notation
> (for IPv4 mapped addresses and the like).
>=20

Applied.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
