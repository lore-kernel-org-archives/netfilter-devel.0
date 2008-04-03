From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/24] [NETFILTER]: xt_recent: IPv6 support
Date: Thu, 03 Apr 2008 15:46:08 +0200
Message-ID: <47F4DFA0.10803@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de> <47F4DA91.2080108@trash.net> <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, gregkh@suse.de
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35109 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYDCNqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:46:12 -0400
In-Reply-To: <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>=20
> On Thursday 2008-04-03 15:24, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>>  This updates xt_recent to support IPv6 handling. It is sort of a f=
lag
>>>  day, as the new control directory is /proc/net/xt_recent with a ne=
w,
>>>  more strict protocol (the string you ought to write into
>>>  /proc/net/xt_recent/LIST). But on the other hand, I kept the binar=
y
>>>  interface towards iptables (which is quite memory consuming I must
>>>  say) to keep the patch small.
>>
>> No flag days please, either keep ipt_recent as compat interface
>> (in case you want to share lists) or do something like hashlimit
>> and add one file per family, but no xt_recent file.
>=20
> I actually thought of using sysfs instead =E2=80=94 do you know if I =
can
> tie a sysfs file to a seq_file?


I have no idea, but we've discussed this before, all netfilter
modules use /proc, so we've decided to keep it this way for
consistency. Its also doesn't seem to be a good fit for changing
lists of addresses.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
