From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: problem with sets (Object not found)
Date: Tue, 28 Jul 2009 15:53:00 +0200
Message-ID: <4A6F02BC.7080904@trash.net>
References: <4A69FCC3.1070404@gmail.com> <4A6EEDBA.3010505@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080307030603020006080501"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbZG1NxD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:53:03 -0400
In-Reply-To: <4A6EEDBA.3010505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080307030603020006080501
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Christoph A. wrote:
>> Am I missing something in the kernel or do I have a syntax error in my
>> rules?
>> (kernel config attached)
> 
> I never pushed out the userspace changes for the new set API.
> I just pushed out all the changes that should be needed, please
> update your trees and try again.

BTW, for reference, attached is an example script for the new
features (included in the tree in files/examples/sets_and_maps).
The named sets can then be updated dynamically like this:

# nft add element filter jump_map { eth0 => jump input_1, eth1 => jump
input_2 }

# nft add element filter nat_map eth0 => 10.0.0.1

# nft add element filter local_ifs { eth1, eth2, eth3 }
# nft delete element filter local_ifs eth2

etc. For now, all sets and maps are bound to tables. This is actually
only necessary for verdict maps, so this might change.



--------------080307030603020006080501
Content-Type: text/plain;
 name="sets_and_maps"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sets_and_maps"

#! /sbin/nft -nf
#
# Examples of set and map usage
#

# symbolic anonymous set definition built from symbolic singleton definitions
define int_if1	 = eth0
define int_if2	 = eth1
define int_ifs	 = { $int_if1, $int_if2 }

define ext_if1	 = eth2
define ext_if2	 = eth3
define ext_ifs	 = { $ext_if1, $ext_if2 }

# recursive symbolic anonymous set definition
define local_ifs = { $int_ifs, $ext_ifs }

# symbolic anonymous set definition
define tcp_ports = { ssh, domain, https, 123-125 }

delete table filter
table filter {
	# named set of type ifindex
	set local_ifs {
		type ifindex
	}

	# named map of type ifindex => ipv4_address
	map nat_map {
		type ifindex => ipv4_address
	}

	map jump_map {
		type ifindex => verdict
	}

	chain input_1 { counter; }
	chain input_2 { counter; }
	chain input {
		hook NF_INET_LOCAL_IN 0

		# symbolic anonymous sets
		meta iif $local_ifs tcp dport $tcp_ports counter

		# literal anonymous set
		meta iif { eth0, eth1 } counter

		meta iif @local_ifs counter
		meta iif vmap @jump_map

		#meta iif vmap { eth0 => jump input1, eth1 => jump input2 }
	}
}

--------------080307030603020006080501--
