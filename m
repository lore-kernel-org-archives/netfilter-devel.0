From: nf-hipac Team <nf@hipac.org>
Subject: [ANNOUNCE] nf-hipac v0.1 released
Date: Mon, 9 Dec 2002 13:54:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212091354.22910.nf@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org, netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

Version 0.1 of nf-hipac is out. Here is a short summary of the
improvements:
   - support for all kernel architectures especially 64 bit architectures
   - dynamically change invokation order of iptables and nf-hipac via
     /proc/net/nf-hipac without losing your rules
   - support for negation (!) in matches
   - autoloading of the kernel module nf_hipac.o
   - install and uninstall target added to Makefile
   - all outstanding bugs are fixed in this release

The official project web page ist:   http://www.hipac.org
The releases can be downloaded from: http://sourceforge.net/projects/nf-h=
ipac/


For all of you who don't know nf-hipac yet, here is a short overview:

nf-hipac is a very efficient packet filter implemented on top of the=20
netfilter framework which is included in the linux 2.4 kernel. Its=20
userspace tool, which is also called 'nf-hipac', is designed to be as=20
compatible as possible to 'iptables -t filter', although it still lacks=20
some of its features. For details see the Mini-HowTo
(http://www.hipac.org/documentation/howto.htm).
'nf-hipac' uses the same hooks inside the linux 2.4 kernel's network=20
stack like 'iptables -t filter' does. The userspace tool is used to=20
define a set of rules where each rule consists of a number of=20
classifiers (matches) and one connected action (target). One advantage=20
of the compatibility to iptables is that users are able to use the full=20
power of stateful packet filtering (connection tracking) besides the=20
usual stateless matches.

Features:
     - optimized for high performance packet classification
       with moderate memory usage
     - completely dynamic:
         data structure isn't rebuild from scratch when inserting or
         deleting rules, so fast updates are possible
     - userspace tool syntax is very similar to the iptables syntax
     - kernel does not need to be patched
     - support for 64 bit architectures: nf-hipac should now work on all
       architectures supported by the linux kernel
     - compatible to iptables: you can use iptables and nf-hipac at
       the same time:
         for example you could use the connection tracking module from
         iptables and match the states with nf-hipac
     - match support for:
         + source/destination ip
         + in/out interface
         + protocol (udp, tcp, icmp)
         + source/destination ports (udp, tcp)
         + icmp type
         + tcp flags
         + ttl
         + state match (ip_conntrack module must be loaded manually)
     - match negation (!)
     - autoloading of the kernel module nf_hipac.o
     - /proc/net/nf-hipac:
         + algorithm statistics available via
             # cat /proc/net/nf-hipac
         + allows to dynamically limit the maximum memory usage
             # echo <size in MB>  >  /proc/net/nf-hipac
         - nf-hipac invoked before iptables:
             # echo nfhp_first > /proc/net/nf-hipac
         - iptables invoked before nf-hipac:
             # echo ipt_first > /proc/net/nf-hipac


Enjoy,

+-----------------------+----------------------+
|   Michael Bellion     |     Thomas Heinz     |
| <mbellion@hipac.org>  |  <creatix@hipac.org> |
+-----------------------+----------------------+
