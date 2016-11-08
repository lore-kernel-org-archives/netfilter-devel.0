From: Juergen Schmidt <abcdmail@freenet.de>
Subject: sip helper doesn't match on calls to myself
Date: Tue, 8 Nov 2016 20:01:18 +0100
Message-ID: <b15da066-ca38-ba0d-2475-184db15c951e@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:43553 "EHLO mout1.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751749AbcKHTOS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 14:14:18 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
        by mout1.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.85 #1)
        id 1c4Bhu-0002xU-W6
        for netfilter-devel@vger.kernel.org; Tue, 08 Nov 2016 20:05:19 +0100
Received: from localhost ([::1]:60187 helo=mjail1.freenet.de)
        by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
        id 1c4Bhu-0007QR-S0
        for netfilter-devel@vger.kernel.org; Tue, 08 Nov 2016 20:05:18 +0100
Received: from mx15.freenet.de ([195.4.92.25]:57269)
        by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
        id 1c4Bee-0003sU-Gz
        for netfilter-devel@vger.kernel.org; Tue, 08 Nov 2016 20:01:56 +0100
Received: from p5deb03c2.dip0.t-ipconnect.de ([93.235.3.194]:48748 helo=mail.maya.org)
        by mx15.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 587) (Exim 4.85 #1)
        id 1c4Bee-0004tA-4S
        for netfilter-devel@vger.kernel.org; Tue, 08 Nov 2016 20:01:56 +0100
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
        by mail.maya.org (8.14.7/8.13.8) with ESMTP id uA8J1s6Y004146
        for <netfilter-devel@vger.kernel.org>; Tue, 8 Nov 2016 20:01:55 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

I've got the following problem: If I'm calling myself, the incoming call
isn't matched by the sip helper rules, but the rules w/o sip helper. I
would have expected, that both calls are matched by the sip helper rules.


In detail:

Given is an asterisk server, one extension (C610 IP with 3 phones, which
can handle 2 lines at the same time) and a trunk to the provider.

The extension calls the own number, which provides the following scenario:

outgoing call: extension -> asterisk -> provider

   and

incoming call: provider -> asterisk -> extension


*Important*: the provider uses independent media servers. This means:
the signaling server and the media servers have different IP addresses.


The calls from asterisk to the extensions are not described here,
because there is no problem.


This means:
At the outgoing interface (ppp0) to the provider can be seen 4 legs, 2
of the outgoing call and 2 of the incoming call. The 2 legs of the
incoming call are not matched by the sip helper rules!

kernel is 	4.4.26
iptables is 	v1.4.21



iptables is configured like this:


modprobe nf_conntrack_sip sip_direct_media=0
echo 0 > /proc/sys/net/netfilter/nf_conntrack_helper


# register sip helper
iptables -I OUTPUT -t raw -p udp -m udp -o ppp0  -d 217.0.22.0/23 -s
$IPLOCAL --dport 5060 -j CT --helper sip

iptables -I PREROUTING -t raw -p udp -m udp -i ppp0 s 217.0.22.0/23 -d
$IPLOCAL --sport 5060 -j CT --helper sip


# match packages in OUTPUT:
---------------------------
iptables -I OUTPUT -p udp -s $IPLOCAL -d 217.0.22.0/23 --sport 5060
--dport 5060 -j ACCEPT

# rtp (matched by the outgoing call)
iptables -A OUTPUT -p udp -s $IPLOCAL -d 217.0.0.0/13 --sport
30000:40000 -m conntrack --ctstate RELATED,ESTABLISHED -m helper
--helper sip -j ACCEPT

# why is this rule necessary for the incoming call when calling to self?
# matched by the incoming call
iptables -A internet-out -p udp -o ppp0 -s $IPLOCAL -d 217.0.0.0/13
--sport 30000:40000 -m conntrack --ctstate ESTABLISHED -j ACCEPT


match packages in INPUT:
------------------------
iptables -I INPUT -i ppp0 -p udp -s 217.0.22.0/23 -d $IPLOCAL --sport
5060 --dport 5060 -m conntrack --ctstate RELATED,ESTABLISHED  -j ACCEPT

# rtp (matched by the outgoing call)
iptables -A internet-in -i ppp0 -p udp -s 217.0.0.0/13 -d $IPLOCAL
--dport 30000:40000 -m conntrack --ctstate RELATED,ESTABLISHED -m helper
--helper sip -j ACCEPT

# why is this rule necessary for the incoming call?
# matched by the incoming call
iptables -A internet-in -i ppp0 -p udp -s 217.0.0.0/13 -d $IPLOCAL
--dport 30000:40000 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT




conntrack -L gives:

# Outgoing call (is matched as expected):
# rtp
udp      17 179 src=$IPLOCAL dst=217.0.4.103 sport=17188 dport=2016
src=217.0.4.103 dst=$IPLOCAL sport=2016 dport=17188 [ASSURED] mark=0 use=1
# rtcp
udp      17 175 src=$IPLOCAL dst=217.0.4.103 sport=17189 dport=2017
src=217.0.4.103 dst=$IPLOCAL sport=2017 dport=17189 [ASSURED] mark=0 use=1


# Incoming call - which is *not* matched by sip helper rules, but by the
conntrack rule without sip helper:
# rtp
udp      17 179 src=217.0.4.135 dst=$IPLOCAL sport=53254 dport=18900
src=$IPLOCAL dst=217.0.4.135 sport=18900 dport=53254 [ASSURED] mark=0 use=2
# rtcp
udp      17 175 src=217.0.4.135 dst=$IPLOCAL sport=53255 dport=18901
src=$IPLOCAL dst=217.0.4.135 sport=18901 dport=53255 [ASSURED] mark=0 use=1



I would be glad to get some hint why it behaves like this.



Thanks,
Juergen
