From: Henrik Nordstrom <hno@marasystems.com>
Subject: TCP tracking states
Date: Sat, 6 Jul 2002 00:38:59 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207060038.59577@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The recent discussions and Oskar Andreassons work on a iptables 
tutorial made me take a closer look into the TCP tracking states, and 
I notices a couple of odd things that looks like they may be bugs..


1. What is the use of LAST_ACK? From what I can tell this state can 
only be reached if the connection is already in the LAST_ACK state..

2. The support for half-closed connections is very poor, and differs a 
lot depending on which side closed first.


To deal with 2, may I propose that the following symmetric FIN state 
machine is used instead of the odd assymetric one used today:


ESTABLISHED / FIN  -> FIN_WAIT

FIN_WAIT / ACK(R) -> CLOSE_WAIT

CLOSE_WAIT / FIN(R) -> TIME_WAIT (or a new FIN_WAIT2 state)

TIME_WAIT / ACK -> TIME_WAIT


And for completeness

FIN_WAIT / FIN(R) -> TIME_WAIT (or a new FIN_WAIT2 state)


Regards
Henrik
