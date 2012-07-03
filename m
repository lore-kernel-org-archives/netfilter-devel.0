From: Stig <stig@ubnt.com>
Subject: broadcast filling up conntrack table
Date: Tue, 3 Jul 2012 15:45:11 -0700
Message-ID: <CAL-yc89aqg0HSgCpkrTRmGx5DXVFbMgo0oOZPWA6JLEfvyH0PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:38253 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756395Ab2GCWpM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:45:12 -0400
Received: by qchj9 with SMTP id j9so4681848qch.37
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jul 2012 15:45:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My LAN has a lots of broadcast traffic which causes my router to waste
a lot of conntrack entries on those broadcasts.  I can workaround it
with a NOTRACK for -d 255.255.255.255 in the raw table, but I'm
wondering if there is ever a good reason to create a conntrack entry
for broadcasts?

stig


root@ubnt:/home/ubnt# conntrack -L | grep 255.255.255.255
udp      17 12 src=10.1.0.159 dst=255.255.255.255 sport=57567
dport=46451 [UNREPLIED] src=255.255.255.255 dst=10.1.0.159 sport=46451
dport=57567 mark=0 use=1
udp      17 11 src=10.1.1.185 dst=255.255.255.255 sport=58876
dport=52360 [UNREPLIED] src=255.255.255.255 dst=10.1.1.185 sport=52360
dport=58876 mark=0 use=1
udp      17 10 src=10.1.1.27 dst=255.255.255.255 sport=37317
dport=38269 [UNREPLIED] src=255.255.255.255 dst=10.1.1.27 sport=38269
dport=37317 mark=0 use=1
udp      17 25 src=10.1.0.217 dst=255.255.255.255 sport=2048
dport=48950 [UNREPLIED] src=255.255.255.255 dst=10.1.0.217 sport=48950
dport=2048 mark=0 use=1
udp      17 13 src=10.1.0.180 dst=255.255.255.255 sport=2049
dport=48092 [UNREPLIED] src=255.255.255.255 dst=10.1.0.180 sport=48092
dport=2049 mark=0 use=1
udp      17 11 src=10.1.1.171 dst=255.255.255.255 sport=48784
dport=40378 [UNREPLIED] src=255.255.255.255 dst=10.1.1.171 sport=40378
dport=48784 mark=0 use=1
udp      17 24 src=10.1.1.83 dst=255.255.255.255 sport=54152
dport=53820 [UNREPLIED] src=255.255.255.255 dst=10.1.1.83 sport=53820
dport=54152 mark=0 use=1
udp      17 12 src=10.1.1.81 dst=255.255.255.255 sport=46501
dport=39773 [UNREPLIED] src=255.255.255.255 dst=10.1.1.81 sport=39773
dport=46501 mark=0 use=1
udp      17 12 src=10.1.0.146 dst=255.255.255.255 sport=37086
dport=51417 [UNREPLIED] src=255.255.255.255 dst=10.1.0.146 sport=51417
dport=37086 mark=0 use=1
udp      17 24 src=10.1.1.43 dst=255.255.255.255 sport=35070
dport=57905 [UNREPLIED] src=255.255.255.255 dst=10.1.1.43 sport=57905
dport=35070 mark=0 use=1
[SNIP]

root@ubnt:/home/ubnt# conntrack -V
conntrack v1.0.1 (conntrack-tools)
root@ubnt:/home/ubnt# iptables -V
iptables v1.4.10
