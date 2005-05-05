From: <iosif.peterfi@fortesys.ro>
Subject: connlimit patch for 2.6.11
Date: Thu, 5 May 2005 21:24:26 +0300
Message-ID: <1352.57867300442$1115317040@news.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-bd-boundary-iQxG5y57UUwFV1Pg"
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

This is a multipart message in MIME format,
containing the original message body
and a footer added by BitDefender

--=-bd-boundary-iQxG5y57UUwFV1Pg
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

 

            I have downloaded the latest snapshot pom-20050504.

I have applied the kernel patch for connlimit and seems I'm going into a
race conditin.

I don't know how to capture the screen on kernel panic but here is some of
the last messages:

........

irq_ext+0x3b/0x40

do_IRQ+0x59/0x80

common_interrupt+0x1a/0x20

default_idle+0x23/0x30

cpu_idle.......

start_kernel.....

unknown_bootoption..........

.....

Code: 43 17 89 d9 8d 04 ........

 

<0>Kernel panic - not syncing: Fatal exception in interrupt

 

The kernel panic doesn't happen when probing the connlimit module, only
after inserting the rules in the table ( with iptables ).

 

Machine runs Kernel - 2.6.11-gentoo-r6 + various pom patches compiled as
modules and Iptables v1.3.1  .

            

# cat /proc/modules (without connlimit)

sch_sfq 6016 6 - Live 0xf88bf000

ipt_tos 2432 1 - Live 0xf889d000

ipt_helper 3200 3 - Live 0xf8898000

ipt_connbytes 2432 18 - Live 0xf8896000

ipt_CLASSIFY 2944 203 - Live 0xf88bb000

ipt_length 2560 8 - Live 0xf88bd000

sch_esfq 6784 6 - Live 0xf889a000

sch_htb 17536 2 - Live 0xf88a6000

ipt_REDIRECT 3072 3 - Live 0xf888d000

iptable_mangle 3328 1 - Live 0xf881c000

iptable_nat 23868 2 ipt_REDIRECT, Live 0xf889f000

ipt_REJECT 6656 8 - Live 0xf8880000

ipt_limit 3072 29 - Live 0xf888b000

ipt_state 2560 4 - Live 0xf881e000

ip_conntrack 50440 3 ipt_helper,iptable_nat,ipt_state, Live 0xf88ad000

ipt_LOG 7680 15 - Live 0xf8893000

ipt_ULOG 8196 12 - Live 0xf888f000

iptable_filter 3328 1 - Live 0xf8879000

ip_tables 25088 14
ipt_tos,ipt_helper,ipt_connbytes,ipt_CLASSIFY,ipt_length,ipt_

REDIRECT,iptable_mangle,iptable_nat,ipt_REJECT,ipt_limit,ipt_state,ipt_LOG,i
pt_U

LOG,iptable_filter, Live 0xf8883000

ipv6 246304 14 - Live 0xf88c3000

e100 34560 0 - Live 0xf886f000

#

 

If you can't figure out how to fix this, maybe I'll figure out how to take a
console dump.

 

Best Regards,

 

Iosif Peterfi.


--=-bd-boundary-iQxG5y57UUwFV1Pg
Content-Type: text/plain; name="BitDefender.txt"
Content-Disposition: inline; filename="BitDefender.txt"


-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/

--=-bd-boundary-iQxG5y57UUwFV1Pg--
