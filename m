From: Peter Lenci <peterlenci@yahoo.ca>
Subject: Iptables Match on Direction (IP_CT_IS_REPLY)
Date: Sat, 26 Feb 2005 07:43:03 -0500 (EST)
Message-ID: <20050226124304.13105.qmail@web90010.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi there

Is there a possibility to access flag IP_CT_IS_REPLY from an iptables
command?

I have only spotted the "--direction original|reply|both" option from
the connbytes patch
(http://www.netfilter.org/patch-o-matic/pom-extra.html#pom-extra-connbytes)
but then I would prefer not to waste memory by counting bytes.

Regards
Peter

______________________________________________________________________ 
Post your free ad now! http://personals.yahoo.ca
