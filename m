From: Henrik Nordstrom <hno@marasystems.com>
Subject: pom-ng and kernel/iptables
Date: Sat, 28 Feb 2004 12:14:45 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402281157190.8846-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Some thoughts.. 

pom-ng already have the support for multiple projects (kernel / iptables), 
and moving the non-standard extensions from iptables to pom has already 
been discussed which I am all favor for.

So what do you think about the following ideas:

* non-standard extensions moved from iptables to pom-ng entirely,
eleminating the need to update/maintain the iptables package separately
for extensions.

* to make like easier for distributors or other binary package maintainers
pom-ng is modified to allow selecting which project should be patched 
instead of always applying to all projects at the same time. This to allow 
iptables and the kernel to be packaged separately.

* a special case for iptables extensions is added, automating copying of
the kernel extension headers to the iptables package to allow building of
most iptables extensions without requiring the extension to be added to
the kernel, and also avoiding the duplicate maintenance of the same 
header.

* the iptables package is slightly restructured to allow for a 
"iptables-devel" binary package with the files required for compiling 
extensions, combined with a little wrapper in pom-ng to compile a iptables 
extensions directly from pom-ng without patching the iptables sources.



Time permitting I may look into some of the above once the basic
functionality of pom-ng works and you agree the idea is good..  but I am
currently trying to track down very noticeable bugs in .ldadd processing
(results currently repeated many many times for some reason).

Regards
Henrik
