From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Tue, 30 Mar 2010 18:07:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003301804380.25378@obet.zrqbmnf.qr>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>  <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr> <faefb3f11003300857h48b2c4eescb3de63f3b86adfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org
To: Roman Tsisyk <roman@tsisyk.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <faefb3f11003300857h48b2c4eescb3de63f3b86adfe@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tuesday 2010-03-30 17:57, Roman Tsisyk wrote:
>On Tue, Mar 30, 2010 at 9:56 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Tuesday 2010-03-30 16:06, Roman Tsisyk wrote:
>>
>> iptables does not drop these, your NIC does when it's not in promiscuous mode.
>>
>
>If I am no mistaken, for all packets whose mac doesn't match to the
>nic mac pkt_type is set to PACKET_OTHERHOST.
>Iptables drop packets with PACKET_OTHERHOST, I don't remember exactly
>where, may be in ip_rcv routine.

Indeed. You could make it a runtime option (e.g. sysfs-moduleparam)
during your tests.
