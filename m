Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D553F12DD88
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 05:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.212.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715320024; cv=none; b=c3wOibJE9UUI8rbcvdaOLp53sPLbbZWrJ3IEy6s6Oj42TMHcbHTCxiP2a/MYA0B/nvfNzGjUUZkUJEJOoalmHaN2TplwpkrqBNzSWDMeXhZv4EGXwbrPNJZ+n5WHayKIf67ILTU7eQCsikP7mLMTAnQaxgA5s7Puhen+bkLO6X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715320024; c=relaxed/simple;
	bh=WrLrsgSmDEAumbzZTDkRmnnW+h8q+VpP3WVacEi/PbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jg18D75/mvjGNtdhc2G7A3Dvl+gbucIUzbYFFOESBm7O15MOlkbsugeMVleoKtdxpHnq102Me0uLt3j50++qJb7mZI2/A9KDp8oGMJAD3m2JZ3Azldvf1nCaQGHwZSM+Z4pw6WcuL3jiZRGq4fUqF0w9/zv+bZCALIzY7uWapjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de; spf=pass smtp.mailfrom=sysmocom.de; arc=none smtp.client-ip=176.9.212.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sysmocom.de
Received: from localhost (localhost [127.0.0.1])
	by mail.sysmocom.de (Postfix) with ESMTP id 3869CC8A702;
	Fri, 10 May 2024 05:46:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
	by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cLOL1R78BUkH; Fri, 10 May 2024 05:46:51 +0000 (UTC)
Received: from my.box (i59F7ADB4.versanet.de [89.247.173.180])
	by mail.sysmocom.de (Postfix) with ESMTPSA id C238CC8A6F6;
	Fri, 10 May 2024 05:46:51 +0000 (UTC)
Date: Fri, 10 May 2024 07:46:50 +0200
From: Neels Hofmeyr <nhofmeyr@sysmocom.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables with thousands of chains is unreasonably slow
Message-ID: <Zj20ysFpLN4oJGkZ@my.box>
References: <ZjjGOyXkmeudzzc5@my.box>
 <ZjqsBomPs2qWEi_5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Sfh4tAmytpSGVbV7"
Content-Disposition: inline
In-Reply-To: <ZjqsBomPs2qWEi_5@calendula>


--Sfh4tAmytpSGVbV7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have some more news on my complaints about nftables speed =)
Before, I assumed the performance loss was exponential, but turns out that it
is linear.

Attached is a reproduction program in c.
Below is the output I get, first the explanation.

An aim is to crank the n in the program up to 200k
and still complete < 2 minutes;

I have taken the nft ruleset as used in osmo-upf, I have not yet spent time to
find a more minimal nft script.

One "item" here is a batch of two chains with a rule each, plus two map entries
(exactly as done for one direction of a GTP-U tunnel in osmo-upf).

The program calls one nft_run_cmd_from_buffer() per such item.
Roughly every 128th time, the program prints the time it takes for a single
nft_run_cmd_from_buffer() call adding one such item.

The first ~200 items take less than a millisecond each.
The 5000th item takes ~25 milliseconds, factor 34.
The increase is *linear* (attached a chart).

Then the program goes on to delete the same items one by one. The first one
takes ~21ms to delete, the last few only 0.33 ms each, factor 60.
The transition is also linear.

--Log output--

Legend:
'created idx <i> in <t> ns' shows one single nft_run_cmd_from_buffer() timing.
(in braces: how many nft_run_cmd_from_buffer() were called since the last log
output, and how much time has elapsed)

