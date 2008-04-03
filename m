From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 12/24] [NETFILTER]: xt_recent: IPv6 support
Date: Thu, 3 Apr 2008 15:43:19 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de> <47F4DA91.2080108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, gregkh@suse.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36420 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYDCNnU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:43:20 -0400
In-Reply-To: <47F4DA91.2080108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 15:24, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>  This updates xt_recent to support IPv6 handling. It is sort of a fl=
ag
>>  day, as the new control directory is /proc/net/xt_recent with a new=
,
>>  more strict protocol (the string you ought to write into
>>  /proc/net/xt_recent/LIST). But on the other hand, I kept the binary
>>  interface towards iptables (which is quite memory consuming I must
>>  say) to keep the patch small.
>
> No flag days please, either keep ipt_recent as compat interface
> (in case you want to share lists) or do something like hashlimit
> and add one file per family, but no xt_recent file.

I actually thought of using sysfs instead=C2=A0=E2=80=94 do you know if=
 I can
tie a sysfs file to a seq_file?


--=20
make boldconfig -- to boldly select what no one has selected before
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
