From: Martin =?ISO-8859-1?Q?Rosenm=FCller?= <martin.rosenmueller@gmx.de>
Subject: Possible bug in conntrack
Date: Thu, 19 Jul 2007 09:21:04 +0200
Message-ID: <1184829664.3016.46.camel@laptop.home.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-YKQwghR9ywoIf/WidWY1"
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


--=-YKQwghR9ywoIf/WidWY1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

we are planning to build a loadsharing cluster of nodes based on
iptables CLUSTERIP target.

In our tests some real strange things happended.
For simplicity i will explain the problem with only one active node in
the cluster.
My configuration on the cluster node was:

	- eth0 had 172.16.29.121 (real ip of the node)
	- eth0:1 had 172.16.29.200 (virtual cluster ip)
	- the clustered service was tcp port 80 (http) (other ports didn't work
also)
	- please find my firewall-configuration script attached
	- the firewall works as follows:
		- first the stateful rule match ctstate in state	 ESTABLISHED, RELATED
		- then the stateful rule match ctstate in state INVALID
		- afterwards the CLUSTERIP target rule
		- followed by the rule to accept new connections on the virtual
cluster ip on port 80
		- finally the clean up rule to drop all traffic that didn't match up
to now

Surely i didn't forget to enter "echo +2
> /proc/net/ipt_CLUSTERIP/172.16.29.200" to accept all cluster traffic
on the only active node, the webserver was running and bind to the real
and the virtual cluster ip.

If you than connect to the cluster on the virtual ip 172.16.29.200 from
a client node on the same net (client has ip 172.16.29.211), you will
almost get no answer (client.pcap). The cluster node seems not to accept
any traffic than the first syn packet, although it answers with syn,ack.
Please see the network dump attached (clusternode.pcap). We have checked
the multicast mac, which seems to be ok. Logging in messages (messages)
is OK, too. All packets arriving the cluster node after the syn packet
are accepted by conntrack in state ESTABLISHED, which also seems to be
OK. In /proc/net/nf_conntrack you see the connection marked as state
ESTABLISHED, too.

Furthermore we tried to enter a static arp entry for the virtual cluster
ip on the client node, that points to the multicast mac. Same result.
But if you statically enter the real mac of the cluster node's interface
on the client node, see there, it works perfectly.

Is that possible a bug in conntrack?

Best,
Martin






