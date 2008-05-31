From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink release 0.0.38
Date: Sat, 31 May 2008 18:29:54 +0200
Message-ID: <48417D02.8050907@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070704050907090802070508"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070704050907090802070508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnfnetlink 0.0.38. This release
includes minor bugfixes and updates. Changelog is attached.

libnfnetlink is the low-level library for netfilter related
kernel/userspace communication. It provides a generic messaging
infrastructure for in-kernel netfilter subsystems (such as
nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their
respective users and/or management tools in userspace.

This library requires a linux kernel >= 2.6.18.

You can download it from:

http://www.netfilter.org/projects/libnfnetlink/downloads.html

Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------070704050907090802070508
Content-Type: text/plain;
 name="Changelog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Changelog"

Jan Engelhardt (1):
      The second, deprecated, form of `AM_INIT_AUTOMAKE' has two required

Pablo Neira Ayuso (5):
      recover the nested bit as now it is fully supported in kernel space.
      major cleanup of index2name infrastructure: use linux list (and fix leak in the nlif_close path)
      update include files
      fix warning, getsockname takes a socklen_t as third parameter
      add conditional defition of NLA_F_NESTED for old includes


--------------070704050907090802070508--
