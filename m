From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: bugfix: fix regression bug in ebt_ip6 which resulted in ebtables
 IPv6 src/dst fields not being zeroed
Date: Mon, 18 Nov 2013 21:53:24 +0100
Message-ID: <528A7E44.5080909@pandora.be>
References: <527AB6D0.8090605@uolinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "pablo@netfilter.org" <pablo@netfilter.org>
To: Luis Fernando Cornachioni Estrozi <lestrozi@uolinc.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:55611 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3KRUxf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:53:35 -0500
In-Reply-To: <527AB6D0.8090605@uolinc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luis Fernando Cornachioni Estrozi schreef op 6/11/2013 22:39:
> fix regression bug in ebt_ip6 which resulted in ebtables IPv6 src/dst
> fields not being zeroed
>
> Signed-off-by: Lu=EDs Fernando Cornachioni Estrozi <lestrozi@uolinc.c=
om>
Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
