From: Michael Spaeth <kilroy@uni-koblenz.de>
Subject: Development of a ipt_ID target
Date: Mon, 22 Dec 2003 10:34:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1542617874.20031222103418@uni-koblenz.de>
Reply-To: Michael Spaeth <kilroy@uni-koblenz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hello!

  I wanted to develop a target for ID mangling, I searched the net but
  I found none (If someone knows one, please show me)

  So I started to successfully modify the ipt_TTL mangle target (just
  to test)

  My goal is to achieve a filter that can reset all outgoing IDs to
  zero, fake the sequence numbering of Windows/Linux boxes or use
  a random generator.

  But I had some problems when I inspected the source code of
  ipt_TTL.c:

  Example:

$IPTABLES -t mangle -A POSTROUTING -o ${INET_DEVICE} -j TTL --ttl-set 128
  
  First of all: It is quite ugly to have one part in the iptables
  package (the part with the parsing "--ttl-set" is in the iptables
  package) and having the check and execution code in the kernel...

  Since there is a check code in the kernel, can it be used as parsing
  code, too (I know, this would mean changing some of iptables infra
  structure)

  Second of all: On the netfilter home page I found several files you
  need to patch
  (http://www.netfilter.org/documentation/pomlist/pom-base.html#TTL)

  - Is there a program to apply all these patches at once AND: where
  is the iptables patch for the argument parsing?

  Oh, and why is the checksum method marked as "need a new one" ?

  And a third question: Why is this  ipt_TTL.c target missing in some
  kernel versions (Gentoo, version 2.4.20r9 have it, 2.4.22r2 does not
  have it) ? Since the code for parsing the target is in, why does it
  miss in the kernel sources?

  Ok, I hope I did not ask too many questions and I hope I documented
  it all in a way everyone can understand me ;-)

-- 
Regards,
 Michael                          mailto:kilroy@uni-koblenz.de
