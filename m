From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 11:49:03 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201111148001.4538@frira.zrqbmnf.qr>
References: <4F0CE6C0.6080900@nod.at> <alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr> <4F0D5BE4.3040509@nod.at> <CAHo-Oow9fZg+O6jkmzN2cLooE6TwsFmOib+1gF5_VXtwXRt=Wg@mail.gmail.com> <4F0D668A.5060200@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55950 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab2AKKtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:49:07 -0500
In-Reply-To: <4F0D668A.5060200@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-01-11 11:38, Richard Weinberger wrote:

>Am 11.01.2012 11:27, schrieb Maciej =C5=BBenczykowski:
>> every change, whether addition or deletion is done via table-replace=
ment.
>> the only modification operation supported is table replacement.
>> so you're making 6 table replecaments with those 6 commands.
>
>So the table is read-only and is being recreated on each change, right=
?

There is nothing that makes it read only. It is simply the atomicity=20
guarantee that requires placing a new table inplace before the old one=20
can be freed.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
