From: "Costa Tsaousis" <costa@tsaousis.gr>
Subject: Corruption on mangle/INPUT when MARKing packets
Date: Sat, 4 Jan 2003 03:47:21 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8bit
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

Hi all, and happy new year...

I am the author of FireHOL (http://firehol.sf.net) an iptables firewall
generator. During a few experiments I made I believe I have found a bug in
iptables. I am very sorry if it has already been fixed, but I searched
last year's list archives and I didn't find it.

To reproduce the bug, type:

# /etc/init.d/iptables stop
# iptables -t mangle -A INPUT -p icmp -j MARK --set-mark 1

Now, this host will be unpingable.
If INPUT is changed to PREROUTING, pings work.

kernel: 2.4.18-19.8.0smp
iptables: 1.2.6a
Distro: RedHat 8.0

I experimented a bit more and found the following:

[root@194.30.193.23]# ping -c 1 195.97.5.206

Entries bellow belong to the log of 195.97.5.206
------------------------------------------------
[request] everything ok here
Jan  4 02:34:57 gateway kernel: PREROUTING/mangle [1]: IN=ppp0 OUT= MAC=
SRC=194.30.193.23 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=61 ID=0
DF PROTO=ICMP TYPE=8 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: PREROUTING/nat    [1]: IN=ppp0 OUT= MAC=
SRC=194.30.193.23 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=61 ID=0
DF PROTO=ICMP TYPE=8 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: INPUT/mangle [2]: IN=ppp0 OUT= MAC=
SRC=194.30.193.23 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=61 ID=0
DF PROTO=ICMP TYPE=8 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: INPUT/filter [2]: IN=ppp0 OUT= MAC=
SRC=194.30.193.23 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=61 ID=0
DF PROTO=ICMP TYPE=8 CODE=0 ID=34827 SEQ=0

[reply] !!! here is the error: source and destination are the same, TYPE
is 0, output device is lo.
Jan  4 02:34:57 gateway kernel: OUTPUT/mangle [4]: IN= OUT=lo
SRC=195.97.5.206 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466
PROTO=ICMP TYPE=0 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: OUTPUT/filter [4]: IN= OUT=lo
SRC=195.97.5.206 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466
PROTO=ICMP TYPE=0 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: POSTROUTING/mangle [5]: IN= OUT=lo
SRC=195.97.5.206 DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466
PROTO=ICMP TYPE=0 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: PREROUTING/mangle [1]: IN=lo OUT=
MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=195.97.5.206
DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466 PROTO=ICMP
TYPE=0 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: INPUT/mangle [2]: IN=lo OUT=
MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=195.97.5.206
DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466 PROTO=ICMP
TYPE=0 CODE=0 ID=34827 SEQ=0
Jan  4 02:34:57 gateway kernel: INPUT/filter [2]: IN=lo OUT=
MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=195.97.5.206
DST=195.97.5.206 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=9466 PROTO=ICMP
TYPE=0 CODE=0 ID=34827 SEQ=0

Keep up the good work...

Kind Regards
Costa Tsaousis
