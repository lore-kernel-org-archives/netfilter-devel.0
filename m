From: Patrick McHardy <kaber@trash.net>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Fri, 23 May 2008 14:15:30 +0200
Message-ID: <4836B562.6000302@trash.net>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <00d501c8bccb$d7922000$86b66000$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 'Thomas Jacob' <jacob@internet24.de>,
	netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33900 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYEWMPc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 08:15:32 -0400
In-Reply-To: <00d501c8bccb$d7922000$86b66000$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> Hi,
> 	I am also looking/working for same thing as something like
> "jumpset", even discussed with Patrick in last workshop regarding how to do
> it, but it looks difficult to me by just seeing at code or understanding the
> code without the overall impact.
> 	It would be nice if someone can share the idea of how to do it or
> give a lead for how to proceed.

Basically, you'd change (in ipt_do_table):

                                 int newpos = t->verdict; 


to get the new position from the target module. This probably
requires to change the target function signature. Alternatively
you could try to encode it in the verdict. Loop detection
needs some way to get all possible jumps from the target
and check each possible path. Maybe the easiest way is probably
a target built into ip_tables.c
