From: "Emiel Mols" <emiel@fulgor-hosting.nl>
Subject: IPSEC and NAT
Date: Fri, 15 Oct 2004 20:00:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <E1CIWN8-0005Vo-00@deer.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

 

I've managed to setup a host-to-net ipsec connection with a remote network
on a linux router using (ported) isakmpd and kernel 2.6.8.1. However, I want
to be able to 'share' this ipsec connection with the rest of the network,
but since no ipsecn virtual interface is created in the 2.6 kernels I can't
use ordinary SNAT/MASQUERADE targets in iptables: ipsec packets get
encrypted before entering the POSTROUTING table :(, so the source address of
the encapsulated packet can't be changed anymore. I've read
http://lists.netfilter.org/pipermail/netfilter-devel/2004-January/thread.htm
l#13879, but the supplied patch doesn't work very well.

 

Does anyone have any suggestions on how to get this working?

 

Thanks in advance,

 

Emiel
