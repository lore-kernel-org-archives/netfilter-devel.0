From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: conntrack: UDP NAT vs. VPN tunnel
Date: Thu, 2 Aug 2007 18:17:38 +0200
Message-ID: <200708021817.38209.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello together,

I've got a delicate problem for that I wanted to ask for comments:

There's an IP phone connected via an IPsec tunnel to a PBX.
The phone in on the IP 192.168.1.212, the PXB on 192.168.10.181,
voice traffice is done via UDP.

This works fine until the IPsec box gets rebooted. What happens during reboot: 
The box comes up again and the firewall gets loaded. After some time
the VPN tunnel is reestablished.

In the meantime the phone tries to connect to the PBX every two seconds.
As the VPN tunnel is not up yet, this creates a NAT conntrack entry:

-------------------------------------------------------------------
udp 17 10 src=192.168.1.212 dst=192.168.10.181 sport=9301 dport=9300 
packets=3707 bytes=463375 [UNREPLIED] src=192.168.10.181 dst=217.91.119.99 
sport=9300 dport=9301 packets=0 bytes=0 mark=0 use=
-------------------------------------------------------------------

When the VPN tunnel is running again, this entry never expires as the phone 
tries to connect every two seconds and resets the conntrack timeout. 
What happens is that packets intended for the VPN tunnel never get there.

If you unplug the phone for 30 seconds (UDP conntrack timeout), the entry gets 
deleted. After that reconnecting to the PBX via the VPN tunnel works and the 
following conntrack entry gets created as it should be:

-------------------------------------------------------------------
udp 17 29 src=192.168.1.212 dst=192.168.10.181 sport=9301 dport=9300 packets=1 
bytes=125 src=192.168.10.181 dst=192.168.1.212 sport=9300 dport=9301 
packets=1 bytes=514 mark=0 use=1
-------------------------------------------------------------------

I've now searched for possible solutions. I could write a program that gets 
called after the VPN tunnel is reestablished and deletes all UDP NAT 
conntracks matching the IPs of the VPN tunnel. This is rather complex,
but possible. Maybe there is a more simple solution?

Thanks in advance,
Thomas
