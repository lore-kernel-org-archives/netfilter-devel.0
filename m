From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink release 0.0.30
Date: Tue, 31 Jul 2007 11:26:31 +0200
Message-ID: <46AF0047.9020705@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080903030609000601090107"
Cc: lwn@lwn.net
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080903030609000601090107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project proudly presents libnfnetlink 0.0.30

libnfnetlink is the low-level library for netfilter related
kernel/userspace communication. It provides a generic messaging
infrastructure for in-kernel netfilter subsystems (such as
nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their
respective users and/or management tools in userspace.

You can download it from:

http://www.netfilter.org/projects/libnfnetlink/downloads.html

Pablo (on behalf of the Netfilter Project)

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.

--------------080903030609000601090107
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnfnetlink 0.0.30
======================================================================

Changes from 0.0.25:

- update linux_nfnetlink.h from kernel sources
	[Pablo Neira Ayuso]

- remove the nest bit: we don't send it to kernel anymore
	[Pablo Neira Ayuso]

- remove linux/types.h include from libnfnetlink.h
	[Eric Leblond]

- introduce index2interface API
	[Eric Leblond]

- added a test file to utils/iftest.c
	[Pablo Neira Ayuso]

- compile fix with old glibc
	[Thomas Jarosch]

--------------080903030609000601090107--
