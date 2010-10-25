From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Mon, 25 Oct 2010 11:28:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010251128270.9308@obet.zrqbmnf.qr>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com> <20101024182508.GM15247@Chamillionaire.breakpoint.cc> <1287947511.2658.1678.camel@edumazet-laptop> <alpine.LNX.2.01.1010242222380.18070@obet.zrqbmnf.qr> <AANLkTimqOaBx4hr4RiuBQW-JePcf4QScMP56p20eTtF5@mail.gmail.com>
 <alpine.LNX.2.01.1010251050150.9308@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37405 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0JYJ2u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:28:50 -0400
In-Reply-To: <alpine.LNX.2.01.1010251050150.9308@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-10-25 11:13, Jan Engelhardt wrote:

>On Monday 2010-10-25 05:19, Maciej =C5=BBenczykowski wrote:
>
>>> To be read as: one OV is reachable by 13 input values; 5 OVs are ea=
ch
>>> reachable by 12 input values (IV) (i.e. a group of 60 IV lead to on=
ly 5
>>> OV), etc.
>>
>>I don't quite follow what you are doing here.
>
>See the code at the end of the mail; that will probably help some=20
>people more than my description.

/* calculate all possible 32-bit hashes
   needs 16G of address space, so better have a 64-bit kernel at hand
 */
#define _GNU_SOURCE 1
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
#define S_IRUGO (S_IRUSR | S_IRGRP | S_IROTH)
#define S_IWUGO (S_IWUSR | S_IWGRP | S_IWOTH)

#define jrot(x,k) (((x) << (k)) | ((x) >> (32 - (k))))

/* jhash_mix - mix 3 32-bit values reversibly. */
#define jhash_mix(a, b, c) { \
	a -=3D c; a ^=3D jrot(c,  4); c +=3D b; \
	b -=3D a; b ^=3D jrot(a,  6); a +=3D c; \
	c -=3D b; c ^=3D jrot(b,  8); b +=3D a; \
	a -=3D c; a ^=3D jrot(c, 16); c +=3D b; \
	b -=3D a; b ^=3D jrot(a, 19); a +=3D c; \
	c -=3D b; c ^=3D jrot(b,  4); b +=3D a; \
}

#define jhash_final(a, b, c) { \
	c ^=3D b; c -=3D jrot(b, 14); \
	a ^=3D c; a -=3D jrot(c, 11); \
	b ^=3D a; b -=3D jrot(a, 25); \
	c ^=3D b; c -=3D jrot(b, 16); \
	a ^=3D c; a -=3D jrot(c,  4);  \
	b ^=3D a; b -=3D jrot(a, 14); \
	c ^=3D b; c -=3D jrot(b, 24); \
}

static uint32_t hash_jlookup3(const void *vkey, size_t length)
{
	static const unsigned int JHASH_GOLDEN_RATIO =3D 0x9e3779b9;
	const uint8_t *key =3D vkey;
	uint32_t a, b, c;

	a =3D b =3D c =3D JHASH_GOLDEN_RATIO + length;
	/* All but the last block: affect some 32 bits of (a,b,c) */
	for (; length > 12; length -=3D 12, key +=3D 12) {
		a +=3D key[0] + ((uint32_t)key[1] << 8) +
		     ((uint32_t)key[2] << 16) + ((uint32_t)key[3] << 24);
		b +=3D key[4] + ((uint32_t)key[5] << 8) +
		     ((uint32_t)key[6] << 16) + ((uint32_t)key[7] << 24);
		c +=3D key[8] + ((uint32_t)key[9] << 8) +
		     ((uint32_t)key[10] << 16)+ ((uint32_t)key[11] << 24);
		jhash_mix(a, b, c);
	}

	switch (length) {
	case 12: c +=3D ((uint32_t)key[11]) << 24;
	case 11: c +=3D ((uint32_t)key[10]) << 16;
	case 10: c +=3D ((uint32_t)key[9])  << 8;
	case  9: c +=3D key[8];
	case  8: b +=3D ((uint32_t)key[7]) << 24;
	case  7: b +=3D ((uint32_t)key[6]) << 16;
	case  6: b +=3D ((uint32_t)key[5]) << 8;
	case  5: b +=3D key[4];
	case  4: a +=3D ((uint32_t)key[3]) << 24;
	case  3: a +=3D ((uint32_t)key[2]) << 16;
	case  2: a +=3D ((uint32_t)key[1]) << 8;
	case  1: a +=3D key[0];
		break;
	case  0: return c;
	}

	jhash_final(a,b,c);
	return c;
}

