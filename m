From: n_dahlem@gmx.net
Subject: nat: expected connection only works one way
Date: Mon, 27 Oct 2003 15:28:09 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <26158.1067264889@www3.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
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

This is my setup:
Host1(172.30.8.100) --> Masq(172.30.8.1/10.20.10.213) --> Server(10.20.0.14)
<-- Host2(10.20.10.198)
                 
<-------------------------------------------------------------------  

A Master connection is established between Host1 and Server.
Host1 and Host2 negotiate connection parameters via the Server.
Then related data connections are established between Host1 and Host2
directly.

The control-connection is established and an expectation is created:
> conntrack: help: expect_related 10.20.10.213:5006-10.20.10.198:5020

cat /proc/net/ip_conntrack shows:
> EXPECTING: 4979 use=1 proto=17 src=10.20.10.198 dst=10.20.10.213
sport=5020 dport=5006

I receive packets on the related connection, the log shows:
> nat_expected: were in
> nat_expected: We have a connection!
> master ORIG tuple c1f48060: 17 172.30.8.100:33161216 0 -> 10.20.0.14:0
> master REPLY tuple c1f48090: 17 10.20.0.14:331612160 -> 10.20.10.213:0
> ct ORIG tuple c1f485e0: 17 10.20.10.198:32899072 0 -> 10.20.10.213:0
> ct REPLY tuple c1f48610: 17 10.20.10.213:32807321 6 -> 10.20.10.198:0
> nat_expected: connection 10.20.10.198->172.30.8.100
> MANIP_DST
> nat_expected: IP to 172.30.8.100
.....
> nat_expected: were in
> nat_expected: We have a connection!
> master ORIG tuple c1f48060: 17 172.30.8.100:33161216 0 -> 10.20.0.14:0
> master REPLY tuple c1f48090: 17 10.20.0.14:331612160 -> 10.20.10.213:0
> ct ORIG tuple c1f485e0: 17 10.20.10.198:32899072 0 -> 10.20.10.213:0
> ct REPLY tuple c1f48610: 17 172.30.8.100:32807321 6 -> 10.20.10.198:0
> nat_expected: connection 10.20.10.198->172.30.8.100
> MANIP_SRC
> nat_expected: IP to 10.20.10.198

Using Ethereal between Host2 and Masq I see packets:
10.20.10.198:5020 -> 10.20.10.213:5006

Sniffing between Masq and Host1, one can see that the packets coming from
host2 get nat'd and an answer is send:
10.20.10.198:5020 -> 172.30.8.100:5006
172.30.8.100:5006 -> 10.20.10.213:5020

/proc/net/ip_conntrack shows:
> udp      17 27 src=10.20.10.198 dst=10.20.10.213 sport=5020 dport=5006
[UNREPLIED]
> src=172.30.8.100 dst=10.20.10.198 sport=5006 dport=5020 use=1
> udp      17 27 src=172.30.8.100 dst=10.20.10.213 sport=5006 dport=5020
[UNREPLIED]
> src=10.20.10.213 dst=172.30.8.100 sport=5020 dport=5006 use=1

The answer isn't nat'd and never reaches the other side. 

What am I missing ?


kind regards

Nikolai

-- 
NEU FÜR ALLE - GMX MediaCenter - für Fotos, Musik, Dateien...
Fotoalbum, File Sharing, MMS, Multimedia-Gruß, GMX FotoService

Jetzt kostenlos anmelden unter http://www.gmx.net

+++ GMX - die erste Adresse für Mail, Message, More! +++
