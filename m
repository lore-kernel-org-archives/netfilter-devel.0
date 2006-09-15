From: jmzhou.ml@gmail.com
Subject: Re: double-free bug and a question
Date: Fri, 15 Sep 2006 10:35:21 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609151009060.623@mariner.cs.ucdavis.edu>
References: <Pine.LNX.4.64.0609141621400.27445@mariner.cs.ucdavis.edu>
	<450A2B12.4010503@trash.net>
Reply-To: Jingmin Zhou <zhouji@cs.ucdavis.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <450A2B12.4010503@trash.net>
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

Thanks for the information.

As you said, for a simple range in either source or destination port,
multiport is not needed. However, iptables allows me to specify either
--sports or --dports or --ports with a simple range. Anyway, this 
detail is not important to my question.

My question is actually different from the crash example. I have a set
of source ports (e.g., 53, 55, 57) and a set of destination ports (e.g.,
1023, 1025, 1027). They are different sets. How can I specify both sets
in a single iptables rule? That means I want to match a packet that has
a source port of 53, 55 or 57 and a destination port of 1023, 1025 or
1027? As the manual says, it seems --ports is not the option for me.

Here's the stack backtrace, hope it helps. I'm running the command on
Slackware -current (11.0rc) with kernel 2.6.16.18.

(gdb) run -A INPUT --protocol udp -m multiport --dports 65530:65535 -m multiport --sport 53:67 -j ACCEPT
Starting program: /usr/sbin/iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m multiport --sport 53:67 -j ACCEPT
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
*** glibc detected *** double free or corruption (!prev): 0x08055160 ***

Program received signal SIGABRT, Aborted.
0xb7e67847 in raise () from /lib/tls/libc.so.6
(gdb) where
#0  0xb7e67847 in raise () from /lib/tls/libc.so.6
#1  0xb7e690d9 in abort () from /lib/tls/libc.so.6
#2  0xb7e9b616 in __libc_message () from /lib/tls/libc.so.6
#3  0xb7ea1d4f in _int_free () from /lib/tls/libc.so.6
#4  0xb7ea20ea in free () from /lib/tls/libc.so.6
#5  0x0804c327 in clear_rule_matches ()
#6  0x0804d759 in do_command ()
#7  0x08049d10 in main ()



On Fri, 15 Sep 2006, Patrick McHardy wrote:

> jmzhou.ml@gmail.com wrote:
>> Apology if this has been reported. Here's the way to reproduce the crash:
>>
>> # iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m
>> multiport --sport 53:67 -j ACCEPT
>> *** glibc detected *** double free or corruption (!prev): 0x08055160 ***
>> Abort (core dumped)
>>
>> # iptables -A INPUT --protocol udp -m multiport --dports 65530:65535 -m
>> multiport --sports 53:67 -j ACCEPT
>> Bad argument `53:67'
>> Try `iptables -h' or 'iptables --help' for more information.
>>
>> $ iptables --version
>> iptables v1.3.5
>>
>>
>> What I want to do is to define multiple ports for both source and
>> destination in a single iptables rule. Is there any way to do it?
>> Thanks!
>
> Read the help for multiport, the ports are given as comma-seperated
> list. For simple ranges you don't need multiport. For source and
> destination you must only specify "-m multiport" once.
>
> I have no idea where the crash comes from (works fine here). Please
> try to get a backtrace by running the command in gdb:
>
> gdb iptables
>
> (gdb) run -A INPUT ...
> <crash>
> (gdb) backtrace
>

____________________________________________________________
The future is not set.  There is no fate but what we make
for ourselves.             - Terminator II, Judgement Day