static uint32_t hash_djb2(const void *p, size_t z)
{
	const char *c =3D p;
	unsigned long v =3D 5381;

	while (*c !=3D '\0')
		v =3D ((v << 5) + v) ^ *c++;
		/* v =3D v * 33 ^ *c++; */

	return v;
}

static uint32_t *freq;
static const unsigned long long freq_size =3D 0x100000000UL * sizeof(*f=
req);

static void map_freq(void)
{
	int fd;

	fd =3D open("jenkins3.frq", O_RDWR | O_CREAT, S_IRUGO | S_IWUGO);
	if (fd < 0) {
		perror("open");
		abort();
	}

	if (ftruncate(fd, freq_size) < 0) {
		perror("ftruncate");
		abort();
	}

	freq =3D mmap(NULL, freq_size, PROT_READ | PROT_WRITE,
	       MAP_SHARED, fd, 0);
	if (freq =3D=3D NULL) {
		perror("mmap");
		abort();
	}
}

static void malloc_freq(void)
{
	freq =3D malloc(freq_size);
	if (freq =3D=3D NULL) {
		perror("malloc");
		abort();
	}
}

static inline void calc_all_hashes(void)
{
	uint32_t x, y;

	memset(freq, 0, freq_size);
	for (x =3D 0; x < UINT32_MAX; ++x) {
		if ((x & 0xFFFFF) =3D=3D 0)
			fprintf(stderr, "\r\e[2K""fill: %08x", x);
		y =3D hash_jlookup3(&x, sizeof(x));
		if (freq[y] < UINT32_MAX)
			++freq[y];
	}
}

static void freq_chart(void)
{
	uint32_t dist[32];
	uint32_t x;

	for (x =3D 0; x < UINT32_MAX; ++x) {
		if ((x & 0xFFFFFF) =3D=3D 0)
			fprintf(stderr, "\r\e[2K""%s: %08x", __func__, x);
		if (freq[x] >=3D ARRAY_SIZE(dist))
			printf("\nHash %08x reachable by %u input values\n",
			       x, dist[x]);
		if (dist[freq[x]] < UINT32_MAX)
			++dist[freq[x]];
	}
	if (freq[UINT32_MAX] < ARRAY_SIZE(dist) &&
	    dist[freq[UINT32_MAX]] < UINT16_MAX)
		++dist[freq[UINT32_MAX]];

	fprintf(stderr, "\n----\n");
	for (x =3D 0; x < ARRAY_SIZE(dist); ++x)
		printf("%10ux %u\n", dist[x], x);
}

static void xy_plot(void)
{
	uint32_t x, r =3D 0;

	printf("# x y\n");
	for (x =3D 0; x < UINT32_MAX; ++x) {
		r +=3D freq[x];
		if ((x & 0xFFFFF) =3D=3D 0)
			printf("%u %u\n", x, r);
	}
}

int main(int argc, const char **argv)
{
	step =3D (argc >=3D 2) ? strtoul(argv[1], NULL, 0) : 0;
//	map_freq();
	malloc_freq();
	calc_all_hashes();
	if (step =3D=3D 1)
		freq_chart();
	else if (step =3D=3D 2)
		xy_plot();
	return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
