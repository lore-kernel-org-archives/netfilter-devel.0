From: Dan Hollis <goemon@anime.net>
Subject: dscp mangle bug?
Date: Mon, 17 Jun 2002 17:03:53 -0700 (PDT)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.44.0206171658080.9205-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

With iptables 1.2.6a I use -t mangle in a FORWARD rule to -j DSCP 
--set-dscp 0x01 (to set ip precedence %001 = priority)

But packets sent out have TOS byte set to 0x04 according to tcpdump...

I don't think this is correct...?

-Dan
-- 
[-] Omae no subete no kichi wa ore no mono da. [-]
