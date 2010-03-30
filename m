From: Roman Tsisyk <roman@tsisyk.com>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Tue, 30 Mar 2010 22:57:20 +0700
Message-ID: <faefb3f11003300857h48b2c4eescb3de63f3b86adfe@mail.gmail.com>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
	 <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 30, 2010 at 9:29 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> I am interested in this feature. FreeBSD supports netflow v5, and
> netflow v5 is more common, we can support it first, then add others.

We used ng_netflow before PF_RING. There was a lot of problems with
ksocket udp packets loss in the BSD kernel.  After that we have
switched to the ntop solution.
Ipt_NETFLOW provides basic v5 support, but as I already said doesn't
have flexible configuration and other features. So I intend to make
universal module and start with v5.

On Tue, Mar 30, 2010 at 9:56 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Tuesday 2010-03-30 16:06, Roman Tsisyk wrote:
>
> iptables does not drop these, your NIC does when it's not in promiscuous mode.
>

If I am no mistaken, for all packets whose mac doesn't match to the
nic mac pkt_type is set to PACKET_OTHERHOST.
Iptables drop packets with PACKET_OTHERHOST, I don't remember exactly
where, may be in ip_rcv routine.

-- 
WBR, Tsisyk Roman
