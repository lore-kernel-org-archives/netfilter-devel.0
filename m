From: Florian Zwoch <zwoch@backendmedia.com>
Subject: Re: why does netfilter make upload very slow?
Date: Wed, 15 Oct 2003 12:50:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8D2663.6020800@backendmedia.com>
References: <20031008153237.GC25743@sunbeam.de.gnumonks.org> <3F8D0542.1060101@backendmedia.com> <20031015094805.GH9880@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031015094805.GH9880@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> So It's clearly the connection tracking subsystem.  This is on one hand
> good (because it means it's neither netfilter nor iptables).  
> 
> On the other hand, this is definitely way worse than you would expect.
> Can you please tell me more information about:
> 
> - number of connections you have? (cat /proc/net/ip_conntrack | wc -l)

returns 3 in my 'as is' state. and raises to up to 8 while scp-ing a 
test file to another machine.

> - number of buckets and ip_conntrack_max (printed at ip_conntrack
>   loadtime

Oct 15 12:25:38 [kernel] ip_conntrack version 2.1 (4095 buckets, 32760 
max) - 300 bytes per conntrack

> - your traffic pattern.  Are you spraying udp packets with random
>   src/dst? What kind of connections (protocol, application) are you
>   testing with?

no i am not doing anything ugly with this machine. it is my personal 
workstation where i try to get my work done and learn more about linux 
and development.

my main tests were scp, but this behaviuor is similar on ftp and smb. i 
also have problems with irc dcc (more on that later on).

> - what about the hardware (cpu, memory, smp?)
> 

Intel(R) Pentium(R) 4 CPU 2.40GHz on an Asus P4T533 (i850e) with 512MB 
RDRAM.

no smp/ht whatever. simple single processor with decent hardware.

> Even the worst tests we've had so far (random UDP packets) 'only'
> reduced the througput by about 50%.   Maybe we can do better than 50%
> worst case behaviour, but you will always observe a visible impact as
> soon as you start connection tracking for every single packet (which is
> what 'insmod ip_conntrack' implies).

sure we do.. but i hope in normal operation it wont choke with 8 
connection :-)

> 
> Have you observed this behaviour with other kernel versions?  Was there
> a performance change between 2.4 and 2.6?  Or did you always observe
> this grave performance loss?
> 

when used 2.4 i cant remember to have any problems. i played a bit with 
netfilter and everything worked as expected. i dont know if there was a 
secret hickup i dont know of.

then i tried using the 2.6.0 series as of test1. again i think 
everything was working great. i went through almost all the major test 
releases (copied .config and checked if nothing serious got broken in 
menuconfig) and suddenly discovered that my irc dcc sends were almost 
broken (0.1k/s). what was the time i began to look into that and noticed 
that problem with the nic's performance. i *think* this dcc bug was 
introduced in the switch from test3 to test4.

again this is not 100% proven but the best i could remember now. if you 
need me to test an older kernel version again please let me know. i 
think i can spend some time here and then helping to fix this problem.

p.s. please put me into cc in your reply as im not yet on the list.

regards,
-- 
Florian Zwoch
zwoch@backendmedia.com
_______________________________
   BackendMedia
   www.backendmedia.com
   berlin@backendmedia.com

   Linn Zwoch Smith GbR
   Pariser Str. 44
   D-10707 Berlin

   Tel +49 30 83 22 50 00
   Fax +49 30 83 22 50 07
