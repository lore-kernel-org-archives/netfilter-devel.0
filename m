From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] prepare a 2.6 tree in h323-conntrack-nat
Date: Wed, 19 Jan 2005 12:35:04 +0100
Message-ID: <20050119113504.GA17232@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is actually not a patch, just a svn copy command... someone with
svn write access, please execute the following command:

 svn copy \
  https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/h323-conntrack-nat/linux \
  https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/h323-conntrack-nat/linux-2.6 \
  -m 'prepare a 2.6 tree for h323-conntrack-nat'

This allows me to publish patches for the existing codebase for my
Linux 2.6 port of the module, and preserves the svn log once my
patches are accepted.

Max
