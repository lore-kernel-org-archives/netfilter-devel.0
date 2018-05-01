From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Silently dropped UDP packets on kernel 4.14
Date: Tue, 1 May 2018 20:50:34 +0200
Message-ID: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

I am currently debugging an issue where it looks like UDP packets are
silently dropped. My setup is a client with a tool that sends two UDP
packets (DNS requests) "simultaneously" using the same socket, and
then a router running latest OpenWRT (with kernel 4.14.37). What I am
seeing is that the first request goes through, while the second seems
to be lost somewhere. I can see the second packet in my firewall logs
on the router (all the way past the POSTROUTING chain in the
nat-table), but the packet is not sent over the wire (checked with
tcpdump).

In order to try to figure out what was going on, I added some
LOG-rules to the firewall. I Inserted the rules in the PREROUTING
chains in the raw, mangle and nat tables, in filter FORWARD and nat
and mangle POSTROUTING. Here are the logs for one set of requests
(with some notes):

First DNS request (verified by packet length):
[723269.968256] raw-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=64 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36
[723269.984892] mangle-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=64 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36
[723270.001769] mangle-pre #2: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=64 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36 -> this LOG-rule only matches when ctstate is NEW.

Second DNS request (verified by packet length):
[723270.019033] raw-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=64 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38
[723270.035734] mangle-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=64 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38
-> No mangle-pre #2, so the conntrack entry is found

Processing first request:
[723270.036213] nat-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=64 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36 MARK=0x4000200 -> I use policy routing, therefore mark. Routing
works correctly.
[723270.036366] filter-fwd: IN=br-lan OUT=eth0.2
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=63 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36 MARK=0x4000200
[723270.036419] mangle-post: IN= OUT=eth0.2 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=63 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36 MARK=0x4000200
[723270.036457] nat-post: IN= OUT=eth0.2 SRC=10.0.0.3 DST=1.1.1.1
LEN=56 TOS=0x00 PREC=0x00 TTL=63 ID=8147 DF PROTO=UDP SPT=42397 DPT=53
LEN=36 MARK=0x4000200

Processing second request:
[723270.117394] mangle-pre #2: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=64 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38
[723270.136644] nat-pre: IN=br-lan OUT=
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=64 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38 MARK=0x4000200
[723270.154716] filter-fwd: IN=br-lan OUT=eth0.2
MAC=78:a3:51:34:e4:86:2e:8e:de:be:22:5a:08:00 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=63 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38 MARK=0x4000200
[723270.173501] mangle-post: IN= OUT=eth0.2 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=63 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38 MARK=0x4000200
[723270.187787] nat-post: IN= OUT=eth0.2 SRC=10.0.0.3 DST=1.1.1.1
LEN=58 TOS=0x00 PREC=0x00 TTL=63 ID=8148 DF PROTO=UDP SPT=42397 DPT=53
LEN=38 MARK=0x4000200

When dumping conntrack after the second request has been processed, I
get the following:
udp      17 55 src=10.0.0.3 dst=1.1.1.1 sport=42397 dport=53 packets=1
bytes=56 src=1.1.1.1 dst=193.213.155.210 sport=53 dport=42397
packets=1 bytes=72 mark=67109120 delta-time=4 use=1

This looks a bit strange to me, it seems that only the first request
has been counted.

Does anyone have any idea of what could be wrong, where I should look
or other things I can try? I tried to space the requests out a bit in
time (I inserted a sleep 1 between them), and then the problem went
away.

Thanks in advance for any help,
Kristian
