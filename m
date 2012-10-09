From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: iptables-dev Source Example
Date: Wed, 10 Oct 2012 00:08:07 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210100007100.16482@nerf07.vanv.qr>
References: <5072D6F8.2010707@iit.demokritos.gr> <20121008152237.GA8350@1984>    <CAHo-OoyUUHju8du-Otd6vfgv_ORz-Y_PrPB0VDKbU74jYy9hjg@mail.gmail.com>    <2aa140973d7d5a320bd1402da1647a26.squirrel@webmail.iit.demokritos.gr>    <alpine.LNX.2.01.1210091753520.12373@nerf07.vanv.qr>
 <11f6603b92965503cfaef2622aaf56a0.squirrel@webmail.iit.demokritos.gr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: "Katia S." <katias@iit.demokritos.gr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:55984 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab2JIWII (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:08:08 -0400
In-Reply-To: <11f6603b92965503cfaef2622aaf56a0.squirrel@webmail.iit.demokritos.gr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-10-09 19:23, Katia S. wrote:

>Yeah, that's why I installed the development packages of both iptables and
>iptc. I'm gussing the API I need is in the iptc lib.. But still, no luck
>finding a tutorial there either.

As I said, iptables/iptc does not have anything to do with tc.


>>>Well, I have been running "tc" commands like "tc qdisc" or "tc class" to
>>>get some information I need on various devices and interfaces.
>>>
>>>Right now I need to implement the exact same feature in a program of
>>>mine, [...]
