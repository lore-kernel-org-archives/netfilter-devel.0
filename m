From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Tue, 30 Mar 2010 16:56:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org
To: Roman Tsisyk <roman@tsisyk.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 2010-03-30 16:06, Roman Tsisyk wrote:

># Probe one network to first server
>iptables -A FORWARD -s 192.168.0.0/24 -j PROBE --target 0
>iptables -A FORWARD -d 192.168.0.0/24 -j PROBE --target 0
>
># Probe another network to second server
>iptables -A FORWARD -s 192.168.5.0/24 -j PROBE --target 1
>iptables -A FORWARD -d 192.168.5.0/24 -j PROBE --target 1
>
># Probe outgoing email flow to third server
>iptables -A FORWARD -s 192.168.5.0/24 --dport 25 -j PROBE --target 2
>---
>
>4. Support for exporting statistics via /proc
>Traffic and packet rate, udp socket information and everything what
>can be useful.

Should probably be using netlink or sysfs instead.

>6. Support for capturing mirrored to NIC packets (which is addressed
>to another host).
>Of course, Iptables simple drop these crap packets. May be make sysctl
>option for this feature?

iptables does not drop these, your NIC does when it's not in promiscuous mode.
