From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH next 0/30] Passing net through the netfilter hooks
Date: Fri, 18 Sep 2015 09:08:50 +0200
Message-ID: <55FBB882.8090403@6wind.com>
References: <87mvwn18my.fsf@x220.int.ebiederm.org>
 <55FAEAAC.1070302@6wind.com> <876138wuoq.fsf@x220.int.ebiederm.org>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36496 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbIRHIy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Sep 2015 03:08:54 -0400
Received: by wicgb1 with SMTP id gb1so19410650wic.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2015 00:08:53 -0700 (PDT)
In-Reply-To: <876138wuoq.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 18/09/2015 00:24, Eric W. Biederman a =C3=A9crit :
[snip]
> Thanks for review.  I have added an extra patch for the missing blank
> lines that are still missing after the entire series.  As they affect
> neither code correctness nor bisectability I don't think there is any
> point respinning the indivdual patches.
It's fine for me, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
