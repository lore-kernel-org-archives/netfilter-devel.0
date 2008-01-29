From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
Date: Tue, 29 Jan 2008 14:04:26 +0100
Message-ID: <479F245A.2030509@trash.net>
References: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54427 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbYA2NUZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:20:25 -0500
In-Reply-To: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> this patch was previously unmerged because it conflicted with Eric 
> Dumazet's changes. I now rediffed it; please apply.


This adds a huge number of sparse warnings, please fix those up.
I already fixed those in your other recent patches, but please
make sure all patches you submit are sparse warning free.

net/netfilter/xt_hashlimit.c:480:17: warning: incorrect type in argument 
1 (different base types)
net/netfilter/xt_hashlimit.c:480:17:    expected unsigned int [unsigned] 
[usertype] a
net/netfilter/xt_hashlimit.c:480:17:    got restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: incorrect type in return 
expression (different base types)
net/netfilter/xt_hashlimit.c:469:9:    expected unsigned int
net/netfilter/xt_hashlimit.c:469:9:    got restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:480:8: warning: incorrect type in 
assignment (different base types)
net/netfilter/xt_hashlimit.c:480:8:    expected restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:480:8:    got unsigned int
net/netfilter/xt_hashlimit.c:487:17: warning: incorrect type in argument 
1 (different base types)
net/netfilter/xt_hashlimit.c:487:17:    expected unsigned int [unsigned] 
[usertype] a
net/netfilter/xt_hashlimit.c:487:17:    got restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: incorrect type in return 
expression (different base types)
net/netfilter/xt_hashlimit.c:469:9:    expected unsigned int
net/netfilter/xt_hashlimit.c:469:9:    got restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:487:8: warning: incorrect type in 
assignment (different base types)
net/netfilter/xt_hashlimit.c:487:8:    expected restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:487:8:    got unsigned int
net/netfilter/xt_hashlimit.c:494:17: warning: incorrect type in argument 
1 (different base types)
net/netfilter/xt_hashlimit.c:494:17:    expected unsigned int [unsigned] 
[usertype] a
net/netfilter/xt_hashlimit.c:494:17:    got restricted unsigned int 
[usertype] <noident>
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: cast to restricted type
net/netfilter/xt_hashlimit.c:469:9: warning: too many warnings
