From: "Oleg A. Arkhanglelsky" <sysoleg@yandex.ru>
Subject: Re: Request for Testing: linux-2.6 port of pptp-conntrack-nat
Date: Sun, 24 Oct 2004 10:53:58 +0400 (MSD)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417B5186.00001D.32078@pantene.yandex.ru>
References: <20041022161242.GG3551@sunbeam.de.gnumonks.org>
Reply-To: sysoleg@yandex.ru
Mime-Version: 1.0
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20041022161242.GG3551@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello Harald,

>At the moment I don't have the time to build a full test network and
>test with various PPTP implementations.  If somebody is interested,
>please go ahead and send bugreports :)

Thanks for port! It compiled cleanly and without any warnings. Now into the problem. I have installation with PopTop PPTPD and iptables, i.e. one PC is performing functions of Firewall-NAT server and PPTP-server. When I have all this modules loaded (ip_nat_proto_gre, ip_nat_pptp, ip_conntrack_pptp, ip_conntrack_proto_gre) and trying connect to this "PPTP+iptables" server - I get nothing. :( But when I unload ip_nat_pptp, everything works fine! Here is tcpdump output of failed session:

10:48:45.484747 IP 90.0.0.4.1405 > 90.0.0.254.1723: S 1124877844:1124877844(0) win 65535 <mss 1460,nop,nop,sackOK>
10:48:45.484837 IP 90.0.0.254.1723 > 90.0.0.4.1405: S 3889427060:3889427060(0) ack 1124877845 win 5840 <mss 1460,nop,nop,sackOK>
10:48:45.485051 IP 90.0.0.4.1405 > 90.0.0.254.1723: . ack 1 win 65535
10:48:45.485102 IP 90.0.0.4.1405 > 90.0.0.254.1723: P 1:157(156) ack 1 win 65535: pptp CTRL_MSGTYPE=SCCRQ PROTO_VER(1.0) FRAME_CAP(A) BEARER_CAP(A) MAX_CHAN(0) FIRM_REV(2195) [|pptp]
10:48:45.485134 IP 90.0.0.254.1723 > 90.0.0.4.1405: . ack 157 win 5840
10:48:45.487146 IP 90.0.0.254.1723 > 90.0.0.4.1405: P 1:157(156) ack 157 win 5840: pptp CTRL_MSGTYPE=SCCRP PROTO_VER(1.0) RESULT_CODE(1) ERR_CODE(0) FRAME_CAP() BEARER_CAP() MAX_CHAN(1) FIRM_REV(1) [|pptp]
10:48:45.487430 IP 90.0.0.4.1405 > 90.0.0.254.1723: P 157:325(168) ack 157 win 65379: pptp CTRL_MSGTYPE=OCRQ CALL_ID(16384) CALL_SER_NUM(47509) MIN_BPS(300) MAX_BPS(100000000) BEARER_TYPE(Any) FRAME_TYPE(E) RECV_WIN(64) PROC_DELAY(0) PHONE_NO_LEN(0) [|pptp]
10:48:45.491531 IP 90.0.0.254.1723 > 90.0.0.4.1405: P 157:189(32) ack 325 win 5840: pptp CTRL_MSGTYPE=OCRP CALL_ID(1792) PEER_CALL_ID(0) RESULT_CODE(1) ERR_CODE(0) CAUSE_CODE(0) CONN_SPEED(100000000) RECV_WIN(64) PROC_DELAY(0) PHY_CHAN_ID(0)
10:48:45.504489 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 0 gre-ppp-payload
10:48:45.639054 IP 90.0.0.4.1405 > 90.0.0.254.1723: . ack 189 win 65347
10:48:48.505050 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 1 gre-ppp-payload
10:48:51.505515 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 2 gre-ppp-payload
10:48:54.506055 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 3 gre-ppp-payload
10:48:57.506602 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 4 gre-ppp-payload
10:49:00.507154 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 5 gre-ppp-payload
10:49:03.507693 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 6 gre-ppp-payload
10:49:06.508228 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 7 gre-ppp-payload
10:49:09.508775 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 8 gre-ppp-payload
10:49:12.509316 IP 90.0.0.254 > 90.0.0.4: call 1405 seq 9 gre-ppp-payload
10:49:15.516398 IP 90.0.0.254.1723 > 90.0.0.4.1405: F 189:189(0) ack 325 win 5840
10:49:15.516627 IP 90.0.0.4.1405 > 90.0.0.254.1723: F 325:325(0) ack 190 win 65347
10:49:15.516683 IP 90.0.0.254.1723 > 90.0.0.4.1405: . ack 326 win 5840

If you need more info, just let me know!
Thanks again!

-- 
wbr, Oleg.
