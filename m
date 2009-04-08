From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: full_cone_nat
Date: Wed, 08 Apr 2009 18:04:06 +1200
Message-ID: <49DC3E56.7010807@treenet.co.nz>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr> <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com> <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com> <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu> <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:34316
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZDHFL5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:11:57 -0400
In-Reply-To: <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-04-07 20:16, Jozsef Kadlecsik wrote:
>> On Tue, 7 Apr 2009, Hugo Miguel Mendes wrote:
>>
>>> What I mean with Full Cone NAT is the following:
>>> [...]
>> I answered you on Thu, 2 Apr 2009 when you asked the same question on
>> the netfilter mailing list. The answer hasn't changed since then: 
>> currently there's no way to create full cone NAT.
>>
>> It might be possible to write a new full cone NAT target by creating 
>> wildcard expectations.
> 
> Yeah there is a case where cone nat does not quite work. Assuming there
> are the following mappings:
> 
> origsrc=192.168.17.2 origdst=80.10.20.30 replsrc=134.98.76.54 repldst=80.10.20.30
> origsrc=192.168.17.3 origdst=80.20.30.40 replsrc=134.98.76.54 repldst=80.20.30.40
> 
> Then there is no way to ambiguously map incoming IP_CT_NEW connections
> for 134.98.76.54 to an origsrc.

You are right when IP-only tests are considered. The joy of full cone 
NAT requires ports to be added to that equation.

The NAT algorithm must be adapted to ensure every outbound 
src-ip:src-port combo sent to the Net is completely unique and replies 
from any ip to that particular sending port cone back to the unique 
internal machine that opened it.

For your case origsrc-ip:origdst-ip:origdst-port tuplets are different.

/2c

AYJ

