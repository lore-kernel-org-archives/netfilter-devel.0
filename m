From: "Andy Schmeder" <andy@a2hd.com>
Subject: standalone target module??
Date: Mon, 3 Feb 2003 13:49:26 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <33492.192.168.1.5.1044308966.squirrel@secure.a2hd.com>
Reply-To: andy@a2hd.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
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

Hello Netfilter Developers!!

1.  Thank you for writing some great software.

2.  Please help me with a couple of questions; I am trying to write a
netfilter extension.

I need to write a netfilter extension for a research project; there are a
number of special requirements, specifically wrt. latency which can only
be met by running this in kernel space.

I would like, if possible, to write this as a loadable standalone kernel
module.  For simplicity, I would prefer to be able to build and test my
module without having to patch the kernel source.  Is this feasible?

So far I have tried to copy the ipt_MIRROR.c code, change a couple of
things, compile as a ipt_MYTARGET.o, insmod ipt_MYTARGET.o.  Netfilter
does not seem to find the new target.  'iptables -A INPUT -i eth1 -j
MYTARGET' causes iptables to look for /lib/iptables/libipt_MYTARGET.so.

The next thing I tried was to run 'ld -shared -o
/lib/iptables/libipt_MYTARGET.so ipt_MYTARGET.o'.  This generates a number
of undefined symbols for any of the kernel functions; which makes me think
that the .so files in /lib/iptables are not actually kernel modules... 
unfortunately the files there have been strip'd so I have no idea what is
in them.

What I am really seeking is an example Makefile for building a standalone
netfilter target as a module.  Does such a thing exist?  I have already
google'd my eyes out trying to solve this problem with no luck so far.

Thanks for your time,
Andy.

---
Andy W. Schmeder
andy @ a 2 h d . com
