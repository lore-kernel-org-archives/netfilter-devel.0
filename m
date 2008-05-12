From: Patrick McHardy <kaber@trash.net>
Subject: Re: CAN you give me a piece of sample code to implement this iptablescommand?
 thanks
Date: Mon, 12 May 2008 17:59:05 +0200
Message-ID: <48286949.5000503@trash.net>
References: <200805112243513753221@fiberhome.com.cn> <200805112347000787949@fiberhome.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: cyx <cyx@fiberhome.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47076 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYELP7m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 11:59:42 -0400
In-Reply-To: <200805112347000787949@fiberhome.com.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cyx wrote:
> So there is no APIs we can use to manipulate the kernel's iptables, except invoking the "iptables" command from shell? so wired, it should be have some APIs to do the same as the "iptables" does.          

Unfortunately not, at least not for C. There is a perl-API,
but I forgot its name.
