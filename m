From: subashab@codeaurora.org
Subject: Re: [PATCH v4] xtables: Add an interval option for xtables lock wait
Date: Thu, 23 Jun 2016 18:39:08 -0600
Message-ID: <d6c8e1b433d4145a929574c161976aaa@codeaurora.org>
References: <1465957673-1637-1-git-send-email-subashab@codeaurora.org>
 <20160623184401.GA12620@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41115 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFXAjK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 20:39:10 -0400
In-Reply-To: <20160623184401.GA12620@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Compilation breaks with this patch:
>=20
>  xtables.c: In function =E2=80=98do_parse=E2=80=99:
>  xtables.c:1029:8: error: =E2=80=98restore=E2=80=99 undeclared (first=
 use in this=20
> function)
>     if (restore) {
>         ^
>  xtables.c:1029:8: note: each undeclared identifier is reported only
> once for each function it appears in
>  Makefile:778: recipe for target 'xtables_compat_multi-xtables.o'=20
> failed

Hi Pablo

I seem to have compiled with nftables support disables. I'll modify tha=
t=20
and upload a change now.

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora=20
=46orum, a Linux Foundation Collaborative Project.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
