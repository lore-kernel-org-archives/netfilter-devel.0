From: David Murray <30179198@student.murdoch.edu.au>
Subject: Re: Caching packets with libipq
Date: Mon, 19 Jan 2009 12:06:20 +0900
Message-ID: <20090119120620.b5lyivi8xa8048k4@wwwstudent.murdoch.edu.au>
References: <20090116104104.kzzlq1ol9g80cgok@wwwstudent.murdoch.edu.au>
	<1232090567.3789.2.camel@ice-age> <4973C9DB.4060902@student.murdoch.edu.au>
	<4973CDA3.1050408@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eleblond@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from helene.murdoch.edu.au ([134.115.4.100]:37154 "EHLO
	iris.murdoch.edu.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754302AbZASDYQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:24:16 -0500
In-Reply-To: <4973CDA3.1050408@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quoting Pablo Neira Ayuso <pablo@netfilter.org>:

>> 5. The example code you give includes a callback function. Can you write
>> a libnetfilter_queue program without a call back? It might be easier for
>> people without lots of c experience to modify and start doing things.
>
> IIRC nfq_handle_packet uses that callback internally.
>

Are you saying that libnetfilter_queue can be used without using 
nfq_create_queue. As far as I can tell (FYI I am a c novice), if you 
use nfq_create_queue it must contain the a link to the address of the 
callback function. All of the examples I can find do all the packet 
processing within this callback function. If this is the case, I cannot 
understand how you could keep ongoing statistics of packets or flows 
via libnetfilter_queue without using a lot of globals.