--=-YKQwghR9ywoIf/WidWY1
Content-Disposition: attachment; filename=client.pcap
Content-Type: application/octet-stream; name=client.pcap
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAdPGeRgTuCAA+AAAAPgAAAAEAXgAAIAAEdhNgHAgARQAA
MI+6QACABtdRrBAd06wQHcgH0QBQJHxSNAAAAABwAkAAMJIAAAIEBbQBAQQCdPGeRijwCAA+AAAA
PgAAAAAEdhNgHAAODHDE5AgARQAAMAAAQABABqcMrBAdyKwQHdMAUAfRMJNGmiR8UjVwEhbQ4oMA
AAIEBbQBAQQCdPGeRqPwCAA2AAAANgAAAAEAXgAAIAAEdhNgHAgARQAAKI+7QACABtdYrBAd06wQ
HcgH0QBQJHxSNTCTRptQEERw4acAAHTxnkaEBwoASQIAAEkCAAABAF4AACAABHYTYBwIAEUAAjuP
vEAAgAbVRKwQHdOsEB3IB9EAUCR8UjUwk0abUBhEcFEgAABHRVQgLyBIVFRQLzEuMQ0KSG9zdDog
MTcyLjE2LjI5LjIwMA0KVXNlci1BZ2VudDogTW96aWxsYS81LjAgKFdpbmRvd3M7IFU7IFdpbmRv
d3MgTlQgNS4yOyBkZTsgcnY6MS44LjEpIEdlY2tvLzIwMDYxMDEwIEZpcmVmb3gvMi4wDQpBY2Nl
cHQ6IHRleHQveG1sLGFwcGxpY2F0aW9uL3htbCxhcHBsaWNhdGlvbi94aHRtbCt4bWwsdGV4dC9o
dG1sO3E9MC45LHRleHQvcGxhaW47cT0wLjgsaW1hZ2UvcG5nLCovKjtxPTAuNQ0KQWNjZXB0LUxh
bmd1YWdlOiBkZS1kZSxkZTtxPTAuOCxlbi11cztxPTAuNSxlbjtxPTAuMw0KQWNjZXB0LUVuY29k
aW5nOiBnemlwLGRlZmxhdGUNCkFjY2VwdC1DaGFyc2V0OiBJU08tODg1OS0xLHV0Zi04O3E9MC43
LCo7cT0wLjcNCktlZXAtQWxpdmU6IDMwMA0KQ29ubmVjdGlvbjoga2VlcC1hbGl2ZQ0KSWYtTW9k
aWZpZWQtU2luY2U6IFR1ZSwgMjIgTWF5IDIwMDcgMjM6MzI6MjggR01UDQpJZi1Ob25lLU1hdGNo
OiAiMTE3OTBlLWY2Yy03NjcxN2IwMCINCkNhY2hlLUNvbnRyb2w6IG1heC1hZ2U9MA0KDQp38Z5G
K6MKAD4AAAA+AAAAAAR2E2AcAA4McMTkCABFAAAwAABAAEAGpwysEB3IrBAd0wBQB9Ewk0aaJHxS
NXASFtDigwAAAgQFtAEBBAJ38Z5GlqMKADYAAAA2AAAAAQBeAAAgAAR2E2AcCABFAAAoj71AAIAG
11asEB3TrBAdyAfRAFAkfFRIMJNGm1AQRHDflAAAd/GeRhqEDABJAgAASQIAAAEAXgAAIAAEdhNg
HAgARQACO4++QACABtVCrBAd06wQHcgH0QBQJHxSNTCTRptQGERwUSAAAEdFVCAvIEhUVFAvMS4x
DQpIb3N0OiAxNzIuMTYuMjkuMjAwDQpVc2VyLUFnZW50OiBNb3ppbGxhLzUuMCAoV2luZG93czsg
VTsgV2luZG93cyBOVCA1LjI7IGRlOyBydjoxLjguMSkgR2Vja28vMjAwNjEwMTAgRmlyZWZveC8y
LjANCkFjY2VwdDogdGV4dC94bWwsYXBwbGljYXRpb24veG1sLGFwcGxpY2F0aW9uL3hodG1sK3ht
bCx0ZXh0L2h0bWw7cT0wLjksdGV4dC9wbGFpbjtxPTAuOCxpbWFnZS9wbmcsKi8qO3E9MC41DQpB
Y2NlcHQtTGFuZ3VhZ2U6IGRlLWRlLGRlO3E9MC44LGVuLXVzO3E9MC41LGVuO3E9MC4zDQpBY2Nl
cHQtRW5jb2Rpbmc6IGd6aXAsZGVmbGF0ZQ0KQWNjZXB0LUNoYXJzZXQ6IElTTy04ODU5LTEsdXRm
LTg7cT0wLjcsKjtxPTAuNw0KS2VlcC1BbGl2ZTogMzAwDQpDb25uZWN0aW9uOiBrZWVwLWFsaXZl
DQpJZi1Nb2RpZmllZC1TaW5jZTogVHVlLCAyMiBNYXkgMjAwNyAyMzozMjoyOCBHTVQNCklmLU5v
bmUtTWF0Y2g6ICIxMTc5MGUtZjZjLTc2NzE3YjAwIg0KQ2FjaGUtQ29udHJvbDogbWF4LWFnZT0w
DQoNCnrxnkbQBAMAuwEAALsBAAABAF4AACAABHYTYBwIAEUAAa2PwUAAgAbVzawQHdOsEB3IB9AA
UFq/Nkss0s9XUBlEcPw2AABHRVQgL2ltYWdlcy9uYXZfbG9nbzMucG5nIEhUVFAvMS4xDQpIb3N0
OiAxNzIuMTYuMjkuMjAwDQpVc2VyLUFnZW50OiBNb3ppbGxhLzUuMCAoV2luZG93czsgVTsgV2lu
ZG93cyBOVCA1LjI7IGRlOyBydjoxLjguMSkgR2Vja28vMjAwNjEwMTAgRmlyZWZveC8yLjANCkFj
Y2VwdDogaW1hZ2UvcG5nLCovKjtxPTAuNQ0KQWNjZXB0LUxhbmd1YWdlOiBkZS1kZSxkZTtxPTAu
OCxlbi11cztxPTAuNSxlbjtxPTAuMw0KQWNjZXB0LUVuY29kaW5nOiBnemlwLGRlZmxhdGUNCkFj
Y2VwdC1DaGFyc2V0OiBJU08tODg1OS0xLHV0Zi04O3E9MC43LCo7cT0wLjcNCktlZXAtQWxpdmU6
IDMwMA0KQ29ubmVjdGlvbjoga2VlcC1hbGl2ZQ0KUmVmZXJlcjogaHR0cDovLzE3Mi4xNi4yOS4y
MDAvDQoNCn3xnkYa/A0APgAAAD4AAAAABHYTYBwADgxwxOQIAEUAADAAAEAAQAanDKwQHcisEB3T
AFAH0TCTRpokfFI1cBIW0OKDAAACBAW0AQEEAn3xnkaD/A0ANgAAADYAAAABAF4AACAABHYTYBwI
AEUAACiPwkAAgAbXUawQHdOsEB3IB9EAUCR8VEgwk0abUBBEcN+UAAB+8Z5GOtoAAEkCAABJAgAA
AQBeAAAgAAR2E2AcCABFAAI7j8NAAIAG1T2sEB3TrBAdyAfRAFAkfFI1MJNGm1AYRHBRIAAAR0VU
IC8gSFRUUC8xLjENCkhvc3Q6IDE3Mi4xNi4yOS4yMDANClVzZXItQWdlbnQ6IE1vemlsbGEvNS4w
IChXaW5kb3dzOyBVOyBXaW5kb3dzIE5UIDUuMjsgZGU7IHJ2OjEuOC4xKSBHZWNrby8yMDA2MTAx
MCBGaXJlZm94LzIuMA0KQWNjZXB0OiB0ZXh0L3htbCxhcHBsaWNhdGlvbi94bWwsYXBwbGljYXRp
b24veGh0bWwreG1sLHRleHQvaHRtbDtxPTAuOSx0ZXh0L3BsYWluO3E9MC44LGltYWdlL3BuZywq
Lyo7cT0wLjUNCkFjY2VwdC1MYW5ndWFnZTogZGUtZGUsZGU7cT0wLjgsZW4tdXM7cT0wLjUsZW47
cT0wLjMNCkFjY2VwdC1FbmNvZGluZzogZ3ppcCxkZWZsYXRlDQpBY2NlcHQtQ2hhcnNldDogSVNP
LTg4NTktMSx1dGYtODtxPTAuNywqO3E9MC43DQpLZWVwLUFsaXZlOiAzMDANCkNvbm5lY3Rpb246
IGtlZXAtYWxpdmUNCklmLU1vZGlmaWVkLVNpbmNlOiBUdWUsIDIyIE1heSAyMDA3IDIzOjMyOjI4
IEdNVA0KSWYtTm9uZS1NYXRjaDogIjExNzkwZS1mNmMtNzY3MTdiMDAiDQpDYWNoZS1Db250cm9s
OiBtYXgtYWdlPTANCg0KivGeRvzsBAA+AAAAPgAAAAAEdhNgHAAODHDE5AgARQAAMAAAQABABqcM
rBAdyKwQHdMAUAfRMJNGmiR8UjVwEhbQ4oMAAAIEBbQBAQQCivGeRmbtBAA2AAAANgAAAAEAXgAA
IAAEdhNgHAgARQAAKI/GQACABtdNrBAd06wQHcgH0QBQJHxUSDCTRptQEERw35QAAIrxnkbejAcA
SQIAAEkCAAABAF4AACAABHYTYBwIAEUAAjuPx0AAgAbVOawQHdOsEB3IB9EAUCR8UjUwk0abUBhE
cFEgAABHRVQgLyBIVFRQLzEuMQ0KSG9zdDogMTcyLjE2LjI5LjIwMA0KVXNlci1BZ2VudDogTW96
aWxsYS81LjAgKFdpbmRvd3M7IFU7IFdpbmRvd3MgTlQgNS4yOyBkZTsgcnY6MS44LjEpIEdlY2tv
LzIwMDYxMDEwIEZpcmVmb3gvMi4wDQpBY2NlcHQ6IHRleHQveG1sLGFwcGxpY2F0aW9uL3htbCxh
cHBsaWNhdGlvbi94aHRtbCt4bWwsdGV4dC9odG1sO3E9MC45LHRleHQvcGxhaW47cT0wLjgsaW1h
Z2UvcG5nLCovKjtxPTAuNQ0KQWNjZXB0LUxhbmd1YWdlOiBkZS1kZSxkZTtxPTAuOCxlbi11cztx
PTAuNSxlbjtxPTAuMw0KQWNjZXB0LUVuY29kaW5nOiBnemlwLGRlZmxhdGUNCkFjY2VwdC1DaGFy
c2V0OiBJU08tODg1OS0xLHV0Zi04O3E9MC43LCo7cT0wLjcNCktlZXAtQWxpdmU6IDMwMA0KQ29u
bmVjdGlvbjoga2VlcC1hbGl2ZQ0KSWYtTW9kaWZpZWQtU2luY2U6IFR1ZSwgMjIgTWF5IDIwMDcg
MjM6MzI6MjggR01UDQpJZi1Ob25lLU1hdGNoOiAiMTE3OTBlLWY2Yy03NjcxN2IwMCINCkNhY2hl
LUNvbnRyb2w6IG1heC1hZ2U9MA0KDQqN8Z5Gg14DAD4AAAA+AAAAAAR2E2AcAA4McMTkCABFAAAw
AABAAEAGpwysEB3IrBAd0wBQB9As0s9WWr82S3ASFtBDMAAAAgQFtAEBBAKN8Z5G514DADYAAAA2
AAAAAQBeAAAgAAR2E2AcCABFAAAoj8hAAIAG10usEB3TrBAdyAfQAFBavzfRLNLPV1AQRHBAzgAA
lPGeRpiaCQA2AAAANgAAAAEAXgAAIAAEdhNgHAgARQAAKI/NQACABtdGrBAd06wQHcgH0QBQJHxU
SDCTRptQEURw35MAAA==


