From: Andrei Ivanov <andrei.ivanov@ines.ro>
Subject: tos 0x62
Date: Tue, 17 Sep 2002 13:22:48 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209171317130.6328-100000@webdev.ines.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


Hello,
I'm trying to filter packets which have a TOS value of 0x62, and it seems
I cannot.
I tried the tos module, but it only knows valid tos values.
I looked for the ftos module from patch-o-matic, but it seems it has been
obsoleted by DSCP and ECN module.

If I try iptables -I acc_IN -i eth1 -m dscp --dscp 0x62 it spits out:

iptables v1.2.7a: DSCP `98` out of range

Should I use ftos or is there another way to do this ?

(I coudln't search the mail archives for this problem because this 
mailing list manager doesn't offer such a facility)
(I tried this on netfilter-users, but nobody answered)
