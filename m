From: "Eric Leblond" <eric@inl.fr>
Subject: [Announce] pynetfilter_conntrack,
 a Python binding of libnetfilter_conntrack
Date: Mon, 9 Oct 2006 22:03:59 +0200 (CEST)
Message-ID: <1721.83.156.14.82.1160424239.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: haypo@inl.fr, vincent@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 netfilter@lists.netfilter.org
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

INL development team is proud to announce the availability of
pynetfilter_conntrack.

pynetfilter_conntrack is a Python binding of libnetfilter_conntrack. The
binding is the file pynetfilter_conntrack.py and you have also a clone of
conntrack program: conntrack.py.

It provides a high level API for libnetfilter_conntrack. For example, you
can display all TCP connections with destination port 22 by doing
something like :

nf = NetfilterConntrack(CONNTRACK)
table = nf.create_table(IPV4)
table = table.filter(6,dport=22)
table.display()

The current release of pynetfilter_conntrack supports listing,
modification and deletion of conntrack entries.

pynetfilter_conntrack has been developped by Victor Stinner aka Haypo. It
is released under GPL by INL.

pynetfilter_conntrack :
http://software.inl.fr/trac/trac.cgi/wiki/pynetfilter_conntrack
INL : http://www.inl.fr/

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)
