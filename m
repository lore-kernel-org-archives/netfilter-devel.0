From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: filter IP protocol with ip6tables
Date: Wed, 30 May 2012 18:59:04 +0200 (CEST)
Message-ID: <856i5i0.8d94641ae92b968dc968d4a2d41e077f@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: kohler@umic.rwth-aachen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:34209 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2E3Q7H convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 May 2012 12:59:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello
>
>Hi,
>
>I tried to filter IP packets with ip6tables (next hdr field)
>
>But as you can see in output [1] the kernel maps "0" to all and not to
>ip as listed in /etc/protocols.
>

Have you tried the ip6tables  -m ipv6header --header ... ?

Btw read you uploaded file,

Next header   0 is Hop-by-hop option header 
Next header 41 is IPv6 in IPv6


Regards 
Hans Schillstrom

