From: Patrick Schaaf <bof@bof.de>
Subject: tracking IPv6 connections
Date: Thu, 1 May 2003 08:18:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501061842.GC15143@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi list,

before the thought leaves me, again, here's an idea of how to cope
with IPv6 addresses in the context of our current conntrack structure.

The basic idea is to have a separate hash, with an 128 bit IPv6 address
as the key, and a value like this:

	struct unique_ipv6_address {
		struct list_head hash_link;
		atomic_t usage;
		unsigned char unused[4];
		unsigned char addr[16];
	/* 32 byte */ };

Now, given such a hash, we can use the 32-bit 'struct unique_ipv6_address *'
in the place of the IPv4 address in our conntrack tuples. If we completely
mix IPv4 and IPv6 in one big conntrack hash, we need one or two bit more
per tuple, to indicate whether we have a v4 or v6 address. How nice:
our dst.protonum field is 8 bits too long, so we have room for that!

The 'usage' of the unique_ipv6_address would count how many tuples
reference that address, freeing the address hash entry when usage
drops to 0.

best regards
  Patrick