--=-YKQwghR9ywoIf/WidWY1
Content-Disposition: attachment; filename=clusternode.pcap
Content-Type: application/octet-stream; name=clusternode.pcap
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAGAAAAABAAAAXV2eRtNuCgA+AAAAPgAAAAEAXgAAIAAEdhNgHAgARQAA
MJBkQACABtanrBAd06wQHcgH0wBQNgBshQAAAABwAkAABLsAAAIEBbQBAQQCXV2eRuJuCgA+AAAA
PgAAAAAEdhNgHAAODHDE5AgARQAAMAAAQABABqcMrBAdyKwQHdMAUAfTOwqCHTYAbIZwEhbQcLIA
AAIEBbQBAQQCXV2eRuduCgA8AAAAPAAAAAEAXgAAIAAEdhNgHAgARQAAKJBlQACABtaurBAd06wQ
HcgH0wBQNgBshjsKgh5QEERwb9YAAAAAAAAAAF1dnkZ+gAoAYAAAAEkCAAABAF4AACAABHYTYBwI
AEUAAjuQZkAAgAbUmqwQHdOsEB3IB9MAUDYAbIY7CoIeUBhEcN9OAABHRVQgLyBIVFRQLzEuMQ0K
SG9zdDogMTcyLjE2LjI5LjIwMA0KVXNlci1gXZ5GJ2EKAGAAAABJAgAAAQBeAAAgAAR2E2AcCABF
AAI7kGhAAIAG1JisEB3TrBAdyAfTAFA2AGyGOwqCHlAYRHDfTgAAR0VUIC8gSFRUUC8xLjENCkhv
c3Q6IDE3Mi4xNi4yOS4yMDANClVzZXItYV2eRnkoAgA+AAAAPgAAAAAEdhNgHAAODHDE5AgARQAA
MAAAQABABqcMrBAdyKwQHdMAUAfTOwqCHTYAbIZwEhbQcLIAAAIEBbQBAQQCYV2eRkYpAgA8AAAA
PAAAAAEAXgAAIAAEdhNgHAgARQAAKJBpQACABtaqrBAd06wQHcgH0wBQNgBumTsKgh5QEERwbcMA
AAAAAAAAAGZdnkZ7mgoAYAAAAEkCAAABAF4AACAABHYTYBwIAEUAAjuQbEAAgAbUlKwQHdOsEB3I
B9MAUDYAbIY7CoIeUBhEcN9OAABHRVQgLyBIVFRQLzEuMQ0KSG9zdDogMTcyLjE2LjI5LjIwMA0K
VXNlci1nXZ5GLSECAD4AAAA+AAAAAAR2E2AcAA4McMTkCABFAAAwAABAAEAGpwysEB3IrBAd0wBQ
B9M7CoIdNgBshnASFtBwsgAAAgQFtAEBBAJnXZ5GNSICADwAAAA8AAAAAQBeAAAgAAR2E2AcCABF
AAAokG1AAIAG1qasEB3TrBAdyAfTAFA2AG6ZOwqCHlAQRHBtwwAAAAAAAAAAcl2eRiUNCwBgAAAA
SQIAAAEAXgAAIAAEdhNgHAgARQACO5BwQACABtSQrBAd06wQHcgH0wBQNgBshjsKgh5QGERw304A
AEdFVCAvIEhUVFAvMS4xDQpIb3N0OiAxNzIuMTYuMjkuMjAwDQpVc2VyLXNdnkaBEgIAPgAAAD4A
AAAABHYTYBwADgxwxOQIAEUAADAAAEAAQAanDKwQHcisEB3TAFAH0zsKgh02AGyGcBIW0HCyAAAC
BAW0AQEEAnNdnkYNFAIAPAAAADwAAAABAF4AACAABHYTYBwIAEUAACiQcUAAgAbWoqwQHdOsEB3I
B9MAUDYAbpk7CoIeUBBEcG3DAAAAAAAAAABzXZ5Gas4FAGAAAABJAgAAAQBeAAAgAAR2E2AcCABF
AAI7kHJAAIAG1I6sEB3TrBAdyAfSAFC9X17NN6pxMlAZRHB59AAAR0VUIC8gSFRUUC8xLjENCkhv
c3Q6IDE3Mi4xNi4yOS4yMDANClVzZXItdF2eRgrqBAA8AAAAPAAAAAEAXgAAIAAEdhNgHAgARQAA
KJB3QACABtacrBAd06wQHcgH0wBQNgBumTsKgh5QEURwbcIAAAAAAAAAAA==


