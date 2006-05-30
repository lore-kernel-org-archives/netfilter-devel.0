From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: CLASSIFY target
Date: Tue, 30 May 2006 12:21:41 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB2553EF@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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


I am attempting to classify packets in tc using the iptables classify
target in the postrouting chain of the mangle table, but it does not
work. I am looking through the code to try to find out what is going on
(whether I am doing something wrong, or whether the kernel module code
is messed up). I have verified that the ipt_CLASSIFY.c file is correctly
building a handle and that it is storing the handle in the skb->priority
field. However, inside the packet scheduler code, I cannot find where
the skb->priority field is being read so that the packets can be sent to
the correct class. Could someone please point me in the correct
direction for viewing this section of the code? Thanks.

=20
Eliot Gable
Certified Wireless Network Administrator (CWNA)
Certified Wireless Security Professional (CWSP)
Cisco Certified Network Associate (CCNA)
CompTIA Security+ Certified
CompTIA Network+ Certified
Network and System Engineer
Great Lakes Internet, Inc.
112 North Howard
Croswell, MI 48422
(810) 679-3395
(877) 558-8324
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.
