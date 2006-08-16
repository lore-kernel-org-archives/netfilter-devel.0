From: "Snyder, Brian" <bsnyder@idirect.net>
Subject: Question from a newbie about libraries needed to get started
Date: Wed, 16 Aug 2006 11:20:15 -0400
Message-ID: <C874DBE9D30B584587F8CD0EC34DA8BE024D0917@EX00.idirect.net>
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

Hi all.  Thanks in advance to anyone whom takes the time to read this
(and hopefully replies;).
=20
=20
Anyway,
=20
=20
I'm a new developer in the netfilter world and have a few basic setup
questions.
=20
I've got a good handle on iptables and how to utilize that to get
desired packets queued into a userspace program.  My problem lies with
how to go about developing said user space program.
=20
=20
I'm running on a fedora core 5 box and I have iptables,iproute2,brctl
installed by default - so I didnt have to go out of my way to get any
user space applications.
=20
=20
My problem is I don't have libipq.a or libipq.h anywhere in my system.
So i went about searching for it , and here is where I am very confused.
Via tons of online faqs and howtos I see references to the following all
of which i've downloaded:
=20
=20
libnetfilter_queue-0.0.12
libnfnetlink-0.0.16
and=20
iptables-1.3.5-20060815 (yesterday's nightly snapshot)
=20
I guess I am just a bit confused as to what the libnetfilter_queue and
libnfnetlink libraries are for?  If the libipq is part of iptables as
well - what do we need those other libraries for? I feel like i'm
missing something fundamental here...
=20
So it seems like there are a couple of ways to get libipq on a
development system and I'm not sure which package i actually want to use
and install.
=20
I already have iptables, but I can always 'redo' that if i need to in
order to get teh development libraries/headers needed.
=20
=20
Anyway, from a sys-admin point is there any advice anyone could give me
as to what  packages/rpms/etc I actually want to install to get a
development system going?
=20
Thanks again,
brian