--=-YKQwghR9ywoIf/WidWY1
Content-Disposition: attachment; filename=firewall-script
Content-Type: application/x-shellscript; name=firewall-script
Content-Transfer-Encoding: 7bit

#!/bin/sh

IPTABELS=/sbin/iptables
LOG_OPTIONS="--log-level debug --log-tcp-sequence --log-ip-options"

set_log() {
	ACCEPT=" -j ACCEPT" 
	ACCEPT_LOG=" -j ACCEPT_LOG"
	INVALID=" -j INVALID_LOG"
	DROP=" -j DROP_LOG" 
	ESTABLISHED_LOG=" -j ESTABLISHED_LOG"
	RELATED_LOG=" -j RELATED_LOG"

	$IPTABELS -N DROP_LOG
	$IPTABELS -A DROP_LOG -j LOG --log-prefix "Firewall DROP " $LOG_OPTIONS
	$IPTABELS -A DROP_LOG -j DROP

	$IPTABELS -N INVALID_LOG
	$IPTABELS -A INVALID_LOG -j LOG --log-prefix "Firewall INVALID DROP     " $LOG_OPTIONS
	$IPTABELS -A INVALID_LOG -j DROP

	$IPTABELS -N ACCEPT_LOG
	$IPTABELS -A ACCEPT_LOG -j LOG --log-prefix "Firewall ACCEPT " $LOG_OPTIONS
	$IPTABELS -A ACCEPT_LOG -j ACCEPT

	$IPTABELS -N ESTABLISHED_LOG
	$IPTABELS -A ESTABLISHED_LOG -j LOG --log-prefix "Firewall ESTABLISHED " $LOG_OPTIONS
	$IPTABELS -A ESTABLISHED_LOG -j ACCEPT
	
	$IPTABELS -N RELATED_LOG
	$IPTABELS -A RELATED_LOG -j LOG --log-prefix "Firewall RELATED " $LOG_OPTIONS
	$IPTABELS -A RELATED_LOG -j ACCEPT
}




