Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEC44F218
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2024 12:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.212.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714997393; cv=none; b=RCI5/Hmmuww/5ZAdKKRWN6KH4R3yFYf0oCyx49GArIWT6RCbmJPm7JQefbK1av9R5PGvfrktDFhQY2TmaeaN4riMPTz5QsoDuJXwOMHiD8V45IgZmxu8MRl/cmSQop2FkWD61YXYpmqhrXbYp57fOiZprwWWAw6S3W235elU5VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714997393; c=relaxed/simple;
	bh=U3sc6xav/L2JWbbIZQeND+2ar+aLTh/7k/tq+DmA118=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TfsrIBY7sFCmq0zWj6B8kn2aVpGO30KUwRtp1iNoK/N7hvfSSddGcwNGKwGqOxpKQvLmhQrC3BD8UqsAkM83FfD8NdkWkzyHkgVFX51qV6zE2SzSAhzJWMYdzL5rq3LschS6bXulUA6ZPJch1GX1DJmTd8BGQY13WIZygzb/O1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de; spf=pass smtp.mailfrom=sysmocom.de; arc=none smtp.client-ip=176.9.212.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sysmocom.de
Received: from localhost (localhost [127.0.0.1])
	by mail.sysmocom.de (Postfix) with ESMTP id 0A3CDC8A397;
	Mon,  6 May 2024 11:59:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
	by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7E_6ooygORl; Mon,  6 May 2024 11:59:58 +0000 (UTC)
Received: from my.box (ip-109-40-242-113.web.vodafone.de [109.40.242.113])
	by mail.sysmocom.de (Postfix) with ESMTPSA id 7FC87C80260;
	Mon,  6 May 2024 11:59:56 +0000 (UTC)
Date: Mon, 6 May 2024 13:59:55 +0200
From: Neels Hofmeyr <nhofmeyr@sysmocom.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nftables with thousands of chains is unreasonably slow
Message-ID: <ZjjGOyXkmeudzzc5@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

I am trying to figure out why adding/deleting chains and retrieving counters
via nftables takes long for high nr of entries. I'd like to share some
findings, to ask whether this is known, whether a solution exists, etc...

I'm writing two programs that interact with nftables via
nft_run_cmd_from_buffer(). (osmo-upf and osmo-hnbgw)

One use case is setting up / tearing down thousands of GTP tunnels via nftables
rule sets one by one, for reference:
https://gitea.osmocom.org/cellular-infrastructure/osmo-upf/src/commit/a21bcec358a5147deb15d156700279f52386a7d7/tests/nft-rule.vty

The other use case is retrieving all counters that are currently present in the
inet table that my client program owns.

Adding the first few hundred chains / reading a few hundred counters finishes
in an ok amount of time. But the more chains are already submitted in the
table, the longer it takes to add another one, etc.

By the time that there are ~4000 chains, adding another chain becomes
prohibitively slow. Some numbers: in total, when setting up 1000 GTP tunnels in
osmo-upf, which means adding 4000 chains into a table owned by the program
(osmo-upf), in total takes 49 seconds. This includes the overhead for talking
PFCP and logging, etc., but by far the most time is taken waiting for
nft_run_cmd_from_buffer().

We'd like to scale up to like 100 times the above -- completely beyond all
reason currently, since the wait time seems to increase exponentially.

I have two angles:

1) workaround: structure the chains and rules differently?
2) analysis: bpftracing tells me that most time is spent in chain_free().

(1) Currently I have one flat table with all the chains in that "top level".
Would it make sense to try breaking that long list up into smaller groups,
maybe batches of 100? As in, pseudocode:

  table osmo-upf {
      group-0 {
         chain-0 {}
	 chain-1 {}
	 ...
      }
      group-1 {
         chain-100 {}
         chain-101 {}
	 ...
      }
      ...
      group-1000 {
         chain-100000 {}
         chain-100001 {}
	 ...
      }
  }

Then I can also retrieve the counters in batches of 100, which might be more
efficient and better to coordinate with concurrent tasks.

(2) Using bpftrace, I drilled a bit into where the time is spent. Two
interesting findings for me so far:

It seems most time is spent in

  nft_run_cmd_from_buffer
    nft_evaluate
      nft_cache_update
        nft_cache_release
          nft_cache_flush
            table_free
              chain_free

The bpftrace shows:

