From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Matching MLD with ip6tables
Date: Tue, 16 Jun 2015 09:17:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1506160912570.21227@nerf40.vanv.qr>
References: <20150501025612.GB2465@odroid> <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr> <20150616054551.GB14231@odroid>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:52114 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbbFPHR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 03:17:27 -0400
In-Reply-To: <20150616054551.GB14231@odroid>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2015-06-16 07:45, Linus L=C3=BCssing wrote:

>On Fri, May 01, 2015 at 08:33:03AM +0200, Jan Engelhardt wrote:
>> -p matches the first non-extension header. For the
>> exthdrs, there is e.g. -m hbh.
>
>Just to check, I guess ebtables is behaving similarly?

Since Ethernet does not define any "Extension Headers",
-p matches the one and only Protocol field there is,
and it will be IPv6 if you say -p ipv6.


>And "-p IPv6 --ip6-proto 0" will *not* match packets with a
>hop-by-hop header?

That's a hard one, because the userspace tools were once written with=20
the assumption that 0 means "ANY". And then IANA used that value. D'oh.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
