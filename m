From: Aaron Claessens <aaronc@eclipse-lighting.com>
Subject: ASSERT in ip_conntrack_core.c with PPTP helper
Date: Tue, 06 Apr 2004 17:26:22 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40732E8E.8050003@eclipse-lighting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
I believe that I have stumbled across a bug ....

I recieve when a PPTP session is started through the NAT interface:

Apr  6 16:44:48 NAT kernel: ASSERT ip_conntrack_core.c:93 
&ip_conntrack_lock_Rsmp_4193d6ac readlocked
Apr  6 16:44:48 NAT kernel: ASSERT ip_conntrack_core.c:1070 
&ip_conntrack_lock not readlocked
Apr  6 16:44:48 NAT kernel: ASSERT ip_nat_core.c:747 &ip_conntrack_lock 
not readlocked
Apr  6 16:44:48 NAT kernel: ASSERT ip_conntrack_core.c:80 
&ip_conntrack_lock not readlocked
Apr  6 16:44:48 NAT kernel: ASSERT ip_conntrack_core.c:82 
&ip_conntrack_lock not readlocked
Apr  6 16:44:48 NAT kernel: ASSERT ip_conntrack_core.c:1070 
&ip_conntrack_lock not readlocked
Apr  6 16:44:48 NAT kernel: ASSERT: ip_nat_core.c:850 &ip_conntrack_lock 
not readlocked

This was with:
iptables-1.2.9
linux-2.4.24 and 2.4.25

The following modules were loaded:
ipt_MASQUERADE
ipt_REJECT
ipt_LOG
ipt_limit
ipt_state
iptable_filter
ip_nat_pptp
ip_conntrack_pptp
ip_conntrack_proto_gre
iptable_nat
ip_tables
ip_conntrack

Let me know if I can provide more testing or information ....
Aaron


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
 
iEYEARECAAYFAkBzLowACgkQiM4FRMeeny2hSACff4cjU0nnn/YW1PV4iBX1bYBN
yCkAoN3HY8jtiSt5+UzUem9zlo8ugRL6
=r3lP
-----END PGP SIGNATURE-----
