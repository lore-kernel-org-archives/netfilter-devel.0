From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.3.7
Date: Wed, 06 Dec 2006 10:49:56 +0100
Message-ID: <45769244.3060508@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lwn@lwn.net
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
To: netfilter-announce@lists.netfilter.org,
	netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org
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

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.7

The 1.3.7 version contains accumulated bugfixes to the last 1.3.6
version. This comes a bit earlier after the last release than
usual because the endian annotations in 2.6.19 broke iptables
compilation, which is fixed with this version.

The ChangeLog is attached to this mail.

Version 1.3.7 can be obtained from:

	http://www.netfilter.org/projects/iptables/files/iptables-1.3.7.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.7.tar.bz2

More information can be found at the netfilter/iptables project
homepage, available at:

	http://www.netfilter.org/

Happy firewalling,
	Patrick (for the Netfilter Core Team)


As a side note: since usually Harald takes care of releases
and I'm quite unfamiliar with the process, there's a good
chance I messed something up. Please let me know about any
problems.