set_default_stateful() {
	${IPTABELS} -A INPUT -i eth0 -p tcp --dport 80 -s 0.0.0.0/0 -d 172.16.29.200 -m conntrack --ctstate ESTABLISHED $ESTABLISHED_LOG
	${IPTABELS} -A INPUT -i eth0 -p tcp --dport 80 -s 0.0.0.0/0 -d 172.16.29.200 -m conntrack --ctstate RELATED $RELATED_LOG
	${IPTABELS} -A OUTPUT -o eth0 -p tcp --sport 80 -s 172.16.29.200 -d 0.0.0.0/0 -m conntrack --ctstate ESTABLISHED $ESTABLISHED_LOG
	${IPTABELS} -A OUTPUT -o eth0 -p tcp --sport 80 -s 172.16.29.200 -d 0.0.0.0/0 -m conntrack --ctstate RELATED $RELATED_LOG
	for chain in INPUT OUTPUT FORWARD; do
		${IPTABELS} -A $chain -s 0.0.0.0/0 -d 0.0.0.0/0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
		${IPTABELS} -A $chain -s 0.0.0.0/0 -d 0.0.0.0/0 -m conntrack --ctstate INVALID $INVALID
	done
}

accept_local_traffic() {
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 0.0.0.0/0  -i lo -j ACCEPT
	${IPTABELS} -A OUTPUT -s 0.0.0.0/0 -d 0.0.0.0/0 -o lo -j ACCEPT
}


