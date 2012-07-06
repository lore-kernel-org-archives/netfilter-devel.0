From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 20:21:25 +0100
Message-ID: <4FF73AB5.4060502@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.LNX.2.01.1207062110260.6477@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33699 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GFTVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:21:34 -0400
Received: by wgbdr13 with SMTP id dr13so9596236wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 12:21:33 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207062110260.6477@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The SO version is purely a userspace issue. Here, Joszef means the 
> user-kernel interaction; a too-old userspace ipset binary would not know 
> how to interpret a too-new kernel response which has IFACE set; and a 
> too-old kernel would not know how to read a too-new ipset request with 
> IFACE set.
>   
If you look more careful at the patches I submitted yesterday, you will 
find out that the changes I have made to ipset (userspace) are 
negligible and have nothing whatsoever to do with the changes I have 
proposed in these patches.

Whether one uses the old ipset (userspace) or the new one won't matter 
one jot for the purpose of these changes!

