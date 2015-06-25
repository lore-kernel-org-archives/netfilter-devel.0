From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.25.1 released
Date: Thu, 25 Jun 2015 11:36:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506251126100.7115@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54267 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbbFYJgt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 05:36:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.25.1 (and 6.25): 6.25.1 contains an 
initialization fix over 6.25 to support gcc-4.4.4 and below.

The new release contains a couple of important bugfixes, supports 
to list the element counter for the sets, include a couple of small 
corrections, cleanups. Please upgrade from former releases.

Changes in 6.25.1:

Userspace changes:
  - ipset manpage: refer to iptables-extensions
  - Update userspace header file from the kernel tree
  - Handle 'extern "C" {' in check_libmap.sh

Kernel part changes:
  - net/netfilter/ipset: work around gcc-4.4.4 initializer bug
    (Andrew Morton)

Changes in 6.25:

Userspace changes:
  - Add element count to all set types header
  - Add element count to hash headers (Eric B Munson)
  - Support linking libipset to C++ programs (reported by Pavel Odintsov)
  - ipset: propose rewording in manpage (Neutron Soutmun)
  - More compatibility checking and simplifications to support the
    2.6.32 kernel tree
  - Compatibility: define RCU_INIT_POINTER when __rcu is not defined
  - Compatibility: check kernel source for list_last_entry
    (CentOS7, reported by Ricardo Klein)
  - Make possible to pass extra flags to sparse

Kernel part changes:
  - Add element count to all set types header
  - Add element count to hash headers (Eric B Munson)
  - implement nla_put_in_addr and nla_put_in6_addr (Jiri Benc)
  - deinline ip_set_put_extensions() (Denys Vlasenko)
  - Fix error path in mtype_resize() when new hash bucket cannot be
    allocated
  - There is no need to call synchronize_rcu() after list_add_rcu()
  - Fix typo in function name get_phyoutdev_name()
  - Separate memsize calculation code into dedicated functions (originally
    from Sergey Popovich)
  - Split extensions into separate files (originally from Sergey Popovich)
  - Improve comment extension helpers (originally from Sergey Popovich)
  - Improve skbinfo get/init helpers (originally from Sergey Popovich)
  - Headers file cleanup (originally from Sergey Popovich)
  - Correct rcu_dereference_bh_nfnl() usage (originally from Sergey
    Popovich)
  - add helpers for fetching physin/outdev (Florian Westphal)
  - When a single set is destroyed, make sure it can't be grabbed by dump
  - In comment extension ip_set_comment_free() is always called in a safe
    path
  - Add rcu_barrier() to module removal in the bitmap types too
  - Fix coding styles reported by the most recent checkpatch.pl
  - Make sure bitmap:ip,mac detects the proper MAC even when it's
    overwritten
  - RCU safe comment extension handling
  - Make sure the proper is_destroyed value is checked at dumping
  - Fix broken commit "Check extensions attributes before getting
    extensions."
  - Improve preprocessor macros checks (Sergey Popovich)
  - Fix hashing for ipv6 sets (Sergey Popovich)
  - Fix ext_*() macros so pointers returned by these macros could be
    referenced directly (Sergey Popovich)
  - Check for comment netlink attribute length (Sergey Popovich)
  - Return bool values instead of int (Sergey Popovich)
  - Check CIDR value only when attribute is given (Sergey Popovich)
  - Make sure we always return line number on batch (Sergey Popovich)
  - Permit CIDR equal to the host address CIDR in IPv6 (Sergey Popovich)
  - Use HOST_MASK literal to represent host address CIDR len (Sergey
    Popovich)
  - Check IPSET_ATTR_PORT only once (Sergey Popovich)
  - Check extensions attributes before getting extensions (Sergey 
    Popovich)
  - Use SET_WITH_*() helpers to test set extensions (Sergey Popovich)
  - Return ipset error instead of bool (Sergey Popovich)
  - Preprocessor directices cleanup (Sergey Popovich)
  - No need to make nomatch bitfield (Sergey Popovich)
  - Make sure bit operations are not reordered
  - Properly calculate extensions offsets and total length (Sergey 
    Popovich)
  - Fix cidr handling for hash:*net* types, reported by Jonathan Johnson
  - fix boolreturn.cocci warnings (Fengguang Wu)
  - make ip_set_get_ip*_port to use skb_network_offset (Alexander Drozdov)
  - Make sure listing doesn't grab a set which is just being destroyed.
  - Missing rcu_read_lock() and _unlock() in mtype_list() fixed
  - Fix coding styles reported by checkpatch.pl
  - Use nlmsg_total_size instead of NLMSG_SPACE in ip_set_core.c
  - There's no need to call synchronize_rcu() with kfree_rcu()
  - Call rcu_barrier() in module removal path
  - Call synchronize_rcu() in set type (un)register functions only when
    needed
  - Remove an unused macro
  - Give a better name to a macro in ip_set_core.c
  - Resolve the STREQ macro to make the code more readable, and use
    nla_strlcpy where possible
  - Use MSEC_PER_SEC consistently
  - Remove unnecessary integer RCU handling and fix other sparse warnings
  - Fix sparse warning "cast to restricted __be32"

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
