From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH 4/4 v3] evaluate: fix a crash if we check the transport
 protocol is tcp
Date: Tue, 21 Oct 2014 14:28:46 +0200
Message-ID: <5446517E.9070003@gmail.com>
References: <1413847780-10149-1-git-send-email-alvaroneay@gmail.com> <1413847780-10149-4-git-send-email-alvaroneay@gmail.com> <20141021081522.GB3628@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48810 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJUM2c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:28:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id r20so1650460wiv.11
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 05:28:26 -0700 (PDT)
In-Reply-To: <20141021081522.GB3628@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 21/10/14 10:15, Pablo Neira Ayuso escribi=F3:
> On Tue, Oct 21, 2014 at 01:29:40AM +0200, Alvaro Neira Ayuso wrote:
>> Example:
>>
>> nft add rule inet filter input meta l4proto udp reject with tcp rese=
t
>>
>> If we try to check if the transport protocol is tcp, we use the netw=
ork context.
>> If we don't have this network context, we have a crash.
>
> I have applied this with minor changes.
>
> Please, select the patch ordering carefully. This is a v3 coming as
> the 4th patch in a batch.
>
> Remember: Fixes always come in first place. Thanks.
>

Catched. Sorry.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
