From: Patrick McHardy <kaber@trash.net>
Subject: Re: can't change expectation: change_expect returns -1 (resend packet)
Date: Thu, 20 Nov 2003 12:56:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBCABD6.6010108@trash.net>
References: <DAELKAPIKOFAFFKELNHOAEALCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <listuser@epygi.de>
In-Reply-To: <DAELKAPIKOFAFFKELNHOAEALCAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

People can help you better if you post your code, otherwise it's just guessing around.

Regards,
Patrick


Nikolai Dahlem wrote:

> Hi,
>  
> I'm raising an expectation in conntrack and im trying to change it in 
> nat to the ip of the firewall + getting a free port, but in (almost) 
> all cases change_expect returns -1 (resend packet without the same 
> port). the odd thing is, in some cases it works ...
> I suppose I'm basically doing something plain wrong/stupid, because it 
> shouldn't be treated as a resend packet.
> I attached some snippets from my syslog, how the expectation is risen 
> in conntrack, and how it try to change it in nat.
>  
> conntrack:
> ip_conntrack_sip.c:help:expect_related 172.30.8.100:5022-0.0.0.0:0
> ip_conntrack_expect_related c280d4a0
> tuple: tuple c01fdc00: 17 0.0.0.0:0x0000 0000 -> 172.30.8.100:0xc03fd840
> mask:  tuple c01fdc20: 65535 255.255.255.255:0xffff0000 -> 
> 255.255.255.255:0x00000000
> new expectation c2b8f370 of conntrack c280d4a0
> nat:
> starting with port: 5022
>
> change_expect:
> exp tuple: tuple c2b8f3c8: 17 0.0.0.0:0x00000000 -> 
> 172.30.8.100:0xc03fd840
> exp mask:  tuple c2b8f3e8: 65535 255.255.255.255:0xffff0000 -> 
> 255.255.255.255:0x00000000
> newtuple:  tuple c01fdb58: 17 0.0.0.0:0x00000000 -> 
> 10.20.10.213:0xc03fd840
> change expect: resent packet
> ....
> <happens for all port>
> ....
> no free port found
>  
> Can anybody please shed some light on this
>  
> regards
>  
> Nikolai Dahlem