----
created idx    1 in  1114876 ns   (1 in 1 ms)
created idx  128 in   728617 ns   (127 in 77 ms)
created idx  256 in  1090610 ns   (128 in 121 ms)
created idx  384 in  1647839 ns   (128 in 169 ms)
created idx  512 in  2056034 ns   (128 in 231 ms)
created idx  640 in  2381756 ns   (128 in 281 ms)
created idx  768 in  2951399 ns   (128 in 333 ms)
created idx  896 in  3251231 ns   (128 in 395 ms)
created idx 1024 in  3623743 ns   (128 in 448 ms)
created idx 1152 in  4132313 ns   (128 in 506 ms)
created idx 1280 in  4833977 ns   (128 in 567 ms)
created idx 1408 in  6512871 ns   (128 in 761 ms)
created idx 1536 in  7053907 ns   (128 in 874 ms)
created idx 1664 in  7704614 ns   (128 in 953 ms)
created idx 1792 in  8203072 ns   (128 in 1031 ms)
created idx 1920 in  8978494 ns   (128 in 1110 ms)
created idx 2048 in  9616001 ns   (128 in 1189 ms)
created idx 2176 in 10496205 ns   (128 in 1266 ms)
created idx 2304 in 10877421 ns   (128 in 1367 ms)
created idx 2432 in 11407523 ns   (128 in 1429 ms)
created idx 2560 in 12016916 ns   (128 in 1509 ms)
created idx 2688 in 12740551 ns   (128 in 1594 ms)
created idx 2816 in 13171042 ns   (128 in 1672 ms)
created idx 2944 in 13911451 ns   (128 in 1754 ms)
created idx 3072 in 16008519 ns   (128 in 1861 ms)
created idx 3200 in 15957528 ns   (128 in 1968 ms)
created idx 3328 in 16310521 ns   (128 in 2063 ms)
created idx 3456 in 16731960 ns   (128 in 2124 ms)
created idx 3584 in 17517371 ns   (128 in 2202 ms)
created idx 3712 in 18090952 ns   (128 in 2272 ms)
created idx 3840 in 18867300 ns   (128 in 2361 ms)
created idx 3968 in 19330995 ns   (128 in 2432 ms)
created idx 4096 in 19871577 ns   (128 in 2519 ms)
created idx 4224 in 20686331 ns   (128 in 2593 ms)
created idx 4352 in 21175337 ns   (128 in 2700 ms)
created idx 4480 in 22022105 ns   (128 in 2766 ms)
created idx 4608 in 22466535 ns   (128 in 2846 ms)
created idx 4736 in 23259487 ns   (128 in 2939 ms)
created idx 4864 in 23976185 ns   (128 in 3015 ms)
created idx 4992 in 24488874 ns   (128 in 3102 ms)
created idx 4999 in 24558272 ns   (7 in 172 ms)
created idx 5000 in 24876752 ns   (1 in 24 ms)
deleted idx    1 in 21248834 ns   (1 in 21 ms)
deleted idx  128 in 19360199 ns   (127 in 2485 ms)
deleted idx  256 in 18756603 ns   (128 in 2437 ms)
deleted idx  384 in 18838228 ns   (128 in 2616 ms)
deleted idx  512 in 17583553 ns   (128 in 2347 ms)
deleted idx  640 in 17042570 ns   (128 in 2217 ms)
deleted idx  768 in 16833165 ns   (128 in 2162 ms)
deleted idx  896 in 15824594 ns   (128 in 2101 ms)
deleted idx 1024 in 15680040 ns   (128 in 2035 ms)
deleted idx 1152 in 14934728 ns   (128 in 1967 ms)
deleted idx 1280 in 14373106 ns   (128 in 1907 ms)
deleted idx 1408 in 14227968 ns   (128 in 1834 ms)
deleted idx 1536 in 13650017 ns   (128 in 1772 ms)
deleted idx 1664 in 13268944 ns   (128 in 1710 ms)
deleted idx 1792 in 12703344 ns   (128 in 1662 ms)
deleted idx 1920 in 12091815 ns   (128 in 1574 ms)
deleted idx 2048 in 11260211 ns   (128 in 1482 ms)
deleted idx 2176 in 10610571 ns   (128 in 1409 ms)
deleted idx 2304 in 10201007 ns   (128 in 1341 ms)
deleted idx 2432 in  9894120 ns   (128 in 1273 ms)
deleted idx 2560 in  8968704 ns   (128 in 1205 ms)
deleted idx 2688 in  8569120 ns   (128 in 1133 ms)
deleted idx 2816 in  8340385 ns   (128 in 1083 ms)
deleted idx 2944 in  8278684 ns   (128 in 1002 ms)
deleted idx 3072 in  7010837 ns   (128 in 926 ms)
deleted idx 3200 in  6341329 ns   (128 in 859 ms)
deleted idx 3328 in  4675342 ns   (128 in 681 ms)
deleted idx 3456 in  4301439 ns   (128 in 578 ms)
deleted idx 3584 in  3840153 ns   (128 in 534 ms)
deleted idx 3712 in  3667216 ns   (128 in 490 ms)
deleted idx 3840 in  3304109 ns   (128 in 446 ms)
deleted idx 3968 in  2882374 ns   (128 in 400 ms)
deleted idx 4096 in  2620334 ns   (128 in 361 ms)
deleted idx 4224 in  2231384 ns   (128 in 323 ms)
deleted idx 4352 in  1858886 ns   (128 in 274 ms)
deleted idx 4480 in  1882147 ns   (128 in 230 ms)
deleted idx 4608 in  1262297 ns   (128 in 186 ms)
deleted idx 4736 in   921315 ns   (128 in 143 ms)
deleted idx 4864 in   617549 ns   (128 in 102 ms)
deleted idx 4992 in   339924 ns   (128 in 63 ms)
deleted idx 4999 in   330487 ns   (7 in 2 ms)
deleted idx 5000 in   392075 ns   (1 in 0 ms)
----

--Sfh4tAmytpSGVbV7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

run: nft_slew
	./nft_slew

nft_slew: nft_slew.c
	gcc -o nft_slew nft_slew.c -lnftables
	sudo setcap cap_net_admin+pe nft_slew

--Sfh4tAmytpSGVbV7
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="nft_slew.c"

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <sys/time.h>
#include <nftables/libnftables.h>

