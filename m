From: "Nikolai Dahlem" <listuser@epygi.de>
Subject: NAT problem with related connections
Date: Thu, 30 Oct 2003 11:31:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <DAELKAPIKOFAFFKELNHOAEAHCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

this is (still ;-))my setup:
Host1(172.30.8.100) --> Masq(172.30.8.1/10.20.10.213) --> Server(10.20.0.14)
<-- Host2(10.20.10.198)

A Master connection is established between Host1 and Server.
Host1 and Host2 negotiate connection parameters via the Server.
Then related data connections are established between Host1 and Host2
directly.
The control-connection is established and an expectation is created.
The related connections work in some cases, the problem is that NAT changes
the source port.

example:
1. master connection with one data connection
udp      17 3598 src=172.30.8.100 dst=10.20.0.14 sport=5060 dport=5060
src=10.20.0
.14 dst=10.20.10.213 sport=5060 dport=5060 [ASSURED] use=2
udp      17 177 src=10.20.10.198 dst=10.20.10.213 sport=5004 dport=5024
src=172.30
.8.100 dst=10.20.10.198 sport=5024 dport=5004 [ASSURED] use=1

2. master connection with two data connections
udp      17 3596 src=172.30.8.100 dst=10.20.0.14 sport=5060 dport=5060
src=10.20.0
.14 dst=10.20.10.213 sport=5060 dport=5060 [ASSURED] use=3
udp      17 138 src=10.20.10.198 dst=10.20.10.213 sport=5004 dport=5024
src=172.30
.8.100 dst=10.20.10.198 sport=5024 dport=5004 [ASSURED] use=1
udp      17 176 src=10.20.10.198 dst=10.20.10.213 sport=5006 dport=5026
src=172.30
.8.100 dst=10.20.10.198 sport=5026 dport=5006 [ASSURED] use=1

3. master connections with two data connections and one with a changed port
udp      17 3597 src=172.30.8.100 dst=10.20.0.14 sport=5060 dport=5060
src=10.20.0
.14 dst=10.20.10.213 sport=5060 dport=5060 [ASSURED] use=3
udp      17 103 src=10.20.10.198 dst=10.20.10.213 sport=5004 dport=5024
src=172.30
.8.100 dst=10.20.10.198 sport=5024 dport=5004 [ASSURED] use=1
udp      17 141 src=10.20.10.198 dst=10.20.10.213 sport=5006 dport=5026
src=172.30
.8.100 dst=10.20.10.198 sport=5026 dport=5006 [ASSURED] use=1
udp      17 27 src=172.30.8.100 dst=10.20.10.198 sport=5028 dport=5008
[UNREPLIED]
 src=10.20.10.198 dst=10.20.10.213 sport=5008 dport=1024 use=1
udp      17 26 src=10.20.10.198 dst=10.20.10.213 sport=5008 dport=5028
[UNREPLIED]
 src=10.20.10.213 dst=10.20.10.198 sport=5028 dport=5008 use=1
EXPECTING: 4987 use=1 proto=17 src=10.20.10.198 dst=10.20.10.213 sport=5008
dport=
5028

As one can see the expected reply for the 3. data connection has dport=1024,
thus the reply send by server (using the negotiated parameters) doesn't
establish a connection (thus the expectation isn't met).
Is there a way to know/reserve ports that nat uses for a certain connection
? or is there a way to tell nat which port to use ?


kind regards


Nikolai Dahlem
