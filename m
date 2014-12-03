From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Reversed byte order issue with nft ?
Date: Wed, 03 Dec 2014 18:20:59 +0100
Message-ID: <547F467B.3060206@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

When doing 'nft list ruleset', I get a bad result (see below), fields 
appear as "unknown" and/or as numeric values.

Running 'nft' with gdb, it looks like something is wrong with byte ordering:

In function symbolic_constant_print(), mpz_export_data() return a 
strange val.
First time we go there, we get 0x800000000
Next time, we get 0x400000000
Last time, we get 0x200000000
While we expect 8(new), 4(related), 2(established)

Any idea on what to do ?

Target is a powerpc (big endian), everything is cross-compiled using GNU 
tools on x86 (little endian)

kernel 3.18-rc7
nftables-20141121
libnftnl-20141121
gmp-4.3.2
libmnl-1.0.3
libnfnetlink-1.0.1
libnetfilter_conntrack-1.0.4

Thanks
Christophe

# uname -a
Linux vgoip 3.18.0-rc7-local-dirty #94 PREEMPT Wed Dec 3 17:25:41 CET 
2014 ppc GNU/Linux
# nft -f /etc/nftables.conf
# nft list ruleset
table ip filter {
         chain input {
                  type filter hook input priority 0;
                  oifname "lo" accept
                  ct state { 4, 2} accept
                  ct state 8 unknown unknown 0x16 [invalid type] accept
                  ip protocol icmp accept
         }

         chain forward {
                  type filter hook forward priority 0;
                  drop
         }
}

# cat /etc/nftables.conf
flush ruleset
table ip filter {
         chain input {
                  type filter hook input priority 0;
                  oifname "lo" accept
                  ct state { established, related} accept
                  ct state new tcp dport 22 accept
                  ip protocol icmp accept
         }

         chain forward {
                  type filter hook forward priority 0;
                  drop
         }
}