show() {
	${IPTABELS} --list --line-numbers -nv | less
	less /proc/net/ip_conntrack
}	


set_clean_up(){
	for chain in INPUT OUTPUT FORWARD; do
		${IPTABELS} -A $chain -s 0.0.0.0/0 -d 0.0.0.0/0 $DROP
	done
}



start() {
	set_log
	set_default_stateful
	accept_local_traffic
	
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p tcp --dport 80 -j CLUSTERIP --new  \
		--hashmode sourceip-sourceport --clustermac 01:00:5e:00:00:20 --total-nodes 2 --local-node 1
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p tcp --dport 22 -j CLUSTERIP --new  \
		--hashmode sourceip-sourceport --clustermac 01:00:5e:00:00:20 --total-nodes 2 --local-node 1
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p icmp -j CLUSTERIP --new  \
		--hashmode sourceip-sourceport --clustermac 01:00:5e:00:00:20 --total-nodes 2 --local-node 1
	
	echo +2 > /proc/net/ipt_CLUSTERIP/172.16.29.200
	
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p tcp --dport 80 -m conntrack --ctstate NEW $ACCEPT_LOG
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p tcp --dport 22 -m conntrack --ctstate NEW $ACCEPT_LOG
	${IPTABELS} -A INPUT -s 0.0.0.0/0 -d 172.16.29.200 -i eth0 -p icmp -m conntrack --ctstate NEW $ACCEPT
	
	for chain in INPUT OUTPUT; do
		${IPTABELS} -A $chain -p all -s 0.0.0.0/0 -d 172.16.29.121 -m conntrack --ctstate NEW $ACCEPT
	done
	set_clean_up
}

stop() {
	for chain in INPUT OUTPUT FORWARD ACCEPT_LOG DROP_LOG INVALID_LOG ESTABLISHED_LOG RELATED_LOG; do
		${IPTABELS} --flush $chain
	done
	for chain in ACCEPT_LOG DROP_LOG INVALID_LOG ESTABLISHED_LOG RELATED_LOG; do
		${IPTABELS} -X $chain
	done
}


case "$1" in
    start)
        stop
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
	start
	;;
    show)
        show
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac





--=-YKQwghR9ywoIf/WidWY1
Content-Disposition: attachment; filename=messages
Content-Type: text/plain; name=messages; charset=UTF-8
Content-Transfer-Encoding: 7bit

