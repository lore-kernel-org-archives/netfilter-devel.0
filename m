From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Release libnfnetlink_conntrack
Date: Tue, 22 May 2007 19:00:01 +0200
Message-ID: <46532191.3050705@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050407020809090806000105"
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
--------------050407020809090806000105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.75

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/files/libnetfilter_conntrack-0.0.75.tar.bz2

Happy tracking,

	Pablo (on behalf of the Netfilter Project)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------050407020809090806000105
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnetfilter_conntrack 0.0.75
======================================================================

Changes from 0.0.50:

- Fix inconsistency in the status flags bits
	[Pablo Neira]

- Fix icmp_id setter and documentation
	[Phil Dibowitz]

- Fix compilation with old glibc versions
	[Thomas Jarosch]

- Fix inconsistency in the behaviour of nfct_set_attr with ATTR_STATUS
	[Pablo Neira]

- Relax checkings in the NAT detector functions
	[Pablo Neira]

- Fix wrong documentation in nfct_get_attr_u[*]
	[Pablo Neira]

- introduce new expectation API
	[Pablo Neira]

- fix wrong port display in the XML output
	[Morten Isaksen]

- use ntohs instead htons in snprintf_default.c
	[Pablo Neira]

- introduce examples files under utils/, remove old deprecated API test file
	[Pablo Neira]

--------------050407020809090806000105--
