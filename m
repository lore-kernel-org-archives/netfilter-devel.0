From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Linux 2.4.21-rc<x>-ac<y> network errors (machine lockup)
Date: 27 May 2003 14:25:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054038305.761.58.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.55.0305262012340.3476@onpx40.onqynaqf.bet>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard A Nelson <cowboy@vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.55.0305262012340.3476@onpx40.onqynaqf.bet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(Resending, sent it to the wrong address the first time, sorry about that)

I'm moving this to the correct list, netfilter-devel@lists.netfilter.org
This list is a closed list so before you post any mail you need to
subscribe (https://lists.netfilter.org)

Can you check if CONFIG_IP_MROUTE is enabled in your .config?

It looks like a forwarded multicast packet was looped back, that's what
causes the "ip_dev_loopback_xmit: bad owned skb" messages. It's just a
debugging message, nothing to worry about. But we need to shut that up.

But that doesn't explain the LIST_DELETE warning. We had a bunch of
these some time ago and then they disappeared. It might be compiler
related, which compiler are you using?

When we insert entries into ip_conntrack_hash we first search to see if
one of the entries already exists. If none exist we insert the entries,
so both entries should be there when we try to delete them.

On Tue, 2003-05-27 at 02:21, Richard A Nelson wrote:
> Every so often, my home box does this:
> 
> back40 kernel: ip_dev_loopback_xmit: bad owned skb = cbf61b40: 	PRE_ROUTING FORWARD POST_ROUTING
> back40 kernel: skb: pf=2 (unowned) dev=eth0 len=77
> back40 kernel: PROTO=17 192.168.0.1:32772 239.255.255.253:427 L=77 S=0x00 I=0 F=0x4000 T=7
> 
> back40 kernel: ip_dev_loopback_xmit: bad owned skb = d9731c80: PRE_ROUTING FORWARD POST_ROUTING
> back40 kernel: skb: pf=2 (unowned) dev=eth0 len=77
> back40 kernel: PROTO=17 192.168.0.1:32782 239.255.255.253:427 L=77 S=0x00 I=0 F=0x4000 T=7
> back40 kernel: LIST_DELETE: ip_conntrack_core.c:300
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(c0920ea4) not in &ip_conntrack_hash
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> back40 kernel: ip_dev_loopback_xmit: bad owned skb = ce073900: PRE_ROUTING FORWARD POST_ROUTING
> back40 kernel: skb: pf=2 (unowned) dev=eth0 len=77
> May 26 18:52:04 back40 kernel: PROTO=17 192.168.0.1:32785
> 239.255.255.253:427 L=77 S=0x00 I=0 F=0x4000 T=7
> 
> The machine will run a few minutes longer and the freeze hard (CAS B or
> reset switch is the only thing accepted).
> 
> This has happened with all -pre and -rc patches I can remember
> 
> $lspci
> 00:00.0 Host bridge: ALi Corporation M1541 (rev 04)
> 00:01.0 PCI bridge: ALi Corporation M1541 PCI to AGP Controller (rev 04)
> 00:02.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:03.0 Bridge: ALi Corporation M7101 PMU
> 00:07.0 ISA bridge: ALi Corporation M1533 PCI to ISA Bridge [Aladdin IV] (rev c3)
> 00:09.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 0d)
> 00:0a.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 0d)
> 00:0c.0 SCSI storage controller: BusLogic BT-946C (BA80C30) [MultiMaster 10] (rev 08)
> 00:0f.0 IDE interface: ALi Corporation M5229 IDE (rev c1)
-- 
/Martin