Jul 18 20:34:38 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36859 DF PROTO=TCP SPT=2002 DPT=80 SEQ=3177144544 ACK=933916978 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:34:48 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36866 DF PROTO=TCP SPT=2002 DPT=80 SEQ=3177144544 ACK=933916978 WINDOW=17520 RES=0x00 ACK FIN URGP=0 
Jul 18 20:34:51 cltestn2 kernel: Firewall DROP IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.255 LEN=78 TOS=0x00 PREC=0x00 TTL=128 ID=36867 PROTO=UDP SPT=137 DPT=137 LEN=58 
Jul 18 20:34:52 cltestn2 kernel: device eth0 left promiscuous mode
Jul 18 20:34:52 cltestn2 kernel: device eth0 left promiscuous mode
Jul 18 20:34:52 cltestn2 kernel: Firewall DROP IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.255 LEN=78 TOS=0x00 PREC=0x00 TTL=128 ID=36871 PROTO=UDP SPT=137 DPT=137 LEN=58 
Jul 18 20:34:53 cltestn2 kernel: Firewall DROP IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.255 LEN=78 TOS=0x00 PREC=0x00 TTL=128 ID=36872 PROTO=UDP SPT=137 DPT=137 LEN=58 
Jul 18 20:35:01 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36908 DF PROTO=TCP SPT=2002 DPT=80 SEQ=3177144013 ACK=933916978 WINDOW=17520 RES=0x00 ACK PSH FIN URGP=0 
Jul 18 20:35:02 cltestn2 kernel: Firewall ESTABLISHED IN= OUT=eth0 SRC=172.16.29.200 DST=172.16.29.211 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=80 DPT=2002 SEQ=933916977 ACK=3177144013 WINDOW=5840 RES=0x00 ACK SYN URGP=0 
Jul 18 20:35:02 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36909 DF PROTO=TCP SPT=2002 DPT=80 SEQ=3177144545 ACK=933916978 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:35:07 cltestn2 kernel: device eth0 entered promiscuous mode
Jul 18 20:35:07 cltestn2 kernel: device eth0 entered promiscuous mode
Jul 18 20:35:09 cltestn2 kernel: hash=1 ct_hash=1 responsible
Jul 18 20:35:09 cltestn2 kernel: hash=1 ct_hash=1 responsible
Jul 18 20:35:09 cltestn2 kernel: Firewall ACCEPT IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=48 TOS=0x00 PREC=0x00 TTL=128 ID=36964 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997445 ACK=0 WINDOW=16384 RES=0x00 SYN URGP=0 
Jul 18 20:35:09 cltestn2 kernel: Firewall ESTABLISHED IN= OUT=eth0 SRC=172.16.29.200 DST=172.16.29.211 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=80 DPT=2003 SEQ=990544413 ACK=905997446 WINDOW=5840 RES=0x00 ACK SYN URGP=0 
Jul 18 20:35:09 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36965 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997446 ACK=990544414 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:35:09 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36966 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997446 ACK=990544414 WINDOW=17520 RES=0x00 ACK PSH URGP=0 
Jul 18 20:35:12 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36968 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997446 ACK=990544414 WINDOW=17520 RES=0x00 ACK PSH URGP=0 
Jul 18 20:35:13 cltestn2 kernel: Firewall ESTABLISHED IN= OUT=eth0 SRC=172.16.29.200 DST=172.16.29.211 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=80 DPT=2003 SEQ=990544413 ACK=905997446 WINDOW=5840 RES=0x00 ACK SYN URGP=0 
Jul 18 20:35:13 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36969 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997977 ACK=990544414 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:35:18 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36972 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997446 ACK=990544414 WINDOW=17520 RES=0x00 ACK PSH URGP=0 
Jul 18 20:35:19 cltestn2 kernel: Firewall ESTABLISHED IN= OUT=eth0 SRC=172.16.29.200 DST=172.16.29.211 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=80 DPT=2003 SEQ=990544413 ACK=905997446 WINDOW=5840 RES=0x00 ACK SYN URGP=0 
Jul 18 20:35:19 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36973 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997977 ACK=990544414 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:35:30 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36976 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997446 ACK=990544414 WINDOW=17520 RES=0x00 ACK PSH URGP=0 
Jul 18 20:35:31 cltestn2 kernel: Firewall ESTABLISHED IN= OUT=eth0 SRC=172.16.29.200 DST=172.16.29.211 LEN=48 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=80 DPT=2003 SEQ=990544413 ACK=905997446 WINDOW=5840 RES=0x00 ACK SYN URGP=0 
Jul 18 20:35:31 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36977 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997977 ACK=990544414 WINDOW=17520 RES=0x00 ACK URGP=0 
Jul 18 20:35:31 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=571 TOS=0x00 PREC=0x00 TTL=128 ID=36978 DF PROTO=TCP SPT=2002 DPT=80 SEQ=3177144013 ACK=933916978 WINDOW=17520 RES=0x00 ACK PSH FIN URGP=0 
Jul 18 20:35:32 cltestn2 kernel: Firewall ESTABLISHED IN=eth0 OUT= MAC=01:00:5e:00:00:20:00:04:76:13:60:1c:08:00 SRC=172.16.29.211 DST=172.16.29.200 LEN=40 TOS=0x00 PREC=0x00 TTL=128 ID=36983 DF PROTO=TCP SPT=2003 DPT=80 SEQ=905997977 ACK=990544414 WINDOW=17520 RES=0x00 ACK FIN URGP=0 
Jul 18 20:35:35 cltestn2 kernel: device eth0 left promiscuous mode
Jul 18 20:35:35 cltestn2 kernel: device eth0 left promiscuous mode

--=-YKQwghR9ywoIf/WidWY1--
