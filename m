From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 18:07:53 +0200
Message-ID: <46FD26D9.9040504@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr> <46FD2173.8030403@trash.net> <Pine.LNX.4.64.0709281802330.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55481 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXI1QIZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:08:25 -0400
In-Reply-To: <Pine.LNX.4.64.0709281802330.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Sep 28 2007 17:44, Patrick McHardy wrote:
> 
>>Besides that: if the options are contained in every packet (lets
>>say timestamp option) and is always stripped, the sender *should*
>>assume the bigger MTU. And if it really overestimates it will
>>receive a frag. needed message and learn the correct one.
> 
> 
> It will not receive a frag on the SYN, but later on.
> Does that work? I.e. subsequently change the tcp connection's base mtu?


Of course, there are lots of reasons why this could happen.
