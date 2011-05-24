From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 10:48:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:57371 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1EXIsH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:48:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here comes ipset 6.6 with a couple of bugfixes and improvements. The terse 
list of the changes are:

Kernel part changes:
 - Use unified from/to address masking and check the usage
 - ip_set_flush returned -EPROTO instead of -IPSET_ERR_PROTOCOL, fixed
 - Take into account cidr value for the from address when creating the set
 - Adding ranges to hash types with timeout could still fail, fixed
 - Removed old, not used hashing method ip_set_chash
 - Remove variable 'ret' in type_pf_tdel(), which is set but not used
 - Use proper timeout parameter to jiffies conversion

Userspace changes:
 - Restore with bitmap:port and list:set types did not work, fixed
 - Accept "\r\n" terminated COMMIT command in restore files
 - Fix the message sequence number book-keeping
 - Protocol-level debugging support added
 - hash:net stress test in range notation added
 - ipset_mnl_query: in debug mode print the errno returned by the cb
   function
 - Accept "\r\n" terminated lines in restore files
 - Remove outdated checking of IPv6 support from configure.ac

I thank to Mr Dash Four for his tireless testings and helpful reports.

The next ipset package release will come with code simplifications, which 
mean dropping some support:

- iptree and iptreemap type support will be removed, because the automatic
  conversion to hash:ip is not fully backward compatible. The hash:ip and 
  hash:net types can be used instead.
- kernel version support below 2.6.37 will be dropped, to make code
  maintenance easier and more straightforward

You can download the source code of ipset from:
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
