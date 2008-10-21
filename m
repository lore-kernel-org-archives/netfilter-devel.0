From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Tue, 21 Oct 2008 17:07:57 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810211707130.16007@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu> <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl> <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46773 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYJUVH7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:07:59 -0400
In-Reply-To: <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-21 17:05, Jozsef Kadlecsik wrote:
>
>No, the separator between the different kind of elements, i.e. between IP 
>address and port or between IP address and MAC address. The token 
>separators inside IPv4(/IPv6) and MAC addresses remain the usual ones.
>
>That message is just misleading and I'm going to fix it.
>
>Sorry for the mess created by introducing earlier the '%' as a separator,
>that was a bad choice. :-(

	1.2.3.4,5.6.7.8,[2001:db8::90]
works wonders to distuinguish IPv6 addresses ;-)
