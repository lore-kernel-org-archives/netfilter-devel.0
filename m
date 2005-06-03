From: knash@cs.tcd.ie
Subject: promiscuous mode
Date: Fri, 3 Jun 2005 10:09:38 +0100 (IST)
Message-ID: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,
I set up my wireless card in promiscuous mode. I want to capture all
unicast packets using the hook NF_IP_PRE_ROUTING but packets other then
the ones destined for my machine are been dropped.
I found this link, which talks about a NF_IP_PROMISC hook
This seems to be exactly what I want

https://lists.netfilter.org/pipermail/netfilter-devel/2001-November.txt

The only think is it refers to modifying
netfilter/userspace/libiptc/libip4tc.c which doesn't seem to exist on the
version of linux I'm running.

I'm currently using
Fedora Core 2 (2.6.5-1.358)
and iptables v1.2.9

I was wondering does the latest version of netfilter support promiscuous
mode or is there a patch available out there somewhere ??

Thanks very much for your help,

Kevin
