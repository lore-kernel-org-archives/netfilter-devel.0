From: James Morris <jmorris@namei.org>
Subject: [PATCHSET 0/5] SECMARK 2.0
Date: Thu, 18 May 2006 11:37:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605181130560.3010@d.namei>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

These are the iptables userland patches for the latest version of secmark, 
which has just been committed to the -mm tree.

Secmark implements a new scheme for adding security markings to packets 
via iptables, as well as changes to SELinux to use these markings for 
security policy enforcement.  The rationale for this scheme is explained 
and discussed in detail in the original threads: 
http://thread.gmane.org/gmane.linux.network/34927/ 
http://thread.gmane.org/gmane.linux.network/35244/

The latest kernel patches were posted here: 
http://marc.theaimsgroup.com/?l=linux-netdev&m=114794408021148&w=2 for 

Examples of policy and rulesets, as well as a full archive of patches for 
iptables and SELinux userland, may be found at:
http://people.redhat.com/jmorris/selinux/secmark/

The iptables userland patches do the following:

o Add support for linking to libselinux
o Add SECMARK targets for IPv4 and IPv6
o Add CONNSECMARK targets for IPv4 and IPv6

Following a suggestion from Patrick, the CONNSEMARK target now handles all 
conntrack-related functions.

Any questions, please let me know.


If it looks ok, please consider applying.




- James
-- 
James Morris
<jmorris@namei.org>
