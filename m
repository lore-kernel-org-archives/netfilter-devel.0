Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B819673518
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712229718; cv=none; b=BL0dc3cFDqYZ+NVT44PYscPiAPcFsVLGl4RNqnMhw2WYu29aZ9GcQDYUvZSEEHZjb4P9JHyiJWWx7usPKudzSMKvYhMxDUKc5kPTzkNRz/rEf/w8Qxl5WNS+OUH3B8M7E1iVq2fXz8+KpOFMFXeRp2qKdOnO76BSwBhL2JXr0Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712229718; c=relaxed/simple;
	bh=zYCur/mE2tFPj7Diwhz4WQQxByZW+Hxh/J6JcGMzxDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAB7rIe07CNz52xaS6Wod9JtUO0j3KWIrwbaEHX2QIuufU0g9IwF1zKTS/V9+zINXPjEwcDCwo+uIpXvEZd0yt5WbpPsLiPacWEkOes7cOzpIOpyt4mJDbSRe1T7lvl2I+V6AxBBqWfltO/hzz5HLfs1hNMpHSd16Qs6lLAG/Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 4 Apr 2024 13:21:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/2] Support for variables in map expressions
Message-ID: <Zg6NUHYLHYbIgKtq@calendula>
References: <20240403120937.4061434-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240403120937.4061434-1-jeremy@azazel.net>

On Wed, Apr 03, 2024 at 01:09:35PM +0100, Jeremy Sowden wrote:
> The first patch replaces the current assertion failure for invalid
> mapping expression in stateful-object statements with an error message.
> This brings it in line with map statements.
> 
> It is possible to use a variable to initialize a map, which is then used
> in a map statement, but if one tries to use the variable directly, nft
> rejects it.  The second patch adds support for doing this.

Thanks. I can trigger crashes, e.g.

define quota_map = "1.2.3.4"

table ip x {
        chain y {
                quota name ip saddr map $quota_map
        }
}

src/mnl.c:1759:2: runtime error: member access within misaligned address 0x000100000001 for type 'struct expr', which requires 8 byte alignment
0x000100000001: note: pointer points here
<memory cannot be printed>
src/netlink.c:121:10: runtime error: member access within misaligned address 0x000100000001 for type 'const struct expr', which requires 8 byte alignment
0x000100000001: note: pointer points here
<memory cannot be printed>
AddressSanitizer:DEADLYSIGNAL
=================================================================
==150056==ERROR: AddressSanitizer: SEGV on unknown address 0x00009fff8009 (pc 0x7f58e67d8624 bp 0x7ffd57d17eb0 sp 0x7ffd57d17c40 T0)
==150056==The signal is caused by a READ memory access.
    #0 0x7f58e67d8624 in alloc_nftnl_setelem src/netlink.c:121
    #1 0x7f58e67c3d12 in mnl_nft_setelem_batch src/mnl.c:1760
    #2 0x7f58e67c45d9 in mnl_nft_setelem_add src/mnl.c:1805
    #3 0x7f58e687df1e in __do_add_elements src/rule.c:1425
    #4 0x7f58e687e528 in do_add_set src/rule.c:1471
    #5 0x7f58e687e7aa in do_command_add src/rule.c:1491
    #6 0x7f58e688fdb3 in do_command src/rule.c:2599
    #7 0x7f58e679d417 in nft_netlink src/libnftables.c:42
    #8 0x7f58e67a514a in __nft_run_cmd_from_filename src/libnftables.c:729
    #9 0x7f58e67a639c in nft_run_cmd_from_filename src/libnftables.c:807
    #10 0x557c9d25b3b0 in main src/main.c:536
    #11 0x7f58e5846249 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #12 0x7f58e5846304 in __libc_start_main_impl ../csu/libc-start.c:360
    #13 0x557c9d258460 in _start (/usr/sbin/nft+0x9460)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV src/netlink.c:121 in alloc_nftnl_setelem
==150056==ABORTING

I think this is lacking more validation.
