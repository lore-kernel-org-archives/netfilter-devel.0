From: Lion Yang <lion@aosc.io>
Subject: Re: [Documentation] SNAT in INPUT chain
Date: Wed, 27 Apr 2016 00:46:02 +0800
Message-ID: <1236201461689162@web24g.yandex.ru>
References: <670551461680277@web23j.yandex.ru> <20160426161417.GA3100@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward17p.cmail.yandex.net ([87.250.241.131]:33847 "EHLO
	forward17p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbcDZQxr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 12:53:47 -0400
In-Reply-To: <20160426161417.GA3100@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes, enough.

27.04.2016, 00:13, "Florian Westphal" <fw@strlen.de>:
> Is this enough?
>
> --- a/iptables/iptables.8.in
> +++ b/iptables/iptables.8.in
> @@ -103,8 +103,9 @@ the built-in chains \fBINPUT\fP (for packets dest=
ined to local sockets),
> =9A.TP
> =9A\fBnat\fP:
> =9AThis table is consulted when a packet that creates a new
> -connection is encountered. It consists of three built-ins: \fBPREROU=
TING\fP
> -(for altering packets as soon as they come in), \fBOUTPUT\fP
> +connection is encountered. It consists of four built-ins: \fBPREROUT=
ING\fP
> +(for altering packets as soon as they come in), \fBINPUT\fP (for alt=
ering
> +packets destined for local sockets), \fBOUTPUT\fP
> =9A(for altering locally-generated packets before routing), and \fBPO=
STROUTING\fP
> =9A(for altering packets as they are about to go out).
> =9AIPv6 NAT support is available since kernel 3.7.

--
Lion Yang
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
