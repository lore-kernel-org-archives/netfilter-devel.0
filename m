From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Sat, 3 Jul 2004 17:33:25 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407031431.i63EVFMX001859@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


What do you exactly mean by "restarting". I just recompile my .c file that
generates a .out file and that's it. Do I have to make an exe or binary from
it or what?
I invoke the QUEUE target from the iptables commands and it looks something
like this

iptables -A OUTPUT -p icmp -j QUEUE

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
Sent: Saturday, July 03, 2004 3:17 PM
To: Muhammad R. Sami
Cc: 'Babar Qaisrani'; 'Netfilter List'
Subject: RE: information

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> Now what I mean by "once" is that whenever I queue a specific flow of
> packet to the libipq program and for example set the verdict to DROP, it
> works fine. But if I change the verdict to ACCEPT and recompile my
> program, the box still drops the packets.

Have you restarted your application?

Are you positively sure you restarted the recompiled binary?

>From where are you invoking the QUEUE target?

What does your ruleset (in iptables) look like?

Regards
Henrik
