From: Bill <boober95@rogers.com>
Subject: Test case example for conntrack expectation doesn't work?
Date: Tue, 22 Mar 2016 14:51:19 -0400
Message-ID: <201603221451.19903.boober95@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm14-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.115.16]:39047
	"EHLO nm14-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbcCVS5c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 14:57:32 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I and trying use netfilter, and expectations, for ALG development.  But 
running the example test for creating a new expectation doesn't work.  I 
thought it used to on an older version, but not now.  I see there are a lot 
of changes to conntrack lately and wonder if this have been changed?

Here is the info on the test I have an issue with and the configuration I have 
been testing on:


Software versions:

Debian Testing
Kernel 4.3.0-1-amd64
conntrack v1.4.3 (conntrack-tools)


The FTP modules for nat and conntrack have been loaded:

lsmod | fgrep ftp
nf_nat_tftp            16384  0
nf_conntrack_tftp      16384  1 nf_nat_tftp
nf_nat_ftp             16384  0
nf_conntrack_ftp       20480  1 nf_nat_ftp
nf_nat                 24576  4 
nf_nat_ftp,nf_nat_ipv4,nf_nat_tftp,nf_nat_masquerade_ipv4
nf_conntrack          118784  10 
nf_nat_ftp,nf_nat,nf_nat_ipv4,nf_nat_tftp,xt_conntrack,nf_nat_masquerade_ipv4,nf_conntrack_netlink,nf_conntrack_ftp,nf_conntrack_ipv4,nf_conntrack_tftp


Failed creating of an FTP expectation, right from the test suite:

bash test.sh create-expect
conntrack v1.4.3 (conntrack-tools): Operation failed: master conntrack not 
found


Other tests with FTP helper seem to work just fine:

bash test.sh new-nat
creating a new conntrack (NAT)
conntrack v1.4.3 (conntrack-tools): 1 flow entries have been created.

conntrack -L -s 1.1.1.1
tcp      6 38 SYN_SENT2 src=1.1.1.1 dst=2.2.2.2 sport=2005 dport=21 
src=8.8.8.8 dst=1.1.1.1 sport=21 dport=2005 mark=0 helper=ftp use=1
conntrack v1.4.3 (conntrack-tools): 1 flow entries have been shown.


Anyhow, pointers version of the tests/conntrack that work, or info on how to 
fix this would be appreciated.

Bill

