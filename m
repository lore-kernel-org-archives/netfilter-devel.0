From: Douglas Diniz <dgdiniz@gmail.com>
Subject: ip_conntrack_count not decremented - nf_conntrack: table full,
	dropping packet
Date: Tue, 9 Feb 2010 16:30:29 -0200
Message-ID: <5415ae081002091030u114b0bf4nbdcf75ba5a5addf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:53304 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0BISaa convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2010 13:30:30 -0500
Received: by pzk17 with SMTP id 17so183259pzk.4
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2010 10:30:29 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I'm facing a problem with netfilter.

My system (a ppc terminal) is:

Linux 2.6.20-6, cross compiled to ppc (ltib) with Real Time Patch.

The terminal has 2 ethernet interfaces (eth0 (192.168.1.0)=A0 and eth1
(192.168.229.0)), and a Wifi interface (ath0 (10.1.1.0)).

After some hours of work the terminal show the message "nf_conntrack:
table full, dropping packet" and I can see that the terminal reaches
the connection limit (4096).

After some debug i saw that the problem only appears when a send some
packet (a ping im my tests) from eth0 (from my pc connected in this
interface) to eth1, to a not used ip in eth1 network (192.168.229.100
for example).=A0 If I send a ping from eth0 to ath0, or from ath0 to
eth0, or from ath0 to eth1, there is no problem. In this cases
ip_conntrack_count is decremented after the timeout.

When I send a ping from eth0 to eth1 I can see the connection in
/proc/net/ip_conntrack, and after the timeout (30s for icmp) the entry
is removed from this table, but the counter in
/proc/sys/net/ipv4/netfilter/
ip_conntrack_count is not decremented.

I insert some printk's in the code and I see that when the timeout
function is called (death_by_timeout), the "use" reference counter (in
the conntrack structure) is > 1, so the "nf_conntrack_put" never call
the "destroy_conntrack"

In the other cases (eth0->ath0, ath0->eth0, ath0->eth1) when the
death_by_timeout is called, the "use" counter is 1, so the
"nf_conntrack_put" call the "destroy_conntrack" and the
ip_conntrack_count is decremented.

=46or some reason there is a conflict between the ethernet interfaces.

This is a known bug? I cannot change the kernel in this moment. There
is something I can do to fix this problem?

Thanks......
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
