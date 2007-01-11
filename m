From: "Snyder, Brian" <bsnyder@idirect.net>
Subject: Q about netfilter and packet modifications
Date: Thu, 11 Jan 2007 10:06:52 -0500
Message-ID: <C874DBE9D30B584587F8CD0EC34DA8BE03AA6443@EX00.idirect.net>
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

Hi all,

I'm working on a test program using libipq and iptables (to route packet
to userspace). =20

I have a test program working that does all of the above, now I want to
start adding some of my smarts into the program, and one thing I want to
do is add some TCP options into certain types of TCP packets.

So I believe I understand what I have to do, or at least I'm rather
close, but I would just like some confirmation that I'm on the correct
path:


1) Create a totally new 'message buffer' of the appropriate size, to
house the original packet in it's entirety, plus the extra bytes I need
to add for my new TCP option.
2) Copy over all the orignal headers into this new memory space... Then
add in my own TCP headers.
3) 'Merge' the tcp data packet itself into the new structure, AFTER my
added tcp header.
4) Re-compute all required checksums
5) Reaim - msg->payload to my new structure.
6) ??  Do I need to free the old msg->payload or does the kernel know to
do this for me ??
7) Send back a ipq_set_verdict, with all the params set to show I
mangled the packet a bit.




I'm concerned about the processing this will take, as it looks like
there will need to be 2 different calls to memcopy, totalling the full
length of every packet.

Can I mangle JUST the header's if I set the mode to IPQ_COPY_META, and
would it integrate my header changes in with the packet data
automagically?  That would save me a lot of the memcopy for large
packets.

I plan on setting the MTU in accordance with the space needed to add my
options, so it shouldn't cause any fragmentation.

Thanks,
brian
