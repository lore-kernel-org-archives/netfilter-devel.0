From: Jari Turkia <jmjt@lut.fi>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes behavioural
 change in userspace?
Date: Thu, 24 Oct 2013 11:28:38 +0300
Message-ID: <5268DA36.7020700@lut.fi>
References: <52667EBC.5010709@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:56299 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab3JXIfE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:35:04 -0400
Received: from samba.jari.turkia.name (80.221.237.129) by kirsi1.inet.fi (8.5.140.03)
        id 52594F0900E6E6C9 for netfilter-devel@vger.kernel.org; Thu, 24 Oct 2013 11:28:41 +0300
Received: from [172.16.0.100] (gprs-internet-2e84b9-123.dhcp.inet.fi [46.132.185.123])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jmjt)
	by samba.jari.turkia.name (Postfix) with ESMTPSA id 90236601A8
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 11:28:40 +0300 (EEST)
In-Reply-To: <52667EBC.5010709@ee.oulu.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22.10.2013 16:33, Pekka Pietik=E4inen wrote:
> After a kernel update to 3.11 (feat. commit
> ...
> and the 3-way handshake never finishes. Without -m socket (or with th=
e=20
> new --nowildcard) it does.
>
> Bug, feature or end-user cluelessness? (no problem fixing my ruleset,=
=20
> but it's still a behaviourial change :P )
I have to say, that there is something fishy in 3.11 netfilter.=20
nat-table MASQUERADE used to work, but doesn't anymore. I don't know if=
=20
it is generic to kernel, or Fedora Linux -specific, but I'd appreciate=20
if somebody could confirm that I'm right or wrong. On my box, I'm=20
running KVM and have bridged interfaces for KVM, but I did disable both=
=20
of them and MASQUERADE still fails.

My guess is that the problems you mention and I can observe in my box=20
are not common enough for people to notice.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=3D1016739

Regards,
Jari Turkia
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
