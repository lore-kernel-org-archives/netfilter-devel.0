From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.101 release
Date: Wed, 23 Dec 2009 21:32:58 +0100
Message-ID: <4B327E7A.6060100@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070109050508010705060503"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070109050508010705060503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents libnetfilter_conntrack-0.0.101.

libnetfilter_conntrack is a userspace library providing a programming 
interface (API) to the in-kernel connection tracking state table. This 
library requires a linux kernel >= 2.6.18.

This release includes a one fix and several cleanups from Hannes Eder. 
See ChangeLog for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Core Team.

--------------070109050508010705060503
Content-Type: text/plain;
 name="changes-libnetfilter_conntrack-0.0.101.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-libnetfilter_conntrack-0.0.101.txt"

Hannes Eder (3):
      api: use ANSI style function
      src: make symbols used only in file scope static
      snprintf: remove duplicate initializer entry

Pablo Neira Ayuso (2):
      setobjopt: don't autocomplete the reply tuple for ICMP[v6]
      configure: bump version to 0.0.101


--------------070109050508010705060503--
