Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2022E167D95
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 22:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716849081; cv=none; b=HdjSWUNFBeHQTkWng737Alj8IIdBu+veGeHvL/LBs+3Hgi9f061TnaxYSlFinnxlP3QnA0dKfgYIWoGytmv5utM5cprUHz5uMDTTeULQqpQzoxCv5amsGsw+PKQfUll7Y87ooiA0GutS6Ml90tAvZU5E49PQmsg2guMH/M95aEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716849081; c=relaxed/simple;
	bh=IsisX6gapOyQBEzsZihPbz6eM8FpXXrVyzSqZb05iZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTbYyD2NfluIaeTjJvzdhXMAY309ccwcq9OIU0dJhumdG96H52xhhLgsmaYfEksLl4tf3bCcRRC1ZPnSbS6NXmJTV24VWBmzqvzY2miWs3D6UmOlOkgVj7YwPYOCsf6Nz3eEitETaxLL4m3wFHGi4PRz6NAlHVu8ZW1NRFllhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 28 May 2024 00:31:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Neels Hofmeyr <nhofmeyr@sysmocom.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables with thousands of chains is unreasonably slow
Message-ID: <ZlUJswB1ViCcVHId@calendula>
References: <ZjjGOyXkmeudzzc5@my.box>
 <ZjqsBomPs2qWEi_5@calendula>
 <Zj20ysFpLN4oJGkZ@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zj20ysFpLN4oJGkZ@my.box>

Hi Neels,

On Fri, May 10, 2024 at 07:46:50AM +0200, Neels Hofmeyr wrote:
> Hi,
> 
> I have some more news on my complaints about nftables speed =)
> Before, I assumed the performance loss was exponential, but turns out that it
> is linear.
> 
> Attached is a reproduction program in c.

Thanks for your reproducer.

> Below is the output I get, first the explanation.
> 
> An aim is to crank the n in the program up to 200k
> and still complete < 2 minutes;
> 
> I have taken the nft ruleset as used in osmo-upf, I have not yet spent time to
> find a more minimal nft script.
> 
> One "item" here is a batch of two chains with a rule each, plus two map entries
> (exactly as done for one direction of a GTP-U tunnel in osmo-upf).
> 
> The program calls one nft_run_cmd_from_buffer() per such item.
> Roughly every 128th time, the program prints the time it takes for a single
> nft_run_cmd_from_buffer() call adding one such item.
> 
> The first ~200 items take less than a millisecond each.
> The 5000th item takes ~25 milliseconds, factor 34.
> The increase is *linear* (attached a chart).
> 
> Then the program goes on to delete the same items one by one. The first one
> takes ~21ms to delete, the last few only 0.33 ms each, factor 60.
> The transition is also linear.

Problem is two-fold.

One of the issues is that the cache gets cancelled (ie. flush and
refill) for each new incremental update. I made a small improvement to
address this:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240527221757.834892-1-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240527221757.834892-2-pablo@netfilter.org/

which improves the results shown by your nft_slew.c test program.

(the excessive number of chain_free() calls you have observed is gone).

Next issue that pops up after applying these two patches is chain
validation from the kernel. With a quick kernel hack to disable chain
validation (that's a bit of cheating, but goal is to find baseline in
case chain validation becomes negligible), then, I can see constant
time to incrementally update a ruleset using your program.

