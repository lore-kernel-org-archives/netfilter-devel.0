From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: UDP checksum problems after switching from kernel 2.4 to 2.6
Date: Fri, 17 Dec 2004 16:48:52 +0100
Message-ID: <008101c4e44f$e8adcc70$6c2813ac@in.edm.luc.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I have written a libipq application that accepts QUEUEd packets from 
userspace, checks them, and subsequently decides what to do with them. I 
often change stuff inside a packet and then reinject it in the kernel 
through ACCEPT. More specifically, I only need to do this for UDP packets. 
As stated on the netfilter homepage, the checksum of a modified packet must 
be recomputed before it is reinjected into kernelspace. So, every time I 
change the content of a QUEUEd UDP packet, I recompute the IP checksum. 
However, I just set the UDP checksum to 0 to save computation power.

This all worked fine on kernel version 2.4. However, I have just upgraded to 
kernel 2.6, and all of a sudden my application doesn't work anymore. 
Although I manually set the UDP checksum to 0 in my libipq userspace 
application, the UDP packet arrives at its destination with an incorrect UDP 
checksum. As a result, the UDP packet is dropped by the network stack of the 
receiving machine. Is this an issue in kernel 2.6? In other words, do I need 
to recalculate the UDP checksum in order to garantuee correct execution of 
my application? Also, if this is the case, does anyone know an efficient 
algoritm for this?

Thanks in advance for your help.

Kinds regards,
Maarten Wijnants

--

Maarten Wijnants
Expertisecentrum voor Digitale Media
Limburgs Universitair Centrum
Wetenschapspark 2 - 3590 Diepenbeek
Tel: +32 (0)11 268419 - Mobile: +32 (0)497 341848
E-mail: maarten.wijnants@luc.ac.be
URL: http://edm.luc.ac.be 
