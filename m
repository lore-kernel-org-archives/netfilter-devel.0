From: Silimite <silimite@gmail.com>
Subject: Handling large amounts of data
Date: Sun, 15 May 2005 17:46:21 -0400
Message-ID: <5ad977d10505151446348e932f@mail.gmail.com>
Reply-To: Silimite <silimite@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

I have written an iptables module called "multirange" that works like
a combination of iprange and multiport.  That is, you can specify
multiple ranges to be matched by one rule.

I had to do this because I am loading some 100000 entries into this
rule and I needed something efficient at handling this many ranges.

My question is, what is the best way to communicate all these ranges
from user-space into the kernel module?   I am currently loading them
via procfs.  Is this an acceptable method or should I be looking at
something else?  It certainly works great but I would like it to be as
"proper" as possible.

Thanks!

s
