From: Sirine Chaitou <schit_2007@yahoo.fr>
Subject: A question about the skbuff handling - Thanks for your answer.
Date: Mon, 20 Aug 2007 17:32:38 +0200 (CEST)
Message-ID: <550106.33771.qm@web26614.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: marc+nf@mbsi.ca, gandalf@netfilter.org, rusty@rustcorp.com.au,
	kadlec@netfilter.org, kaber@netfilter.org,
	webmaster@gnumonks.org, yasuyuki@netfilter.org, schit_2007@yahoo.fr
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dear all,
First of all, I would like to say that I got troubles
when sending to the Netfilter-devel mailing list,
that's why I am sending my request also to some of
Netfilter core team (the ones specifying direct
e-mails at the Netfilter page).
I am implementing a protocol which requires to use
some of the on-the-fly active connections information,
in particular, I am interested on the last seq and ack
values associated to each active connection.
These values will be used by another process which
will build faked packets with the same values.
I thought about two solutions:
- The first one uses the Netfilter capabilities, which
registers a callback function at a given hook so as to
read the packet and write the required information
somewhere in the procfs filesystem. The other process
will then read from procfs to build faked packets.
As far as packets are read at the kernel level,
performance is expected to be better that the second
solution.
- The second solution uses pcap capabilities to sniff
packets and to manage the associated connections. A
lot to do at the user space and the solution doesn't
seem "elegant".

The idea of the first solution is simple:
the callback function is applied to each packet, for a
given protocol dst port I will fill in a
conn_structure in procfs.
What I can't see is how to manage the list of all the
active connections at once,without having to care
about the staff of comparing the incoming packets with
the list of the already existing ones etc.
I am sure that I can reuse something from the kernel
net framework to write the logger kernel module.

Can anyone help me to solve this issue?

A lot of thanks in advance,

all My best Regards,
--Siri


      ____________________________________________________________________________________________
Découvrez le blog Yahoo! Mail : dernières nouveautés, astuces, conseils.. et vos réactions !
http://blog.mail.yahoo.fr
