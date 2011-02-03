From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-6.0 released
Date: Thu, 3 Feb 2011 13:59:17 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102031353130.31387@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 6.0, a new milestone of the tool. Here follows 
the list of the changes since the previous release:

Kernel part changes:
 - Reorganized kernel/ subdir
 - netfilter: ipset: fix linking with CONFIG_IPV6=n (Patrick McHardy)
 - netfilter: ipset: send error message manually
 - netfilter: ipset: add missing break statemtns in 
   ip_set_get_ip_port() (Patrick McHardy)
 - netfilter: ipset: add missing include to xt_set.h (Patrick McHardy)
 - netfilter: ipset: remove unnecessary includes (Patrick McHardy)
 - netfilter: ipset: use nla_parse_nested() (Patrick McHardy)
 - Separate ipset errnos completely from system ones and bump protocol
   version
 - Use better error codes in xt_set.c
 - Fix sparse warning about shadowed definition
 - bitmap:ip type: flavour specific adt functions (Patrick McHardy's 
   review)
 - bitmap:port type: flavour specific adt functions (Patrick McHardy's
   review)
 - Move the type specifici attribute validation to the core
   (suggested by Patrick McHardy)
 - Use vzalloc() instead of __vmalloc() (Eric Dumazet, Patrick McHardy)
 - Use meaningful error messages in xt_set.c (Patrick McHardy's review)
 - Constified attribute cannot be written (Patrick McHardy's review)
 - Send (N)ACK at dumping only when NLM_F_ACK is set
   (Patrick McHardy's review)
 - Correct the error codes: use ENOENT and EMSGSIZE (Patrick McHardy's
   review)

Userspace changes:
 - Print protocol version together with ipset version
 - Testsuite compatibility with debugging enabled
 - Allow "new" as a commad alias to "create"
 - ipset: improve command argument parsing (Holger Eitzenberger)
 - ipset: avoid the unnecessary argv[] loop (Holger Eitzenberger)
 - ipset: pass ipset_arg argument pointer (Holger Eitzenberger)
 - Separate ipset errnos completely from system ones and bump protocol
   version
 - Fix the spelling error fix :-) (Ferenc Wagner)
 - Resolving IP addresses did not work at listing/saving sets, fixed
 - ipset: fix spelling error (Holger Eitzenberger)
 - ipset: fix the Netlink sequence number (Holger Eitzenberger)
 - ipset: turn Set name[] into a const pointer (Holger Eitzenberger)
 - Check ICMP and ICMPv6 with the set match and target in the testsuite
 - Avoid possible syntax clashing at saving hostnames

Please note, due to the protocol changes and the error number 
reorganization, ipset 5.x and ipset 6.x are not compatible, i.e. user and 
kernel parts cannot be mixed: those have to come from the same release.

You can download the source code from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
