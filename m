From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH V2] ipvs: disable inline net_ipvs function with CONFIG_IP_VS
 not being set
Date: Wed, 25 Mar 2015 14:12:56 +0100
Message-ID: <5512B458.8000403@6wind.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com>	<1427275043-1192-1-git-send-email-zajec5@gmail.com>	<55128D32.50201@6wind.com> <CACna6rwMOJqRusrooUXKFk9HbVA4NqOY18fCTkqHyTvQA6O_bA@mail.gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33490 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbCYNM7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 09:12:59 -0400
Received: by wixw10 with SMTP id w10so74229366wix.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 06:12:58 -0700 (PDT)
In-Reply-To: <CACna6rwMOJqRusrooUXKFk9HbVA4NqOY18fCTkqHyTvQA6O_bA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/03/2015 12:08, Rafa=C5=82 Mi=C5=82ecki a =C3=A9crit :
> On 25 March 2015 at 11:25, Nicolas Dichtel <nicolas.dichtel@6wind.com=
> wrote:
[snip]
>> For me, it's a bit strange to have '#ifdef CONFIG_IP_VS' in a file s=
pecific
>> to
>> this module. This just fix your third party module.
>
> Will do. I was just thinking this header doesn't follow headers logic
> well and wanted to help.
>
The logic is to fix bug that are in-tree ;-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