> --Log output--
> 
> Legend:
> 'created idx <i> in <t> ns' shows one single nft_run_cmd_from_buffer() timing.
> (in braces: how many nft_run_cmd_from_buffer() were called since the last log
> output, and how much time has elapsed)
> 
> ----
> created idx    1 in  1114876 ns   (1 in 1 ms)
> created idx  128 in   728617 ns   (127 in 77 ms)
> created idx  256 in  1090610 ns   (128 in 121 ms)
> created idx  384 in  1647839 ns   (128 in 169 ms)
> created idx  512 in  2056034 ns   (128 in 231 ms)
> created idx  640 in  2381756 ns   (128 in 281 ms)
> created idx  768 in  2951399 ns   (128 in 333 ms)
> created idx  896 in  3251231 ns   (128 in 395 ms)
> created idx 1024 in  3623743 ns   (128 in 448 ms)
> created idx 1152 in  4132313 ns   (128 in 506 ms)
> created idx 1280 in  4833977 ns   (128 in 567 ms)
> created idx 1408 in  6512871 ns   (128 in 761 ms)
> created idx 1536 in  7053907 ns   (128 in 874 ms)
> created idx 1664 in  7704614 ns   (128 in 953 ms)
> created idx 1792 in  8203072 ns   (128 in 1031 ms)
> created idx 1920 in  8978494 ns   (128 in 1110 ms)
> created idx 2048 in  9616001 ns   (128 in 1189 ms)
> created idx 2176 in 10496205 ns   (128 in 1266 ms)
> created idx 2304 in 10877421 ns   (128 in 1367 ms)
> created idx 2432 in 11407523 ns   (128 in 1429 ms)
> created idx 2560 in 12016916 ns   (128 in 1509 ms)
> created idx 2688 in 12740551 ns   (128 in 1594 ms)
> created idx 2816 in 13171042 ns   (128 in 1672 ms)
> created idx 2944 in 13911451 ns   (128 in 1754 ms)
> created idx 3072 in 16008519 ns   (128 in 1861 ms)
> created idx 3200 in 15957528 ns   (128 in 1968 ms)
> created idx 3328 in 16310521 ns   (128 in 2063 ms)
> created idx 3456 in 16731960 ns   (128 in 2124 ms)
> created idx 3584 in 17517371 ns   (128 in 2202 ms)
> created idx 3712 in 18090952 ns   (128 in 2272 ms)
> created idx 3840 in 18867300 ns   (128 in 2361 ms)
> created idx 3968 in 19330995 ns   (128 in 2432 ms)
> created idx 4096 in 19871577 ns   (128 in 2519 ms)
> created idx 4224 in 20686331 ns   (128 in 2593 ms)
> created idx 4352 in 21175337 ns   (128 in 2700 ms)
> created idx 4480 in 22022105 ns   (128 in 2766 ms)
> created idx 4608 in 22466535 ns   (128 in 2846 ms)
> created idx 4736 in 23259487 ns   (128 in 2939 ms)
> created idx 4864 in 23976185 ns   (128 in 3015 ms)
> created idx 4992 in 24488874 ns   (128 in 3102 ms)
> created idx 4999 in 24558272 ns   (7 in 172 ms)
> created idx 5000 in 24876752 ns   (1 in 24 ms)
> deleted idx    1 in 21248834 ns   (1 in 21 ms)
> deleted idx  128 in 19360199 ns   (127 in 2485 ms)
> deleted idx  256 in 18756603 ns   (128 in 2437 ms)
> deleted idx  384 in 18838228 ns   (128 in 2616 ms)
> deleted idx  512 in 17583553 ns   (128 in 2347 ms)
> deleted idx  640 in 17042570 ns   (128 in 2217 ms)
> deleted idx  768 in 16833165 ns   (128 in 2162 ms)
> deleted idx  896 in 15824594 ns   (128 in 2101 ms)
> deleted idx 1024 in 15680040 ns   (128 in 2035 ms)
> deleted idx 1152 in 14934728 ns   (128 in 1967 ms)
> deleted idx 1280 in 14373106 ns   (128 in 1907 ms)
> deleted idx 1408 in 14227968 ns   (128 in 1834 ms)
> deleted idx 1536 in 13650017 ns   (128 in 1772 ms)
> deleted idx 1664 in 13268944 ns   (128 in 1710 ms)
> deleted idx 1792 in 12703344 ns   (128 in 1662 ms)
> deleted idx 1920 in 12091815 ns   (128 in 1574 ms)
> deleted idx 2048 in 11260211 ns   (128 in 1482 ms)
> deleted idx 2176 in 10610571 ns   (128 in 1409 ms)
> deleted idx 2304 in 10201007 ns   (128 in 1341 ms)
> deleted idx 2432 in  9894120 ns   (128 in 1273 ms)
> deleted idx 2560 in  8968704 ns   (128 in 1205 ms)
> deleted idx 2688 in  8569120 ns   (128 in 1133 ms)
> deleted idx 2816 in  8340385 ns   (128 in 1083 ms)
> deleted idx 2944 in  8278684 ns   (128 in 1002 ms)
> deleted idx 3072 in  7010837 ns   (128 in 926 ms)
> deleted idx 3200 in  6341329 ns   (128 in 859 ms)
> deleted idx 3328 in  4675342 ns   (128 in 681 ms)
> deleted idx 3456 in  4301439 ns   (128 in 578 ms)
> deleted idx 3584 in  3840153 ns   (128 in 534 ms)
> deleted idx 3712 in  3667216 ns   (128 in 490 ms)
> deleted idx 3840 in  3304109 ns   (128 in 446 ms)
> deleted idx 3968 in  2882374 ns   (128 in 400 ms)
> deleted idx 4096 in  2620334 ns   (128 in 361 ms)
> deleted idx 4224 in  2231384 ns   (128 in 323 ms)
> deleted idx 4352 in  1858886 ns   (128 in 274 ms)
> deleted idx 4480 in  1882147 ns   (128 in 230 ms)
> deleted idx 4608 in  1262297 ns   (128 in 186 ms)
> deleted idx 4736 in   921315 ns   (128 in 143 ms)
> deleted idx 4864 in   617549 ns   (128 in 102 ms)
> deleted idx 4992 in   339924 ns   (128 in 63 ms)
> deleted idx 4999 in   330487 ns   (7 in 2 ms)
> deleted idx 5000 in   392075 ns   (1 in 0 ms)
> ----

