From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: volunteer tcl script writer needed for iptables application
Date: Sat, 11 Mar 2006 18:24:49 -0500
Message-ID: <1142119489.2987.61.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-devel@lists.netfilter.org
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

The ISCS open source network security management project
(http://iscs.sourceforge.net) could use some volunteer assistance from
someone who can adapt bash scripts to tcl for the creation of iptables
configuration files and implementing dynamic iptables changes on
production devices.  If you are interested and able to assist, please
contact me using the details in my signature below.  For more details,
please continue reading.

We have added support for the Secure Computing / CyberGuard / SnapGear
SG series of devices so that they can be managed using ISCS with no
change to firmware.  The SG580 devices are working fine in production
but the SG570 devices use sash instead of bash.  We can get around the
limitations of bash by using the tcl interpreter.  However, we have no
one on the team with tcl experience.

ISCS could be described as an open source alternative to very expensive
products for managing large, enterprise network security deployments
such as Solsoft or Provider1.  Actually, it does much more and has no
commercial equivalent.  It has allowed us to implement complex,
perimeter style security within the perimeter to affordably create truly
segmented and multi-layered networks with a minimum of labor.

To give an idea of what it does, a recent production deployment of
internal network security for a global manufacturer would have required
well in excess of 100,000 iptables rules.  ISCS reduced that rule set to
roughly 13,000 rules, only requires traversal of a small subset of those
rules for any new packet, generated those rules in a couple of hours and
distributed them to all devices automatically at the click of a button
within a couple of minutes.  ipset could probably reduce the rule set
tenfold again.  Any ipset experts out there interested in helping?

In comparison, if one had to write 13,000 rules at 20 seconds per rule,
that would be 72 hours -- at one minute per rule, 217 hours.  150,000
rules would take 833 hours at 20 seconds and 2,500 hours at one minute
per rule.

All this with a dramatic reduction in exposure to human error (one can
imagine the danger of a typo or out of order rule in 150,000 line rule
set). That's just the beginning.

If you are interested and can help, we would greatly appreciate your
assistance.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

Financially sustainable open source development
http://www.opensourcedevel.com
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

Financially sustainable open source development
http://www.opensourcedevel.com
