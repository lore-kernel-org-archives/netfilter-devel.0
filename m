From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: iptables & libipt_set/SET.c problem
Date: Thu, 15 Jul 2004 12:53:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040715115348.GG2585@fairlite.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In iptables 1.2.11 there are two extensions...

extensions/libipt_set.c
extensions/libipt_SET.c

which appear to be doing the same thing, but the SET version appears to
have a few more features.

There's also the problem that both of these extensions are looking for
the file ../ipset/libipt_set.h which doesn't exist and so the build fails
at the dependencies stage.

Is there a problem with the 1.2.11 package ??

Alan.
