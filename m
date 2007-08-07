From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: libnetfilter_queue release 0.0.15
Date: Tue, 07 Aug 2007 16:20:02 +0200
Message-ID: <46B87F92.9050900@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000408060605000102090104"
Cc: lwn@lwn.net
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-announce>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-announce-bounces@lists.netfilter.org
Errors-To: netfilter-announce-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000408060605000102090104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project presents libnetfilter_queue 0.0.15

libnetfilter_queue is a userspace library providing an API to packets
that have been queued by the kernel packet filter. It is is part of a
system that deprecates the old ip_queue / libipq mechanism.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_queue/downloads.html

Pablo (on behalf of the Netfilter Project)

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.


--------------000408060605000102090104
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnetfilter_queue 0.0.15
======================================================================

Changes from 0.0.13:

- introduce interface index to name API
	[Eric Leblond]

--------------000408060605000102090104--
