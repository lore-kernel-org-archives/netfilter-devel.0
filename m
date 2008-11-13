From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [tproxy] udp + tproxy
Date: Thu, 13 Nov 2008 08:17:14 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811130815300.8076@fbirervta.pbzchgretzou.qr>
References: <1226490030.31896.12.camel@sysandrey.icomswg.local>  <20081112185910.GA1793@sch.bme.hu> <1226518030.10667.68.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@sch.bme.hu>,
	Andrey Luzgin <andrey@icomsw.com>, tproxy@lists.balabit.hu,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36501 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYKMHRQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:17:16 -0500
In-Reply-To: <1226518030.10667.68.camel@bzorp.balabit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-12 20:27, Balazs Scheidler wrote:
>> 
>> Since tproxy 4 (unlike tproxy 2) doesn't modify the incoming packets in
>> any way you should be able to get the correct destination address by
>> simply calling recvfrom() and using the source address returned by the
>> kernel.
>
>This is not true, recvfrom() returns the client address and does not
>return the original destination.

Mh, perhaps getsockname() could do something - well, at least
if used with accept() and as such, mostly for TCP only.
