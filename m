From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Fri, 2 Jul 2004 21:19:28 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407021820.i62IKBMX017587@madinah.ccse.kfupm.edu.sa>
References: <1088780591.40e5792fcc3a0@webmail.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Babar Qaisrani'" <baqb03@student.bth.se>
In-Reply-To: <1088780591.40e5792fcc3a0@webmail.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I got the libipq/QUEUE part working but the problem is that it only works
for the first time. For example, if I want to drop all icmp packets, it
will, but if I change the nfmark from drop to accept and then recompile my
libipq program, it does not work and the dropping policy is maintained. Same
for the other way around. 
Regards,

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

-----Original Message-----
From: Babar Qaisrani [mailto:baqb03@student.bth.se] 
Sent: Friday, July 02, 2004 6:03 PM
To: Muhammad R. Sami
Subject: RE: information

well
install the missing module !

most probably either ui have to recompile the Kernel or install module
....depending on ur Linux distro
im using Debian
I installed iptables-dev , my guess is 
i think used the default kernel settings for 2.4.26

guess looking up guides in NETFILTER web site would be good start as well!

Regards
Babar Qaisrani


Quoting "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>:

> 
> -----Original Message-----
> From: Babar Qaisrani [mailto:baqb03@student.bth.se] 
> Sent: Friday, July 02, 2004 5:23 PM
> To: Muhammad R. Sami
> Subject: RE: information
> 
> AOA
> well u do that by following 
> /locationofiptables/iptables -A Queue Name(OUTPUT|INPUT|FORWARD) -p
protocol
> name -j QUEUE
> e.g 
> /usr/sbin/iptables -A OUTPUT -p ip -j QUEUE --------- I have done this
> 
> REMEMBER do this before --------------------here I am having problems
> (FATAL: module not found)
> /sbin/modprobe iptable_filter 
> /sbin/modprobe ip_queue
> 
> hope it helps !
>  
> 
> Regards
> Babar Qaisrani
> 
> 
> Quoting "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>:
> 
> > May I know exactly how you queue your packets to the userspace
application
> > as I also want to use libipq and QUEUE but am having problems. I mailed
my
> > case earlier to the list. I am simply following the example in the
manpage
> > of libipq. But it does not seem to work.
> > Regards,
> > 
> > Muhammad R. Sami 
> > Research Assistant, 
> > Computer Engineering Department 
> > P.O.Box 354 
> > King Fahd University of Petroleum & Minerals 
> > Dhahran 31261 
> > Saudi Arabia. 
> > Tel: +96638601423 
> > Cell: +96657982951 
> > www.ccse.kfupm.edu.sa/sami
> > -----Original Message-----
> > From: netfilter-devel-admin@lists.netfilter.org
> > [mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Babar
> > Qaisrani
> > Sent: Tuesday, June 29, 2004 10:06 PM
> > To: netfilter-devel@lists.netfilter.org
> > Subject: information
> > 
> > Hello All,
> > 
> > I am developing some code using Lib IPQ and User Space queuing . i have 
> > set the Server to put incoming packets in Queue .
> > The IP ID on the IP Header i get is used as a Referance Counter.
> > My Question is : Is the IP ID in the IP Packet re numbered in IP Queue 
> > some how?
> > im sorry if this Question is answered before ..
> > 
> > Thanks
> > Babar
> > 
> > 
> > 
> > 
> 
> 
> -------------------------------------------------
> This mail sent through IMP: http://horde.org/imp/
> 
> 


-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
