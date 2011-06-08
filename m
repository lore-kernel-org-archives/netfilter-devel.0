From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Iptables 1.4.11.1
Date: Wed, 8 Jun 2011 13:02:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106081300580.1830@frira.zrqbmnf.qr>
References: <BANLkTikXniUM8jvKXr7UMauRtXGti1Bxqw@mail.gmail.com> <4DEEABCB.4060203@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56637 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab1FHLCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:02:06 -0400
In-Reply-To: <4DEEABCB.4060203@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-06-08 00:52, Patrick McHardy wrote:

>On 07.06.2011 20:06, Maciej =C5=BBenczykowski wrote:
>> Seeing as there's a couple build fixes and inverted flags don't work=
 fixes,
>> are you planning on releasing an iptables 1.4.11.1 sometime soon?
>
>Yes, but since we're still getting new reports without multiple
>reports for the same issues, I think we should wait a few more
>days and then put out a new release.

"Release early, release often". Waiting would increase the chance that=20
Debian updates to .11 instead of jumping from .10->.12, and that would=20
then send us duplicates all the way.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
