From: Chris Lowth <chris@lowth.com>
Subject: "rope" match module
Date: Tue, 2 Nov 2004 13:46:36 +0000 (GMT)
Message-ID: <Pine.LNX.4.44.0411021326590.16749-100000@stirling.lowth.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I have been working for a while on a match module that provides the 
facility of matching packets based on a simple pseduo-scripting language 
compiled in user-land and executed in kernel-land.

So far, the mechanism is outlined (incompletely) in an on-line power-point
presentation (sorry!) and the code exists on one non-mission-critical
development server. Source code will be released (I hope) in the next few 
weeks.

The reason for this note is to ask whether anyone has the time and
inclination to make any comments on the design of the ideas behind the
module (http://www.lowth.com/rope).

The basic mechanism for setting up a packet match rule using ROPE is..

1. Write the rope script

2. Copy the script to /etc/rope.d/scripts

3. Compile and pass it to the kernel using the "iptables" command, like
   this (to drop packets from morphus p2p protocol)..

		iptables -m rope --script morpheus -j DROP

The "compiled" format is binary but not machine code. Language features 
are limited to those needed for packet matching - this is not a general 
purpose kernel scripting language (although it could be, at a pinch).

The module provides access to the IP and UDP/TCP header and data payload.
It will eventually link with conntrack to allow conection-context data to
be manipulated as well.

So far - the language is not complete enough to site any but the simplest 
of working examples - but it's getting there. Here's a VERY simple test 
for web traffic, based on the protocol type and port number (yes - I know 
there is a FAR easier way to do this - this is just a test example).

 if (
	$ip_protocol 6 eq  # tcp?
	$tcp_dest 80 eq    # http?
		and
	{ yes } { no }
) do

The idea for the name "rope" comes from the concept of a "stronger string" 
and also plays to the fact that the scripting language is REverse POlish 
(partial anagram).

Chris.
