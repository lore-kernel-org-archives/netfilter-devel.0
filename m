From: "arny" <arny@arny.ro>
Subject: Re: iptables freeze
Date: Fri, 9 Jul 2004 01:52:33 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40244.83.103.143.1.1089327153.squirrel@83.103.143.1>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: hidden@balabit.hu
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi folks.

I installed  slackware packages:
kernel-ide-2.4.26-i486-4.tgz, kernel-source-2.4.26-noarch-4.tgz
kernel-modules-2.4.26-i486-3.tgz and kernel-headers-2.4.26-i386-3 and
reboot. This is the precompiled kernel from the latest slackware. The
kernel not have SMP suport.

Success! first step was passed. It work, the box not freez! the next step
is start squid+firewall.
Yep it`s working, everithing is started. Now the final test.
After reboot the box with 2.6.7 it freeze. Let`s see if the 2.4.26 it`s
OK. Right now i have 129 pc online and 40 users connected to cache.
Reboot.
The box not responding to ping and the internet is down. All services
started without errors.
 Found the problem. I start firewall after  packet  forwarding. Changed,
first start firewall and then packet forwarding.
 WORKING. The box is booting without errors and not freez anymore.
Now let see after 24H if it is OK.


P.S. sorry 4 my english.