> run: nft_slew
> 	./nft_slew
> 
> nft_slew: nft_slew.c
> 	gcc -o nft_slew nft_slew.c -lnftables
> 	sudo setcap cap_net_admin+pe nft_slew

> #include <stdio.h>
> #include <limits.h>
> #include <time.h>
> #include <sys/time.h>
> #include <nftables/libnftables.h>
> 
> void timespec_diff(struct timespec *a, const struct timespec *b)
> {
> 	a->tv_sec -= b->tv_sec;
> 	if (a->tv_nsec < b->tv_nsec) {
> 		a->tv_nsec += 1e9 - b->tv_nsec;
> 		a->tv_sec--;
> 	} else {
> 		a->tv_nsec -= b->tv_nsec;
> 	}
> }
> 
> static const char *create =
> "add table inet slew {"
> "       flags owner;"
> "	map tunmap-pre { typeof ip daddr . @ih,32,32 : verdict; };"
> "	map tunmap-post { typeof meta mark : verdict; };"
> "	chain pre { type filter hook prerouting priority -300; policy accept;"
> "	        udp dport 2152 ip daddr . @ih,32,32 vmap @tunmap-pre;"
> "       };"
> "	chain post { type filter hook postrouting priority 400; policy accept;"
> "		meta mark vmap @tunmap-post;"
> "	};"
> "}"
> ;
> 
> static struct nft_ctx *nft_ctx;
> 
> int main(void) {
> 	nft_ctx = nft_ctx_new(NFT_CTX_DEFAULT);
> 
> 	if (!nft_ctx) {
> 		printf("cannot create nft_ctx\n");
> 		return 1;
> 	}
> 
> 	if (nft_run_cmd_from_buffer(nft_ctx, create)) {
> 		printf("cannot init table\n");
> 		return 1;
> 	}
> 
> 	char cmd[1024];
> 
> 	const unsigned int n = 5000;
> 
> 	struct timespec last_start;
> 	struct timespec last_diff;
> 
> 	struct timespec start;
> 	struct timespec now;
> 
> 	clock_gettime(CLOCK_MONOTONIC, &last_start);
> 	int count_since_last = 0;
> 
> 	for (unsigned int i = 1; i <= n; i++) {
> 		snprintf(cmd, sizeof(cmd),
> 			 "add chain inet slew tunmap-pre-%u;\n"
> 			 "add rule inet slew tunmap-pre-%u"
> 			 " ip daddr set 127.0.1.1"
> 			 " meta mark set %u counter accept;\n"
> 			 "add chain inet slew tunmap-post-%u;\n"
> 			 "add rule inet slew tunmap-post-%u"
> 			 " ip saddr set 127.0.2.1"
> 			 " udp sport set 2152"
> 			 " @ih,32,32 set 0x%x"
> 			 " counter accept;\n"
> 			 "add element inet slew tunmap-pre { "
> 			 "127.0.1.1 . 0x%x : jump tunmap-pre-%u };\n"
> 			 "add element inet slew tunmap-post { %u : jump tunmap-post-%u };\n",
> 			 i, i, i, i, i,
> 			 UINT_MAX - i,
> 			 i,
> 			 i, i, i);
> 
> 		bool show_time = ((i & 0x7f) == 0) || (i == 1) || (i == n) || (i == n - 1);
> 
> 		if (show_time)
> 			clock_gettime(CLOCK_MONOTONIC, &start);
> 
> 		if (nft_run_cmd_from_buffer(nft_ctx, cmd)) {
> 			printf("failed on %u\n", i);
> 			return 1;
> 		}
> 
> 		count_since_last++;
> 		if (show_time) {
> 			clock_gettime(CLOCK_MONOTONIC, &now);
> 
> 			last_diff = now;
> 			timespec_diff(&last_diff, &last_start);
> 			last_start = now;
> 
> 			timespec_diff(&now, &start);
> 			printf("created idx %4d in %8u ns   (%d in %u ms)\n",
> 			       i, now.tv_nsec,
> 			       count_since_last, last_diff.tv_nsec / 1000000 + last_diff.tv_sec * 1000);
> 			fflush(stdout);
> 			count_since_last = 0;
> 			clock_gettime(CLOCK_MONOTONIC, &last_start);
> 		}
> 	}
> 
> 	for (unsigned int i = 1; i <= n; i++) {
> 		snprintf(cmd, sizeof(cmd),
> 			 "delete element inet slew tunmap-pre { 127.0.1.1 . 0x%x };\n"
> 			 "delete element inet slew tunmap-post { %u };\n"
> 			 "delete chain inet slew tunmap-pre-%u;\n"
> 			 "delete chain inet slew tunmap-post-%u;\n",
> 			 i, i, i, i);
> 
> 		bool show_time = ((i & 0x7f) == 0) || (i == 1) || (i == n) || (i == n - 1);
> 
> 		if (show_time)
> 			clock_gettime(CLOCK_MONOTONIC, &start);
> 
> 		if (nft_run_cmd_from_buffer(nft_ctx, cmd)) {
> 			printf("failed on deleting %u\n", i);
> 			return 1;
> 		}
> 
> 		count_since_last++;
> 		if (show_time) {
> 			clock_gettime(CLOCK_MONOTONIC, &now);
> 
> 			last_diff = now;
> 			timespec_diff(&last_diff, &last_start);
> 			last_start = now;
> 
> 			timespec_diff(&now, &start);
> 			printf("deleted idx %4d in %8u ns   (%d in %u ms)\n",
> 			       i, now.tv_nsec,
> 			       count_since_last, last_diff.tv_nsec / 1000000 + last_diff.tv_sec * 1000);
> 			fflush(stdout);
> 			count_since_last = 0;
> 			clock_gettime(CLOCK_MONOTONIC, &last_start);
> 		}
> 	}
> 
> 	nft_ctx_free(nft_ctx);
> 
> 	return 0;
> }


