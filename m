From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: Re: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Thu, 20 Sep 2012 16:17:25 +0200
Message-ID: <505B2575.80502@sophos.com>
References: <20120920135133.GA21538@uweber-WS> <1348150485.31352.87.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:51451 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2ITORa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:17:30 -0400
In-Reply-To: <1348150485.31352.87.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/20/2012 04:14 PM, Eric Dumazet wrote:
> This could explain the rcu_read_unlock() imbalance Stephen had=20
> (lockdep splat with net-next) How old is this bug ?=20
Bug was introduced with c7232c9979cba684c50b64c513c4a83c9aa70563

Cheers
  Ulrich

--=20
Ulrich Weber | ulrich.weber@sophos.com | Senior Software Engineer
Astaro - a Sophos company | Amalienbadstr 41 | 76227 Karlsruhe | German=
y
Phone +49-721-25516-0 | Fax =E2=80=93200 | www.astaro.com

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
