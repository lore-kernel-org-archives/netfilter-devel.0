From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 12/24] [NETFILTER]: xt_recent: IPv6 support
Date: Thu, 3 Apr 2008 15:58:39 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031552320.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de> <47F4DA91.2080108@trash.net> <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
 <47F4DFA0.10803@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, gregkh@suse.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58192 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYDCN6k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:58:40 -0400
In-Reply-To: <47F4DFA0.10803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 15:46, Patrick McHardy wrote:
>>
>>  I actually thought of using sysfs instead =E2=80=94 do you know if =
I can
>>  tie a sysfs file to a seq_file?
>
> I have no idea, but we've discussed this before, all netfilter
> modules use /proc,

I miss the =E2=80=9Cdo not use /proc for new files=E2=80=9D consensus..=
 :-/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