void timespec_diff(struct timespec *a, const struct timespec *b)
{
	a->tv_sec -= b->tv_sec;
	if (a->tv_nsec < b->tv_nsec) {
		a->tv_nsec += 1e9 - b->tv_nsec;
		a->tv_sec--;
	} else {
		a->tv_nsec -= b->tv_nsec;
	}
}

static const char *create =
"add table inet slew {"
"       flags owner;"
"	map tunmap-pre { typeof ip daddr . @ih,32,32 : verdict; };"
"	map tunmap-post { typeof meta mark : verdict; };"
"	chain pre { type filter hook prerouting priority -300; policy accept;"
"	        udp dport 2152 ip daddr . @ih,32,32 vmap @tunmap-pre;"
"       };"
"	chain post { type filter hook postrouting priority 400; policy accept;"
"		meta mark vmap @tunmap-post;"
"	};"
"}"
;

static struct nft_ctx *nft_ctx;

int main(void) {
	nft_ctx = nft_ctx_new(NFT_CTX_DEFAULT);

	if (!nft_ctx) {
		printf("cannot create nft_ctx\n");
		return 1;
	}

	if (nft_run_cmd_from_buffer(nft_ctx, create)) {
		printf("cannot init table\n");
		return 1;
	}

	char cmd[1024];

	const unsigned int n = 5000;

	struct timespec last_start;
	struct timespec last_diff;

	struct timespec start;
	struct timespec now;

	clock_gettime(CLOCK_MONOTONIC, &last_start);
	int count_since_last = 0;

	for (unsigned int i = 1; i <= n; i++) {
		snprintf(cmd, sizeof(cmd),
			 "add chain inet slew tunmap-pre-%u;\n"
			 "add rule inet slew tunmap-pre-%u"
			 " ip daddr set 127.0.1.1"
			 " meta mark set %u counter accept;\n"
			 "add chain inet slew tunmap-post-%u;\n"
			 "add rule inet slew tunmap-post-%u"
			 " ip saddr set 127.0.2.1"
			 " udp sport set 2152"
			 " @ih,32,32 set 0x%x"
			 " counter accept;\n"
			 "add element inet slew tunmap-pre { "
			 "127.0.1.1 . 0x%x : jump tunmap-pre-%u };\n"
			 "add element inet slew tunmap-post { %u : jump tunmap-post-%u };\n",
			 i, i, i, i, i,
			 UINT_MAX - i,
			 i,
			 i, i, i);

		bool show_time = ((i & 0x7f) == 0) || (i == 1) || (i == n) || (i == n - 1);

		if (show_time)
			clock_gettime(CLOCK_MONOTONIC, &start);

		if (nft_run_cmd_from_buffer(nft_ctx, cmd)) {
			printf("failed on %u\n", i);
			return 1;
		}

		count_since_last++;
		if (show_time) {
			clock_gettime(CLOCK_MONOTONIC, &now);

			last_diff = now;
			timespec_diff(&last_diff, &last_start);
			last_start = now;

			timespec_diff(&now, &start);
			printf("created idx %4d in %8u ns   (%d in %u ms)\n",
			       i, now.tv_nsec,
			       count_since_last, last_diff.tv_nsec / 1000000 + last_diff.tv_sec * 1000);
			fflush(stdout);
			count_since_last = 0;
			clock_gettime(CLOCK_MONOTONIC, &last_start);
		}
	}

	for (unsigned int i = 1; i <= n; i++) {
		snprintf(cmd, sizeof(cmd),
			 "delete element inet slew tunmap-pre { 127.0.1.1 . 0x%x };\n"
			 "delete element inet slew tunmap-post { %u };\n"
			 "delete chain inet slew tunmap-pre-%u;\n"
			 "delete chain inet slew tunmap-post-%u;\n",
			 i, i, i, i);

		bool show_time = ((i & 0x7f) == 0) || (i == 1) || (i == n) || (i == n - 1);

		if (show_time)
			clock_gettime(CLOCK_MONOTONIC, &start);

		if (nft_run_cmd_from_buffer(nft_ctx, cmd)) {
			printf("failed on deleting %u\n", i);
			return 1;
		}

		count_since_last++;
		if (show_time) {
			clock_gettime(CLOCK_MONOTONIC, &now);

			last_diff = now;
			timespec_diff(&last_diff, &last_start);
			last_start = now;

			timespec_diff(&now, &start);
			printf("deleted idx %4d in %8u ns   (%d in %u ms)\n",
			       i, now.tv_nsec,
			       count_since_last, last_diff.tv_nsec / 1000000 + last_diff.tv_sec * 1000);
			fflush(stdout);
			count_since_last = 0;
			clock_gettime(CLOCK_MONOTONIC, &last_start);
		}
	}

	nft_ctx_free(nft_ctx);

	return 0;
}

--Sfh4tAmytpSGVbV7
Content-Type: image/png
Content-Disposition: attachment; filename="chart.png"
Content-Transfer-Encoding: base64

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
sdYLAICt/hdCQI3NruuuIwAAAABJRU5ErkJggg==

--Sfh4tAmytpSGVbV7--
