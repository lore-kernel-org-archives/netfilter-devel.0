From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Wed, 14 Nov 2012 14:57:01 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211141454400.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <20121112233024.GA15215@1984> <50A257C8.8050700@earthlink.net> <alpine.DEB.2.00.1211131619040.21144@blackhole.kfki.hu> <50A291BF.70609@earthlink.net> <alpine.DEB.2.00.1211132012500.21586@blackhole.kfki.hu> <50A2B96D.5080905@earthlink.net>
 <alpine.DEB.2.00.1211140901060.4404@blackhole.kfki.hu> <50A3A747.20104@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:38403 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2KNO5P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:57:15 -0500
In-Reply-To: <50A3A747.20104@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

On Wed, 14 Nov 2012, Stephen Clark wrote:
> On 11/14/2012 03:08 AM, Jozsef Kadlecsik wrote:
>
>> Then I don't understand, what is the problem. When the reply packet is 
>> sent out over the backup line, why should the source address fall into 
>> the subnet of the outgoing interface? Unless, of course if you yourself 
>> or your backup provider prevents it by egress filtering.
>
> A lot of ISPs in the U.S. do reverse path filtering and drop packets 
> that could not originate from their provided subnet. If they did not do 
> this then of course there would be no problem.

Not just in the US. It's common here in the UK too. IMHO all ISPs should 
do this to prevent spoofing attacks, so that attacks are traceable, unless 
you have a special agreement with them to use their connection for certain 
specific other source addresses which are also traceable to you.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

