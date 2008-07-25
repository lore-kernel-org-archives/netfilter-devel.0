From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 25 Jul 2008 09:51:53 +0100
Message-ID: <48899429.6090209@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net> <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46703 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753187AbYGYIv4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:51:56 -0400
In-Reply-To: <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
>>> Patrick McHardy wrote:
>>>> The module reference stuff (module_put/nf_ct_*_find_get etc)
>>>> is clearly superfluous, this runs in packet processing context
>>>> and shouldn't use module references but RCU.
> 
> Ok, I did what you said. You find the patch below. Is this what you
> mean? If yes, I'll give it a try...


I applied the patch and did the test. The effect of removing unnecessary 
locks reduced the CPU usage by one percent (packet rates verified to be 
comparable this time).

It's up to you to decide if making the code less nice (IMHO) is worth 
saving 1% CPU usage under rare circumstances.
