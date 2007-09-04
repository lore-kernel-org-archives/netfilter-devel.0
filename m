From: "Hung Lin" <hlin@nextone.com>
Subject: ipporthash doesn't work ( ipset-2.3.0, iptables-1.3.8-15,
	kernel-2.6.22.3-7-bigsmp, SuSE 10.3 Beta2)
Date: Tue, 4 Sep 2007 18:16:58 -0400
Message-ID: <D0B3C45E7FCE4C488BEF410B2EF666A101974490@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Hi,=20

I compiled and installed ipset-2.3.0, I found the iphash worked fine but =
ipporthash acted wired.  Here's the scenario:


suse10-3:~ # ipset -N set1 ipporthash --network 10.1.0.0/16
suse10-3:~ # ipset -A set1 10.1.5.28:7
suse10-3:~ # ipset -nL
Name: set1
Type: ipporthash
References: 0
Default binding:
Header: from: 10.1.0.0 to: 10.1.255.255 hashsize: 1024 probes: 8 resize: =
50
Members:
10.1.5.28:7
Bindings:
suse10-3:~ # iptables -nvL
Chain INPUT (policy ACCEPT 5590 packets, 418K bytes)
 pkts bytes target     prot opt in     out     source               =
destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               =
destination

Chain OUTPUT (policy ACCEPT 4143 packets, 798K bytes)
 pkts bytes target     prot opt in     out     source               =
destination

suse10-3:~ # iptables -I INPUT -m set --set set1 src,dst -j DROP


After I insert the iptables rule, I cannot ssh to that machine but I can =
ping it (I tried from different ips: 172.16.1.121, 10.1.5.27, and =
10.1.5.28.).  It's not the correct behavior.  I suppose the commands I =
ran should block the package from 10.1.5.28 to the port 7.  But it seems =
to block every IP to the port 22.


P.S.=20

I used patch-o-maic-ng-20070828.tar.bz2 downloaded from =
http://ipset.netfilter.org/ to patch the kernel (2.6.22.3-7) of SuSE =
10.3 beta2

The iptables version is 1.3.8-15 and ipset version is 2.3.0






Thanks for your time

Hung Lin
