From: Adrian Thurston <adriant@ragel.ca>
Subject: use of a state machine compiler in netfilter?
Date: Sat, 26 Oct 2002 15:11:19 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210261452140.16251-100000@ice.ragel.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello, I'd like to contribute to netfilter, but first I need to do a
little research. I don't have much experience kernel hacking or with
netfilter but...

  I have written a realtime operating system that included
  a stateless ip network driver. It was for a course at school.

  I am the author of the Ragel State Machine Compiler
  (http://www.essemage.com/ragel/). State machines are very useful for
  matching a large number of diverse patterns very efficiently.

This leads me to my question. Would the netfilter project benefit from
code that built state machines from high-level descriptions of packets
that would recognise and ultimately route many different types of packets
on one pass?

Perhaps you have something like this implemented already?

-Adrian
