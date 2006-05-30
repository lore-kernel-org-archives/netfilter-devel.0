From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: CLASSIFY target
Date: Tue, 30 May 2006 15:29:44 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB2553FA@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

Thank you for your response. I did manage to finally find the code I was
looking for. I also just posted a new description to LARTC with a new
class/qdisc layout. Essentially, what I have now is:

dev wivl4 HFSC Qdisc root
  |
  |-> HFSC Class
  |
  |-> HFSC Class
  ...etc...

And I'm doing a classify directly to those classes. They have no sub
qdiscs or sub classes. Yet, it still will not work. Any additional
thoughts?

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

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Tuesday, May 30, 2006 3:22 PM
To: Eliot, Wireless and Server Administrator, Great Lakes Internet
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: CLASSIFY target

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> I am attempting to classify packets in tc using the iptables classify
> target in the postrouting chain of the mangle table, but it does not
> work. I am looking through the code to try to find out what is going
on
> (whether I am doing something wrong, or whether the kernel module code
> is messed up). I have verified that the ipt_CLASSIFY.c file is
correctly
> building a handle and that it is storing the handle in the
skb->priority
> field. However, inside the packet scheduler code, I cannot find where
> the skb->priority field is being read so that the packets can be sent
to
> the correct class. Could someone please point me in the correct
> direction for viewing this section of the code? Thanks.


The *_classify functions of the individual schedulers use it. I see
you also posted a more detailed description of your problem to lartc:
you can't use classify to classify to multiple nested qdiscs. So
if you have something like:

         <1:0 (root) hfsc>
<1:1 hfsc class> <1:2 hfsc class>
         |
   <2:0 PRIO>
         |
<2:1 - 2:3 PRIO classes>


and say CLASSIFY --set-class 2:1, the upper HFSC qdisc had no idea
how to reach qdisc 2:0. You can either use CLASSIFY --class 2:0
and then attach more classifiers to the PRIO qdisc or manually
direct traffic from 1:0 -> 2:0 and use CLASSIFY --set-class 2:1.
CLASSIFY is really only useful if you have only a single level
of classful qdiscs.
