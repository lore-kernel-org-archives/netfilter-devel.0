From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 06 Oct 2008 12:09:30 +0200
Message-ID: <48E9E3DA.9020706@trash.net>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu> <20081005.132850.34376215.davem@davemloft.net> <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net> <Pine.LNX.4.64.0810060916360.18011@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYJFKJg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:09:36 -0400
In-Reply-To: <Pine.LNX.4.64.0810060916360.18011@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Mon, 6 Oct 2008, Patrick McHardy wrote:
> 
>> Jozsef Kadlecsik wrote:
>>> If restructuring is on the way, then it should cover all possible parts.
>>> Just my quick thoughts, with suggested module names:
>>> mark modules, targets in one module (route):
>>> 	connmark, mark, realm
>>> 	CLASSIFY, CONNMARK, MARK
>> CONNMARK and connmark needs to be separated from MARK etc. because
>> they depend on the conntrack module.
> 
> They can go into a single file and linked to the "route" module iff 
> NF_CONNTRACK was selected.
> 
> The same may be applied for other cases as well: it is not needed to force 
> everything into a huge file. ;-)

But then we still have the individual files in the directory.
I don't think we should combine files based on config options
but by actually moving the code into a new file.
