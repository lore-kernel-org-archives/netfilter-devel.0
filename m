From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Thu, 08 Nov 2007 14:32:17 +0100
Message-ID: <47330FE1.9020008@trash.net>
References: <1194525620.6845.5.camel@ierdnac>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: andrei.popa@i-neo.ro
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59912 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbXKHNcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 08:32:50 -0500
In-Reply-To: <1194525620.6845.5.camel@ierdnac>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Andrei Popa wrote:
> Please CC as i am not subscribed to the list.
> I-m using 2.6.22.9 and when I tried to insert this line it gave the
> oops:
> 
> $IPT -I INPUT -p tcp --dport 80 -m string --algo bm --string "$MyNick"
> -j DROP
> I have iptables v1.3.8
> 
> BUG: unable to handle kernel paging request at virtual address e0000000
>  printing eip:
> c01e2707
> *pde = 00000000
> Oops: 0000 [#1]
> CPU:    0
> EIP:    0060:[<c01e2707>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.22.9-iteyeb11 #8)
> EIP is at bm_init+0xd7/0x210


Works fine here. Is the oops reproducible?

EFLAGS: 00010286   (2.6.22.9-iteyeb11 #8)
                              ^^^^^^^^

Does this include additional patches? Otherwise please post your
config and the lib/ts_bm.o file.

