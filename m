From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Sat, 3 Jul 2004 20:26:55 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407031724.i63HOiMY003811@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407031644310.31194-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407031644310.31194-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

What do you exactly mean by "stopping" because I don't even start anything,
I just compile the code and that is it, and that is what I do every time I
change the code (set_verdict). As far as the iptables rule, I was simply
testing the rule in the manpage example but for my work I have to queue
packets at the INPUT.
Another interesting thing I just faced was that although the
iptables_filter.o and ip_queue.o files are present in my Netfilter directory
(as they were compiled with the kernel), whenever I run the command modprobe
iptables_filter and modprobe ip_queue, it says FATAL: module not found. When
I run the insmod module name it say "invalid module format". Really lost!!!
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
Sent: Saturday, July 03, 2004 5:46 PM
To: Muhammad R. Sami
Subject: RE: information

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> What do you exactly mean by "restarting". I just recompile my .c file that
> generates a .out file and that's it. Do I have to make an exe or binary
from
> it or what?

No, but you have to stop the old binary and start the new one...

> I invoke the QUEUE target from the iptables commands and it looks
something
> like this
> 
> iptables -A OUTPUT -p icmp -j QUEUE

Any other OUTPUT rules before this?

Regards
Henrik
