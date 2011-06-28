From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Issue with conntrack on machine start-up
Date: Tue, 28 Jun 2011 17:09:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106281708200.15721@frira.zrqbmnf.qr>
References: <BANLkTi=0WdhRMoLPWWMrsxMdm0FFJQ8PGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Hai-Long Nguyen <hlnguyen21@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56813 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543Ab1F1PJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:09:05 -0400
In-Reply-To: <BANLkTi=0WdhRMoLPWWMrsxMdm0FFJQ8PGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-28 15:36, Hai-Long Nguyen wrote:

>Hi dev-team,
>
>I'm using conntrack for=C2=A0my project and have encountered an issue.
>
>When I turn on my machine for the first time, if I perform say
>"conntrack -L", no flow entries are ever shown.

Because you do not have any tracking modules loaded that would receive
packets. (e.g. nf_conntrack_ipv6)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
