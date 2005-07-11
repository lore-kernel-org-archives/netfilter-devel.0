From: Oscar Mechanic <oscar@ufomechanic.net>
Subject: bandwidth saving idea
Date: Mon, 11 Jul 2005 14:16:42 +0100
Message-ID: <1121087802.4967.35.camel@OSCARLAPLIN>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
	<42C853F4.6010702@outerspace.dyndns.org>
Reply-To: oscar@ufomechanic.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42C853F4.6010702@outerspace.dyndns.org>
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

Hi

   You could suggest the mail should go to LARTC but as I intend to use
netfilter codebase. You may consider this to be daft

Simple scenario

I have machines one is alabama and the other in berkley called machine A
and machine B they are both routers.

machine A has a serial number A000 and machine B has a serial number
B000.

machine A and machine B send packets to each other all the time as they
belong to the same business. These may be citrix packets POP packets
etc...

Machine A sends a packet to machine B. As the packet passes through
machine A it records the MD5 checksum on the packet and holds it in
memory. Machine B is doing the same (All packets sent from A the
checksums are recorded) and it is holding the payload aswell. The key
for finding the payload is the checksum. 

For simplicity lets say the max size of the (FIFO)list in memory is
1000. 

If the same packet is sent again through A it does not send the payload
to Machine B but sends the checksum. B sees the checksum finds the
payload and replaces the checksum with the payload.

(This should work! but it only becomes useful if you can do it with a
list of checksums in the one packet)

If I am not mistaken I can do this with QUEUE target and then turn it
into a module.


Opinions anyone ? 
  
