From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: problem when loading ip_tables
Date: Wed, 24 Mar 2004 13:00:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40616A52.3080704@netlab.hut.fi>
References: <4055C7C3.2030003@netlab.hut.fi> <20040317135934.GB21899@sunbeam.de.gnumonks.org>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

After having modified a few things in the nat part of the iptables code, 
I was sent back to an old problem:

modprobe: Can't locate module ip_tables
iptables v1.2.9: can't initialize iptables 'nat': Table does not exist 
(do you need to insmod?)
Perhaps iptables or your kernel need to be upgraded.

I can't remember exactly when did the problem appear, but it may have 
been after I had added something in ip_conntrack_standalone.c
Anyway, I compiled again, again and again until now when I have a brand 
new kernel (2.4.23) and iptables library (1.2.9, patched) compiled. 
Still, I cannot get rid of that error. Moreover, if I try manually to 
load ip_tables I also get an error

insmod: ip_tables: no module by that name found

while the module ip_tables.o exists. insmod finds without problem the 
other modules like for example ipt_REDIRECT, ip_conntrack, iptable_nat...

Any advice about that?

         Emmanuel
