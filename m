From: Stindl Wolfgang EXT <Wolfgang.Stindl.extern@icn.siemens.de>
Subject: MARK target
Date: Tue, 14 Dec 2004 12:29:14 +0100
Message-ID: <47D438A0510BD611B9470002A58EDAE70770A82A@mchh2a6e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi,

When I try to enter an iptables rule with the MARK target, I get the following error

Iptables: Target problem
(the console shows MARK: targinfosize 4 != 8)

How can I solve this problem?

Kernel: 2.4.26 smp
Iptables v 1.2.11

Thanks a lot
Wolfgang

Here is the verbose output:

devil:/usr/src/linux# iptables -I FORWARD -j MARK --set-mark 0x8 -vvv
MARK  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  MARK set 0x8
libiptc v1.2.11.  6 entries, 1036 bytes.
Table `filter'
Hooks: pre/in/fwd/out/post = 0/0/156/696/0
Underflows: pre/in/fwd/out/post = 0/0/540/696/0
Entry 0 (0):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 17315 packets, 4575183 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 1 (156):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `MARK' [36]

Entry 2 (312):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00004000 UNKNOWN
Match name: `mark'
Target name: `LOG' [64]

Entry 3 (540):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 4 (696):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 16414 packets, 4505913 bytes
Cache: 00000000
Target name: `' [36]
verdict=NF_ACCEPT

Entry 5 (852):
SRC IP: 0.0.0.0/0.0.0.0
DST IP: 0.0.0.0/0.0.0.0
Interface: `'/................to `'/................
Protocol: 0
Flags: 00
Invflags: 00
Counters: 0 packets, 0 bytes
Cache: 00000000
Target name: `ERROR' [64]
error=`ERROR'

iptables: Target problem
