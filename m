From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: pom-20040409: patches that break iptables-1.2.9-20040409, kernel
 2.4.25 or pom's runme
Date: Sun, 11 Apr 2004 13:15:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407928B7.6040505@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Harald Welte <laforge@netfilter.org>,
	Gerd Knorr <kraxel@bytesex.org>, Tommi Virtanen <tv@debian.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi netfilter team!

*persons responsible for each individual breaking patch CC'd*

I want to inform you that the following patches in pom-20040409,
which btw apply cleanly to the kernel 2.4.25, do break the
compilation of iptables-1.2.9-20040409:

   1) base/set
        a "make" of iptables does not even succeed to
        create the dependencies, message
          "Something wrong... deleting dependencies."

   2) base/dstlimit
        breaks the extension in iptables - see log below

   3) base/osf
        breaks the extension in iptables - see log below

Patches that break kernel 2.4.25 compile:

   4) base/connlimit
        undefined variable used for locking
        fix availabl will be posted to the list soon

Patches that break pom's runme, so that it can not continue with
other patches:

   5) submitted/61_nulldev_alignment
        seems to be already in 2.4.25 but not in the same form as
        this patch.
        Is it ok with you if I submit a patch that matches kernel
        2.4.25? Tommi Virtanen can you please look at this and tell
        me if your patch is the same as what is already included in
        kernel 2.4.25!

Hope you can fix that.

PS: PLEASE for those people who are on netfiler-devel please respond
TO THE LIST ONLY. Thanks!

---------------------------------------------------------------------------
---------------------------------------------------------------------------
LOG for 2)

Extensions found: IPv4:IPV4OPTSSTRIP IPv4:NETLINK IPv4:addrtype 
IPv4:condition IPv4:dstlimit IPv4:fuzzy IPv4:ipv4opti
ons IPv4:mport IPv4:nth IPv4:pool IPv4:POOL IPv4:psd IPv4:quota IPv4:random 
IPv4:recent IPv4:time IPv4:u32 IPv6:REJEC
T IPv6:ah IPv6:esp IPv6:frag IPv6:fuzzy IPv6:ipv6header IPv6:nth IPv6:hbh 
IPv6:dst IPv6:random IPv6:rt
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ 
-DIPTABLES_VERSION=\"1.2.9-20040409\"  -fPIC -o extensions/
libipt_dstlimit_sh.o -c extensions/libipt_dstlimit.c
extensions/libipt_dstlimit.c: In function `init':
extensions/libipt_dstlimit.c:104: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:105: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:106: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c: In function `parse':
extensions/libipt_dstlimit.c:138: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:152: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:163: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:173: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:185: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:196: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:204: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:207: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:209: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:212: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c: In function `print':
extensions/libipt_dstlimit.c:278: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:279: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:280: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:294: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:295: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:296: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:297: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:298: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:298: error: `IPT_DSTLIMIT_GCINTEVAL' 
undeclared (first use in this function)
extensions/libipt_dstlimit.c:298: error: (Each undeclared identifier is 
reported only once
extensions/libipt_dstlimit.c:298: error: for each function it appears in.)
extensions/libipt_dstlimit.c:299: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:300: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:301: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c: In function `save':
extensions/libipt_dstlimit.c:310: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:311: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:312: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:313: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:327: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:328: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:329: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:330: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:331: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:332: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:333: error: structure has no member named `cfg'
extensions/libipt_dstlimit.c:334: error: structure has no member named `cfg'
make: *** [extensions/libipt_dstlimit_sh.o] Error 1

---------------------------------------------------------------------------
---------------------------------------------------------------------------
LOG for 3)

Extensions found: IPv4:IPV4OPTSSTRIP IPv4:NETLINK IPv4:addrtype 
IPv4:condition IPv4:fuzzy IPv4:ipv4options IPv4:mport
  IPv4:nth IPv4:osf IPv4:pool IPv4:POOL IPv4:psd IPv4:quota IPv4:random 
IPv4:recent IPv4:time IPv4:u32 IPv6:REJECT IPv
6:ah IPv6:esp IPv6:frag IPv6:fuzzy IPv6:ipv6header IPv6:nth IPv6:hbh 
IPv6:dst IPv6:random IPv6:rt
[...]
cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/ 
-DIPTABLES_VERSION=\"1.2.9-20040409\"  -fPIC -o extensions/
libipt_osf_sh.o -c extensions/libipt_osf.c
extensions/libipt_osf.c: In function `parse':
extensions/libipt_osf.c:106: error: `IPT_OSF_NETLINK' undeclared (first use 
in this function)
extensions/libipt_osf.c:106: error: (Each undeclared identifier is reported 
only once
extensions/libipt_osf.c:106: error: for each function it appears in.)
make: *** [extensions/libipt_osf_sh.o] Error 1

---------------------------------------------------------------------------
---------------------------------------------------------------------------
patches which pom lists as applied:
                  submitted/01_2.4.19
                  submitted/02_2.4.20
                  submitted/03_2.4.21
                  submitted/04_2.4.22
                  submitted/05_2.4.23
                  submitted/06_2.4.23_core_changes
                  submitted/59_ip_nat_h-unused-var
                  submitted/60_ecn_raw_unclone
                  submitted/61-remove-memsets
                  submitted/64_masquerade-sameip-noflush
                  submitted/69_amanda-helpers
                  submitted/70_expect-evict-order
                  submitted/72_recent_procfs_fix
                  submitted/74_listhelp
                  submitted/75_selective_cleanup
                  submitted/76_conntrack_bucket_sysctl
                  submitted/88_ip_queue-maxlen
                  submitted/89_ipv6_mld_netfilter
                  submitted/90_fw_compat_local-nullbinding
                  submitted/91_listhelp_fix
                  pending/40_nf-log
                  pending/40_nf-log-ipv6
                  pending/62_masquerade-oif
                  pending/92_redirect-indev-locking
                  optimizations/ip_ct_refresh_optimization
                  optimizations/ip_ct_refresh_optimization_pptp
                  base/HL-ipv6
                  base/IPV4OPTSSTRIP
                  base/NETLINK
                  base/NETMAP
                  base/REJECT-ipv6
                  base/SAME
                  base/TTL
                  base/connlimit
                  base/fuzzy
                  base/fuzzy6-ipv6
                  base/iprange
                  base/ipv4options
                  base/mport
                  base/nth
                  base/nth6-ipv6
                  base/pool
                  base/psd
                  base/quota
                  base/random
                  base/random6-ipv6
                  base/raw
                  base/realm
                  base/time
                  base/u32
                  extra/CLASSIFY
                  extra/CONNMARK
                  extra/addrtype
                  extra/condition
                  extra/h323-conntrack-nat
                  extra/ipt_TARPIT
                  extra/mms-conntrack-nat
                  extra/pptp-conntrack-nat
                  extra/quake3-conntrack
                  extra/rpc
                  extra/rtsp-conntrack
                  extra/talk-conntrack-nat
---------------------------------------------------------------------------
---------------------------------------------------------------------------

PS: If it makes a difference, everything that can be compiled as module was 
selected to be compiled as module

-- 
MfG / Regards
Friedrich Lobenstock
