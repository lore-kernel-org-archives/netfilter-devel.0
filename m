From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Sun, 4 Jul 2004 17:05:53 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407041403.i64E3hMX017321@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407040958560.12749-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407040958560.12749-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am having problems in installing modules necessary for libipq (ip_queue
and iptable_filter). Now from the documentation, I found out that the kernel
should also support netlink sockets (IP_NF_QUEUE). When I add this as a
module, I can install ip_queue but cannot find the ip_nf_queue module. When
I add the netlink socket support and compile it with the kernel, I cannot
install ip_queue and receive a message stating "segmentation fault" when
running "modprobe ip_queue". 

Regarding starting and stopping the c program, this is what I do:

To start = ./a.out  
To stop = cntrl C

Is this what you meant by starting after compilation and stopping before
making any changes and recompilation? I am stuck with this libipq and QUEUE
issue for more than a week now, your help will be highly appreciated.

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
From: Henrik Nordstrom [mailto:hno@marasystems.com] 
Sent: Sunday, July 04, 2004 11:02 AM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: RE: information

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> What do you exactly mean by "stopping" because I don't even start
anything,
> I just compile the code and that is it, and that is what I do every time I
> change the code (set_verdict). As far as the iptables rule, I was simply
> testing the rule in the manpage example but for my work I have to queue
> packets at the INPUT.

You also need to start what you have compiled, if not nothing will happen. 

> Another interesting thing I just faced was that although the
> iptables_filter.o and ip_queue.o files are present in my Netfilter
directory
> (as they were compiled with the kernel), whenever I run the command
modprobe
> iptables_filter and modprobe ip_queue, it says FATAL: module not found.
When
> I run the insmod module name it say "invalid module format". Really
lost!!!

No idea, but as you can insert the QUEUE target this probably is a 
non-issue.

Regards
Henrik
