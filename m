From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.17 released
Date: Thu, 21 Feb 2013 16:59:17 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302211654250.11434@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:43201 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab3BUP7U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:59:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.17. The new release comes with a few fixes, 
the most important is the timeout value corruption fix from Josh Hunt when 
hash types with timeouts are resized.

Also, the package contains the ipset_bash_completion and ipset_list tools:

	http://sourceforge.net/projects/ipset-bashcompl
	http://sourceforge.net/projects/ipset-list

Userspace changes:
 - Fix revision printing in XML mode (reported by Mart Frauenlob)
 - Correct "Suspicious condition (assignment + comparison)" (Thomas 
   Jarosch)
 - Fix error path when protocol number is used with port range
 - Interactive mode error after syntax error (reported by Mart Frauenlob)
 - The ipset_bash_completion tool is added
 - The ipset_list tool is added

Kernel part changes:
  - Make sure ip_set_max isn't set to IPSET_INVALID_ID
  - netfilter: ipset: timeout values corrupted on set resize (Josh Hunt)
  - "Directory not empty" error message (reported by John Brendler)

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
