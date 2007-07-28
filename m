From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: libnetfilter_conntrack 0.0.81 release
Date: Sat, 28 Jul 2007 14:38:04 +0200
Message-ID: <46AB38AC.5050509@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090204010302050004090205"
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
--------------090204010302050004090205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project proudly presents libnetfilter_conntrack-0.0.81

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table.

This release includes minor changes and bugfixes. See ChangeLog for more
details. Upgrade is recommended.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Pablo (on behalf of the Netfilter Project)

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.

--------------090204010302050004090205
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

libnetfilter_conntrack 0.0.81
======================================================================

Changes from 0.0.80:

- add layer 4 protocol comparison to nfct_compare()
	[Pablo Neira Ayuso]

- introduce nfct_nfnlh() to use functions like nfnl_rcvbufsiz()
	[Pablo Neira Ayuso]

- remove unused build_id() from build.c
	[Pablo Neira Ayuso]

--------------090204010302050004090205--