nft_cache_update() was called 6000 times.
(I have 1000 GTP tunnels and expect four chains per GTP tunnel, which would be
4000, not sure why I see 6k, but that's not really that significant.)

chain_free() was called more than 5 million times, that's 1000 times as often
as I would naively expect to see.

Most calls are fast (<16us), but there are some break-outs of up to 8ms, and in
total the 5 million calls amount to 80 seconds. (One bpftrace dump below, FYI)

I'm continuing to think:

- Is this stuff known already, or does it make sense to continue on this path,
  share a reproduction recipe here, and so on?

- can we fix that? Is there some memory leak / unnecessary blow up happening
  that causes this apparent factor 1000 in effort?

- can we defer the free, so my client program gets the nftables results without
  having to wait for the freeing? Can the client program decide when to do the
  nftables freeing, i.e. not within nft_run_cmd_from_buffer()?

Thanks!

~N

foo_bar__count: function foo_bar() was called this many times
...__ms: milliseconds
...__us: microseconds

==========================================================
@handle_free__count: 5190516
@handle_free__total_ms: 16919          <--- in total 17 seconds spent in handle_free()
@handle_free__us: 
[2, 4)           4884915 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[4, 8)            280031 |@@                                                  |
[8, 16)            15323 |                                                    |
[16, 32)            9910 |                                                    |
[32, 64)             267 |                                                    |
[64, 128)             24 |                                                    |
[128, 256)             3 |                                                    |
[256, 512)             3 |                                                    |
[512, 1K)              0 |                                                    |
[1K, 2K)               3 |                                                    |
[2K, 4K)              48 |                                                    |

@cache_free__count: 11100
@cache_free__total_ms: 230
@cache_free__us: 
[2, 4)              7327 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[4, 8)              3461 |@@@@@@@@@@@@@@@@@@@@@@@@                            |
[8, 16)              177 |@                                                   |
[16, 32)              73 |                                                    |
[32, 64)               5 |                                                    |
[64, 128)              0 |                                                    |
[128, 256)             0 |                                                    |
[256, 512)             0 |                                                    |
[512, 1K)              0 |                                                    |
[1K, 2K)               9 |                                                    |
[2K, 4K)              39 |                                                    |
[4K, 8K)               9 |                                                    |

@scope_release__count: 5140608
@scope_release__total_ms: 12679          <--- in total 13 seconds spent in scope_release()
@scope_release__us: 
[1]              1580615 |@@@@@@@@@@@@@@@@@@@@@@@                             |
[2, 4)           3527447 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[4, 8)             21717 |                                                    |
[8, 16)             4521 |                                                    |
[16, 32)            6165 |                                                    |
[32, 64)             140 |                                                    |
[64, 128)             10 |                                                    |
[128, 256)             0 |                                                    |
[256, 512)             5 |                                                    |




@set_free__count: 16650
@set_free__total_ms: 118
@set_free__us: 
[1]                 2527 |@@@@@@@@@@@@@@@@@@@                                 |
[2, 4)              6643 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[4, 8)              1843 |@@@@@@@@@@@@@@                                      |
[8, 16)             3475 |@@@@@@@@@@@@@@@@@@@@@@@@@@@                         |
[16, 32)            2119 |@@@@@@@@@@@@@@@@                                    |
[32, 64)              37 |                                                    |
[64, 128)              3 |                                                    |
[128, 256)             0 |                                                    |
[256, 512)             0 |                                                    |
[512, 1K)              0 |                                                    |
[1K, 2K)               3 |                                                    |

@chain_free__count: 5137887          <--- called 5G times
@chain_free__total_ms: 80114         <--- in total 80! seconds spent in scope_release()
@chain_free__us:
[8, 16)          4556941 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[16, 32)          550786 |@@@@@@                                              |
[32, 64)           29604 |                                                    |
[64, 128)            397 |                                                    |
[128, 256)            12 |                                                    |
[256, 512)            21 |                                                    |
[512, 1K)              0 |                                                    |
[1K, 2K)               3 |                                                    |
[2K, 4K)             117 |                                                    |
[4K, 8K)              15 |                                                    |

==========================================================


-- 
- Neels Hofmeyr <nhofmeyr@sysmocom.de>         https://www.sysmocom.de/
=======================================================================
* sysmocom - systems for mobile communications GmbH
* Siemensstr. 26a
* 10551 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
