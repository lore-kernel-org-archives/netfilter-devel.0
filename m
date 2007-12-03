From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Mon, 03 Dec 2007 09:07:51 +0100
Message-ID: <4753B957.2000207@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57720 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbXLCIID (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:08:03 -0500
In-Reply-To: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> HI guys , i don`t know if this is the right list , but i could not
> find help anywhere else.
> I am having a very strange problem with my machine , i can not use
> iptables at all.
> I have the modules compiled and loaded but i always get :
> 
> # iptables -L
> iptables v1.3.6: can't initialize iptables table `filter': Bad file descriptor
> Perhaps iptables or your kernel needs to be upgraded.
> 
> 
> My machine is a ARM machine with debian 4.0.
> I also have already tried 1.3.8 and got the same error.


Which kernel version (please also send .config)? Did you compile
iptables yourself or used a version from Debian?

