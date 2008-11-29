From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.0.98 release
Date: Sat, 29 Nov 2008 13:49:19 +0100
Message-ID: <49313A4F.6090904@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010701060004070107080504"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010701060004070107080504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.98.

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes one major bugfix, a couple of minor fixes, the new
attribute group API and cleanups. See ChangeLog for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo,
on behalf of the Netfilter Project.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------010701060004070107080504
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

Pablo Neira Ayuso (13):
      objopt: use indirect calls instead of switch
      API: use of __builtin_expect in error checking paths
      snprintf: fix compilation warning in 64-bits platforms
      groups: add attribute group API
      API: add nfct_attr_is_set_array function
      version: bump to 0.0.98
      src: set specific array size for the API
      qa: add test file to check for missing indirect function calls
      helper: fix missing copy function for helper name
      bsf: major rework of the BSF generation code
      bsf: remove unnecessary function inline
      api: fix bogus netlink flags in nfct_build_query
      api: fix bogus netlink flags in nfexp_build_query


--------------010701060004070107080504--
