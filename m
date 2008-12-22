From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [libnetfilter_queue 4/4] Switch documentation style to
 doxygen.
Date: Mon, 22 Dec 2008 23:08:30 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812222306080.27814@fbirervta.pbzchgretzou.qr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr> <1229722591-7836-5-git-send-email-eric@inl.fr> <494F6FB5.3090204@netfilter.org> <alpine.LNX.1.10.0812221449300.2670@fbirervta.pbzchgretzou.qr> <49500E59.1040200@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:32883 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbYLVWIb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:08:31 -0500
In-Reply-To: <49500E59.1040200@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-22 23:02, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Monday 2008-12-22 11:45, Pablo Neira Ayuso wrote:
>> 
>>> Eric Leblond wrote:
>>>> This patch modifies the documentation format to switch to doxygen
>>>> format. This leads to a interesting and useful output. An example
>>>> can be found at the following url:
>>>> 	http://www.nufw.org/doc/libnetfilter_queue/
>>> I was thinking about using kerneldoc utility, but doxygen is better at
>>> this moment. Could you also send the doxygen configuration file to put
>>> it in the git tree?
>>>
>>> Once I generate the doxygen documentation, I'm going to add it to the
>>> netfilter website.
>> 
>> I have a kerneldoc filter plugin for doxygen, if you like.
>
>I always like to get cool stuff, please don't ask next time, just post it ;)

http://dev.medozas.de/gitweb.cgi?p=hxtools;a=blob;f=libexec/doxygen-kerneldoc-filter;hb=master

and in the Doxygen file, this is all:

INPUT_FILTER = /path/to/doxygen-kerneldoc-filter

Working example in git://dev.medozas.de/circum (run `doxygen`).
