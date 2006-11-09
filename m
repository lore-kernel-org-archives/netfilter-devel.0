From: "Laurence J. Lane" <ljlane@debian.org>
Subject: rename-chain option broken in 1.3.6
Date: Wed, 8 Nov 2006 23:51:52 -0500
Message-ID: <cd6061db0611082051n24bcb5a1hab540f6a1e2d0e8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

--rename-chain (-E) appears to be broken in iptables 1.3.6. Reverting
r6584 and r6584 doesn't appear to affect it.

  # iptables -N foo
  # iptables --rename-chain foo bar
  iptables v1.3.6: You need to supply the `-s' option for this command

  Try `iptables -h' or 'iptables --help' for more information.

(bugzilla appears to have a mysql server problem at the moment. I
can't see if this is already reported.)
