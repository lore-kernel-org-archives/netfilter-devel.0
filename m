From: "Colin Paton" <cozzarp@hotmail.com>
Subject: PPTP connttrack problem - 'unexpecting' performed too early?
Date: Thu, 08 Apr 2004 10:59:19 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY13-F92qgIjOiwsN300050707@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi,

I've been trying to get GRE/PPTP connection tracking working between a 
Windows XP laptop and a Windows 2003 server machine. I've applied the PPTP 
patches to kernel 2.4.25.

The plan is to allow a PPTP VPN to work across a NAT Linux machine.

The GRE packets did not appear to be correctly NATted. I've done some 
debugging and think I know what is causing the problem, but am not quite 
sure of the correct way to solve it!

I think that the 'other expectation' is being deleted too early, as 
ip_ct_gre_keymap_destroy is being called before it should be (I think).

If I edit ip_conntrack_proto_gre.c to prevent the original key mapping from 
being destroyed, by commenting out the 'list_del' as follows:

void ip_ct_gre_keymap_destroy(struct ip_conntrack_expect *exp)
{
	DEBUGP("entering for exp %p\n", exp);
	WRITE_LOCK(&ip_ct_gre_lock);
	if (exp->proto.gre.keymap_orig) {
		DEBUGP("removing %p from list\n", exp->proto.gre.keymap_orig);

		/* COMMENT ADDED BY CPATON list_del(&exp->proto.gre.keymap_orig->list);
		kfree(exp->proto.gre.keymap_orig);
		exp->proto.gre.keymap_orig = NULL; */

	}
	if (exp->proto.gre.keymap_reply) {
		DEBUGP("removing %p from list\n", exp->proto.gre.keymap_reply);
		list_del(&exp->proto.gre.keymap_reply->list);
		kfree(exp->proto.gre.keymap_reply);
		exp->proto.gre.keymap_reply = NULL;
	}
	WRITE_UNLOCK(&ip_ct_gre_lock);
}

... then everything seems to work correctly.

The connection should be NATted between the laptop, at 10.8.0.2 to one 
interface on Linux at 10.8.0.1, to the other interface on Linux at 
192.168.1.249, to the server at 192.168.1.104.

Can anyone advise? I'm not 100% sure of the nature of the 'expect' stuff, 
which is perhaps where my misunderstanding is coming from. I'm wondering if 
the other end should be 'unexpected' only AFTER GRE reply has been seen, but 
am not quite sure.

I enclose a debug log.

Thanks,

Colin


Apr  7 17:02:52 bigmachine kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
ctinfo = 2, skipping
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
no full PPTP header, can't track
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_outbound_pkt: 
outbound control message START_SESSION_REQUEST
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 0->3, cstate: 0->0
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_inbound_pkt: 
inbound control message START_SESSION_REPLY
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 3->4, cstate: 0->0
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_outbound_pkt: 
outbound control message OUT_CALL_REQUEST
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_outbound_pkt: 
OUT_CALL_REQUEST, CID=C000
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 4->4, cstate: 0->2
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_inbound_pkt: 
inbound control message OUT_CALL_REPLY
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_inbound_pkt: 
OUT_CALL_REPLY, CID=2288, PCID=C000
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:exp_gre: calling 
expect_related <7>ip_conntrack_pptp.c:exp_gre: tuple c02a9d98: 47 
10.8.0.2:0x0000c000 -> 192.168.1.104:0x880b0100
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add: adding new entry c5a1ce40: 
10.8.0.2:0xc000 -> 192.168.1.104:0x2288:1:0x880b
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add: adding new entry c5a1ce60: 
192.168.1.104:0x2288 -> 10.8.0.2:0xc000:1:0x880b
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:exp_gre: calling 
expect_related <7>ip_conntrack_pptp.c:exp_gre: tuple c02a9d98: 47 
192.168.1.104:0x00002288 -> 192.168.1.249:0x880b0100
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add: adding new entry c5a1cec0: 
192.168.1.104:0x2288 -> 192.168.1.249:0xc000:1:0x880b
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add: adding new entry c5a1cee0: 
192.168.1.249:0xc000 -> 192.168.1.104:0x2288:1:0x880b
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 4->4, cstate: 2->3
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_outbound_pkt: 
outbound control message SET_LINK_INFO
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 4->4, cstate: 3->3
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_new: : 
10.8.0.2:0xc000 -> 192.168.1.104:0x2288:1:0x880b
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_expectfn: 
increasing timeouts
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_expectfn: 
completing tuples with ct info
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_expectfn: 
unexpecting other direction
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy: entering for exp c617fbc0
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy: removing c5a1cec0 from 
list
Apr  7 17:02:56 bigmachine kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy: removing c5a1cee0 from 
list
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: 1 (seen reply: 0)
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: 9 (seen reply: 0)
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: b (seen reply: 2)
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: f (seen reply: 2)
Apr  7 17:02:56 bigmachine last message repeated 4 times
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_inbound_pkt: 
inbound control message SET_LINK_INFO
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_inbound_pkt: 
invalid SET_LINK_INFO (TY=15)
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 4->4, cstate: 3->3
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:pptp_outbound_pkt: 
outbound control message SET_LINK_INFO
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
sstate: 4->4, cstate: 3->3
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: f (seen reply: 2)
Apr  7 17:02:56 bigmachine last message repeated 24 times
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_pptp.c:conntrack_pptp_help: 
no full PPTP header, can't track
Apr  7 17:02:56 bigmachine kernel: ip_conntrack_proto_gre.c:gre_packet: 
cpaton - gre_packet is called... status is: f (seen reply: 2)
Apr  7 17:03:09 bigmachine last message repeated 27 times

_________________________________________________________________
Express yourself with cool new emoticons http://www.msn.co.uk/specials/myemo
