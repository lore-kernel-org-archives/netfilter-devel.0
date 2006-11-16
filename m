From: Ion Alberdi <ialberdi@laas.fr>
Subject: Dynamic DNAT ing
Date: Thu, 16 Nov 2006 18:28:37 +0100
Message-ID: <20061116172837.GB18645@laas.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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



Hi every body, 

We would like to use netfilter for dynamically DNAT ing some ip addresses.
More precisely, if we have this network, composed of two computers on the
same LAN: 
- host,fake_server.
and a gateway:
- gw.

What we want to do is when host is targeting a server:
* redirect this connection to fake_server
* or drop it.


We want to be as flexible as possible to implement the algorithm that will tell us
to drop or to redirect the connection. 

For these flexibility reasons, we have been using libipq.

In this example we will only talk about the problem we have
to redirect TCP flows.

To do so, we first to put the rule:
iptables -A FORWARD -s <host> -J QUEUE

Then we made a program that uses libipq, that accepts randomly to redirect packets.

When the libq program wants to redirect the packet to the destination <server>, this programs inserts
the following rule:

iptables -t nat -A PREROUTING -s <host> -d <server> -j DNAT --to-destination <fake_server>

and tells netfilter to accept the packet.

The problem is that the SYN segment we received will not pass from the the PREROUTING chain(as PREROUTING is before FORWARD
and our SYN is already in FORWARD), and so netfitler will wait for another SYN to create the state machine 
that will redirect these connections.


If the program that runs on host resends a SYN after a timeout, the redirection will work
but we'll have to wait for this timeout.
If the program doesn't retransmit SYNs, the redirection will not work.

Do you have any idea of how we could put this system in place without having to wait for another SYN ?
The problem we have is that the FORWARD chain is after the PREROUTING chain, and that we have not been able
to send packets to userspace before the PREROUTING chain (can we create a chain before PREROUTING ?)


Thanks in advance and best regards !

P.S: A solution we tested and that worked, consisted in asking a server on the same lan that opens a raw socket,
by sending him this SYN segment, to resend us the same segment (this server will spoof <host>), but we 
find this solution quite nasty and are trying to do something nicer.


-- 
Ion Alberdi,Eric Alata,Vincent Nicomette
LAAS/CNRS - Groupe OLC/TSF
Email: (ialberdi|ealata|nicomett)[at]laas.fr
