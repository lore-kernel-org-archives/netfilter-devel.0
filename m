From: Eicke Friedrich <tady@gmx.net>
Subject: Re: how to clear the conntrack table!
Date: Thu, 16 Oct 2003 09:57:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8E4F79.3010700@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again,

Patrick McHardy wrote:

> Eicke Friedrich wrote:
> 
>> Harald Welte wrote:
>> 
>>> unfortunately there is currently no other way than to unload 
>>> and reload the ip_conntrack module
>> 
>> 
>> 
>> I've tried this a couple of times. The module seems to get 
>> deleted (lsmod still shows ip_conntrack but as deleted) but rmmod
>>  does NOT finish. It grabs 100% CPU for minutes. I had to reboot 
>> the box then. Any hints?
> 
> In case your running an older kernel (before -pre9), try the latest
>  -rc kernel or
submitted/70_ip-conntrack-expect-drop-refcnt-combined.patch from
> patch-o-matic.


Not having time before I updated my box today to kernel version 2.4.22
from kernel.org. The system works still very well but I'm still not
able to unload the conntrack module. It's the same problem as I
described above using 2.4.21. So anyone there who knows an answer?
Thanks in advance.

Regards,
Eicke Friedrich

PS: Sorry Patrick for sending this message directly to you - I forgot
to change the receiver. :-(

My system:
Dual Athlon MP, 512 MB RAM
Following patches applied:
Enable NF on a bridge: ebtables-brnf-2_vs_2.4.22.diff
NETFILTER P-O-M:
Already applied: submitted/01_2.4.19
                  submitted/02_2.4.20
                  submitted/03_2.4.21
                  submitted/04_2.4.22
                  submitted/44_backport_ah_esp_fixes
                  submitted/45_masq_routing_check
                  submitted/54_ip_nat-macro-args
                  submitted/58-ip_conntrack-macro-args
                  submitted/60_nat_tftp-remove-warning
                  submitted/73_ipt_MASQUERADE-oif
                  submitted/74_nat-range-fix
                  submitted/75_REJECT_localpmtu-fix
                  submitted/76_snmp-checksum_h-fix
                  submitted/77_destroy-conntrack
                  submitted/78_nathelper-udp-csum
                  submitted/79_mangle_udp-sizecheck
                  submitted/80_ip_conntrack-proc
                  submitted/81_ipt_unclean-tcp-flag-table
                  submitted/83_nolocalout
                  submitted/84_local-nullbinding
                  submitted/86_getorigdst-tuple-zero
                  submitted/87_nat-helpers-u16
                  pending/59_ip_nat_h-unused-var
                  pending/61-remove-memsets
                  pending/64_masquerade-sameip-noflush
                  pending/69_amanda-helpers
                  pending/70_expect-evict-order
                  pending/72_recent_procfs_fix
                  base/connlimit
                  base/mport
                  base/quota
                  extra/CLASSIFY
                  extra/CONNMARK
                  extra/string
