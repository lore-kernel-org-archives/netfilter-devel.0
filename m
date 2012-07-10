From: Alex Bligh <alex@alex.org.uk>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Tue, 10 Jul 2012 17:27:59 +0100
Message-ID: <E33FE2CD2A549167CCF7D2E9@Ximines.local>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
 <4FF02A93.8080603@googlemail.com>
 <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu>
 <4FF04038.4080306@googlemail.com>
 <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
 <4FF04647.7060807@googlemail.com>
 <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu>
 <4FF04DDA.3020609@googlemail.com>
 <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu>
 <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz>
 <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
Reply-To: Alex Bligh <alex@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Alex Bligh <alex@alex.org.uk>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.avalus.com ([89.16.176.221]:50185 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab2GJQeU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:34:20 -0400
In-Reply-To: <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



--On 2 July 2012 09:54:20 +0200 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> 
wrote:

> - my view follows how the subsytem sees the interfaces
>
>                              ------------------
>   pkt comes in --- interface | ipset subsytem | interface --- pkt goes out
>                            ^ ------------------ ^
>                        source               destination

I have no comment on the back compatibility issue, but from a clean sheet
these interfaces should probably be called "ingress" and "egress"
interfaces (or, if you must 'input' and 'output' but those are ripe for
confusion with iptables rules). If those aren't the terms in the RFCs, they
are certainly terms of art commonly used by router vendors.

>From my point of view, the current nomenclature is better than reversing
them (as I think is being proposed), but they are confusing in the case of
forwarded traffic where neither interface might be the 'source' or
'destination' in an IP sense. Swapping them would cause more confusion.

-- 
Alex Bligh
