From: Roman Tsisyk <roman@tsisyk.com>
Subject: NetFlow / sFlow / IPFIX network probe proposal
Date: Tue, 30 Mar 2010 21:06:57 +0700
Message-ID: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter@vger.kernel.org, linux-net@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35082 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab0C3OG6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:06:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All !

I would like to discuss about a little module idea.

I've been working with commodity hardware Linux-based software network
routers for many years.
In my experience, logging and accounting of network packets was one of
hardest problems.
Various technologies for logging and accounting network packets
exists, e.g. ulog/pcap/PF_RING + nProbe and so on. All these tools
work in user space and require a lot of context switches. Context
switches make soo heavy cpu load if you have 400kpps and more packet
throughput.

As far as I can see, the PF_RING socket is a fastest way for exporting
packets to user space, but aggregation is still doing in user space.
In my tests, it makes about 30-40% CPU load of modern Core Quad cpu,
where complex iptables + ipset rules can take not more than 10%.

I've been nurturing the idea of a network monitoring module for the
NetFilter subsystem for a long time.
This module may be useful for commodity hardware routers as well as
embedded devices and will allow to use the user space only for a
configuration.
Furthermore, its possible with iptables to capture packets in a
forward chain and fill correctly more fields in accounting records.

It would be really good to have such features:

1. Support multiple formats
NetFlow v5, v9 / IPFIX (RFC 3917, 3954, 5101, 5102, 5470) and sFlow (RFC 3176)
IPFIX is more universal and more flexible than NetFlow v5 and sFlow,
so its a more important.

2. Correctly and fully fill all fields in a packet
As I pointed above, pcap-based tools can't correctly fill all fields,
e.g. output interface, nexthop, and AS (but I don't know where get AS
information in the kernel yet).

3. Support multiple targets
Module need robust configuration, which should support more than one
target in same time. It can look like this:
---
sysctl -w net.probe.target0.format=v5
sysctl -w net.probe.target0.destination=172.16.12.12:9996

sysctl -w net.probe.target1.version=ipfix
# IPFIX template specification
sysctl -w net.probe.target1.fields=IPV4_SRC_ADDR,IPV4_DST_ADDR,PROTOCOL,IN_BYTES,IN_PKTS,OUT_BYTES,OUT_PKTS,L4_SRC_PORT,L4_DST_PORT
sysctl -w net.probe.target1.destination=172.16.12.14:9996

sysctl -w net.probe.target2.format=sflow
sysctl -w net.probe.target2.destination=172.16.12.15:6343

# Probe one network to first server
iptables -A FORWARD -s 192.168.0.0/24 -j PROBE --target 0
iptables -A FORWARD -d 192.168.0.0/24 -j PROBE --target 0

# Probe another network to second server
iptables -A FORWARD -s 192.168.5.0/24 -j PROBE --target 1
iptables -A FORWARD -d 192.168.5.0/24 -j PROBE --target 1

# Probe outgoing email flow to third server
iptables -A FORWARD -s 192.168.5.0/24 --dport 25 -j PROBE --target 2
---

4. Support for exporting statistics via /proc
Traffic and packet rate, udp socket information and everything what
can be useful.

5. Round-robin load-balancing for destinations
For high throughput networks it is impossible to save all flow data to
one server. Idea is to add support for round-robin balancing for the
collector address:
---
sysctl -w net.probe.target0.destinations="172.16.12.12:9996 172.16.12.13:9996"
---

6. Support for capturing mirrored to NIC packets (which is addressed
to another host).
Of course, Iptables simple drop these crap packets. May be make sysctl
option for this feature?

PROBE name is just an example and may be changed to something else.
Please correct me, if I forgot something.

What is wrong in ipt_NETFLOW module
(http://sourceforge.net/projects/ipt-netflow/) ?
Ipt_NETFLOW is a really useful module and it never load CPU more than
1%. But internal architecture of ipt_NETFLOW cannot support all of
described above features (because have one common hash table and
configuration with module params). I'd prefer not to reinvent the
wheel and think about redesigning ipt_NETFLOW or writing new module
using ipt_NETFLOW base.

I'm a student and want to work on this project within Summer of Code
program. The Linux Foundation site pointed to the mail list.
My main goal is to make high-quality featured module, that will be
useful for anybody and acceptable for inclusion into mainstream
Kernel.

What do you think about this? Please, advice me or give some ideas.
May be somebody wanted to be a mentor? I'll send detailed information
about my bio, contacts, skills, work experience as well as schedule
plan directly to a potential mentor and/or GSoC site.

BTW, a NetFlow exporter feature is a most rated request on the Vyatta
site, so it should be interesting not only for me.

-- 
WBR, Tsisyk Roman
