From: dmorris <dmorris@metavize.com>
Subject: Re: bug: -j REDIRECT broken with bridge in 2.6.0-test3
Date: Mon, 25 Aug 2003 16:24:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4A9AA7.2070604@metavize.com>
References: <3F3AEDEF.2000108@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3F3AEDEF.2000108@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Does anyone have *any* idea where I could look to start solving this?
Can anyone confirm?
It is still present in 2.6.0-test4 on my test machines.

Thanks!
-dirk

dmorris wrote:

> bug: -j REDIRECT broken with bridge in 2.6.0-test3
>
> Sorry if this has already been reported, well known,
> or I'm doing something obviously wrong.
> Please email me if I can help, or give any other info.
>
> [1.] One line summary of the problem:   
>    -j REDIRECT does not work with a bridge in 2.6.0-test3
>
> [2.] Full description of the problem/report:
>
>    -j REDIRECT --to-port 2000 works fine as a router, but not as a bridge
>    this appeared sometime between 2.5.68 and 2.6.0-test3
>
>    WORKING EXAMPLE:
>    (A) <-----> (B) <-----> (C)
>
>    where A is 10.0.0.10 and C is 10.10.10.10
>    and B's left  interface is 10.0.0.0/255.255.255.0
>    and B's right interface is 10.10.10.0/255.255.255.0
>    with echo 1 >proc/sys/net/ipv4/ip_forward
>
>    On: B do the following
>    iptables -t nat -A PREROUTING -p tcp --destination-port 7:7 -j 
> REDIRECT --to-port 2000
>    netcat -l -p 2000
>
>    Then on C:
>    telnet (A) 7
>    <connects to netcat on B as expected>
>
>    NON-WORKING EXAMPLE:
>    (A) <-----> (B) <-----> (C)
>
>    where A is 10.0.0.10 and C is 10.0.0.020
>    and B is a bridge of IP 10.0.0.15
>
>    On: B do the following
>    iptables -t nat -A PREROUTING -p tcp --destination-port 7:7 -j 
> REDIRECT --to-port 2000
>    netcat -l -p 2000
>
>    Then on C:
>    telnet (A) 7
>    Connecting ...
>
>    The SYN just seems to get dropped somewhere.
>    The SYN does not reach A (according to tcpdump)
>
>
> [3.] Keywords (i.e., modules, networking, kernel):
>
>    networking, netfilter, ethernet bridge
>
> [4.] Kernel version (from /proc/version):
>
>    Linux version 2.6.0-test3 (dmorris@bebe) (gcc version 3.3.1 
> 20030626 (Debian prerelease)) #2 Wed Aug 13 12:59:35 PDT 2003
>
> [5.] Output of Oops.. message (if applicable) with symbolic information
>     resolved (see Documentation/oops-tracing.txt)
>
>    None
>
> [6.] A small shell script or example program which triggers the
>     problem (if possible)
>
>    Refer to above
>
> [7.] Environment
>
>    The middle machine is described in depth at:
>
>    http://neogenen.com/bugreport_details2.txt
>
>
