From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 14:07:29 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629140729.N4136@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15644.58258.483223.56527@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Fri, Jun 28, 2002 at 03:30:42PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

find appended, for use and review, my C version of a /proc/net/ip_conntrack
based hash function and bucket occupation test program. Here is a short
usage summary:

- extract crc32.c and cttest.c from the attachments
- compile with "gcc -o cttest cttest.c"
- by default, /proc/net/ip_conntrack is read. Use the "-f filename" option
  to read the given file, instead.
- use '-u' to enable unidirectional operation; the reverse tuple is ignored.
- by default, the hash bucket count is 7168. Use "-s NUMBER" to modify this.
  Look at the kernel output from ip_conntrack load time to find out the
  bucket count that is active on your system.
- use '-h NAME' to select the hash function to use. Right now you can use:
	o original
		this should be the hash function used by ip_conntrack
	o crc32
		a crc32 over proto/sip/dip/sport/dport
	o random
		no relation to the input at all; this still reads the
		input, but only to get at the number of entries.
		Instead of calculating an input based hash, random()
		is called.
- use '-i bucket-number' to show the input lines corresponding to the
  given hash bucket number. default is to not do this.
- use '-t count' to output the bucket-number corresponding to the first
  bucket with 'count' entries in it.

For example, if you find that the maximum bucket list length is 131,
use '-t 131', and look for "occupation target 131 is at XXX".
Then, use '-i XXX' on the next run to see all input lines falling into
bucket number XXX.

NOTE: as we have seen, it is likely that reading /proc/net/ip_conntrack
does produce duplicate lines. This test program does not try to cope
with that situation; if it applies to you, first save the output to
some file, and use "sort somefile | uniq >testfile" to generate the
input file for this test program.

Oh, maybe I should mention what the program outputs... The main output
comes after the "Count	Length	CT" heading. Each lines gives the COUNT
of all buckets having list LENGTH, sorted by decreasing length. CT gives
the cummulative total over the counts.

Everybody should see the results for their own system. Really. I mean it.

best regards
  Patrick

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crc32.c"

/* crc32.c -- compute the CRC-32 of a data stream
 * Copyright (C) 1995-2002 Mark Adler
 * stolen from zlib CVS
 */

/* @(#) $Id: crc32.c,v 1.2.2.1 2002/03/12 09:34:29 werner Exp $ */

/* ========================================================================
 * Table of CRC-32's of all single-byte values (made by make_crc_table)
 */
static const u32 crc_table[256] = {
  0x00000000L, 0x77073096L, 0xee0e612cL, 0x990951baL, 0x076dc419L,
  0x706af48fL, 0xe963a535L, 0x9e6495a3L, 0x0edb8832L, 0x79dcb8a4L,
  0xe0d5e91eL, 0x97d2d988L, 0x09b64c2bL, 0x7eb17cbdL, 0xe7b82d07L,
  0x90bf1d91L, 0x1db71064L, 0x6ab020f2L, 0xf3b97148L, 0x84be41deL,
  0x1adad47dL, 0x6ddde4ebL, 0xf4d4b551L, 0x83d385c7L, 0x136c9856L,
  0x646ba8c0L, 0xfd62f97aL, 0x8a65c9ecL, 0x14015c4fL, 0x63066cd9L,
  0xfa0f3d63L, 0x8d080df5L, 0x3b6e20c8L, 0x4c69105eL, 0xd56041e4L,
  0xa2677172L, 0x3c03e4d1L, 0x4b04d447L, 0xd20d85fdL, 0xa50ab56bL,
  0x35b5a8faL, 0x42b2986cL, 0xdbbbc9d6L, 0xacbcf940L, 0x32d86ce3L,
  0x45df5c75L, 0xdcd60dcfL, 0xabd13d59L, 0x26d930acL, 0x51de003aL,
  0xc8d75180L, 0xbfd06116L, 0x21b4f4b5L, 0x56b3c423L, 0xcfba9599L,
  0xb8bda50fL, 0x2802b89eL, 0x5f058808L, 0xc60cd9b2L, 0xb10be924L,
  0x2f6f7c87L, 0x58684c11L, 0xc1611dabL, 0xb6662d3dL, 0x76dc4190L,
  0x01db7106L, 0x98d220bcL, 0xefd5102aL, 0x71b18589L, 0x06b6b51fL,
  0x9fbfe4a5L, 0xe8b8d433L, 0x7807c9a2L, 0x0f00f934L, 0x9609a88eL,
  0xe10e9818L, 0x7f6a0dbbL, 0x086d3d2dL, 0x91646c97L, 0xe6635c01L,
  0x6b6b51f4L, 0x1c6c6162L, 0x856530d8L, 0xf262004eL, 0x6c0695edL,
  0x1b01a57bL, 0x8208f4c1L, 0xf50fc457L, 0x65b0d9c6L, 0x12b7e950L,
  0x8bbeb8eaL, 0xfcb9887cL, 0x62dd1ddfL, 0x15da2d49L, 0x8cd37cf3L,
  0xfbd44c65L, 0x4db26158L, 0x3ab551ceL, 0xa3bc0074L, 0xd4bb30e2L,
  0x4adfa541L, 0x3dd895d7L, 0xa4d1c46dL, 0xd3d6f4fbL, 0x4369e96aL,
  0x346ed9fcL, 0xad678846L, 0xda60b8d0L, 0x44042d73L, 0x33031de5L,
  0xaa0a4c5fL, 0xdd0d7cc9L, 0x5005713cL, 0x270241aaL, 0xbe0b1010L,
  0xc90c2086L, 0x5768b525L, 0x206f85b3L, 0xb966d409L, 0xce61e49fL,
  0x5edef90eL, 0x29d9c998L, 0xb0d09822L, 0xc7d7a8b4L, 0x59b33d17L,
  0x2eb40d81L, 0xb7bd5c3bL, 0xc0ba6cadL, 0xedb88320L, 0x9abfb3b6L,
  0x03b6e20cL, 0x74b1d29aL, 0xead54739L, 0x9dd277afL, 0x04db2615L,
  0x73dc1683L, 0xe3630b12L, 0x94643b84L, 0x0d6d6a3eL, 0x7a6a5aa8L,
  0xe40ecf0bL, 0x9309ff9dL, 0x0a00ae27L, 0x7d079eb1L, 0xf00f9344L,
  0x8708a3d2L, 0x1e01f268L, 0x6906c2feL, 0xf762575dL, 0x806567cbL,
  0x196c3671L, 0x6e6b06e7L, 0xfed41b76L, 0x89d32be0L, 0x10da7a5aL,
  0x67dd4accL, 0xf9b9df6fL, 0x8ebeeff9L, 0x17b7be43L, 0x60b08ed5L,
  0xd6d6a3e8L, 0xa1d1937eL, 0x38d8c2c4L, 0x4fdff252L, 0xd1bb67f1L,
  0xa6bc5767L, 0x3fb506ddL, 0x48b2364bL, 0xd80d2bdaL, 0xaf0a1b4cL,
  0x36034af6L, 0x41047a60L, 0xdf60efc3L, 0xa867df55L, 0x316e8eefL,
  0x4669be79L, 0xcb61b38cL, 0xbc66831aL, 0x256fd2a0L, 0x5268e236L,
  0xcc0c7795L, 0xbb0b4703L, 0x220216b9L, 0x5505262fL, 0xc5ba3bbeL,
  0xb2bd0b28L, 0x2bb45a92L, 0x5cb36a04L, 0xc2d7ffa7L, 0xb5d0cf31L,
  0x2cd99e8bL, 0x5bdeae1dL, 0x9b64c2b0L, 0xec63f226L, 0x756aa39cL,
  0x026d930aL, 0x9c0906a9L, 0xeb0e363fL, 0x72076785L, 0x05005713L,
  0x95bf4a82L, 0xe2b87a14L, 0x7bb12baeL, 0x0cb61b38L, 0x92d28e9bL,
  0xe5d5be0dL, 0x7cdcefb7L, 0x0bdbdf21L, 0x86d3d2d4L, 0xf1d4e242L,
  0x68ddb3f8L, 0x1fda836eL, 0x81be16cdL, 0xf6b9265bL, 0x6fb077e1L,
  0x18b74777L, 0x88085ae6L, 0xff0f6a70L, 0x66063bcaL, 0x11010b5cL,
  0x8f659effL, 0xf862ae69L, 0x616bffd3L, 0x166ccf45L, 0xa00ae278L,
  0xd70dd2eeL, 0x4e048354L, 0x3903b3c2L, 0xa7672661L, 0xd06016f7L,
  0x4969474dL, 0x3e6e77dbL, 0xaed16a4aL, 0xd9d65adcL, 0x40df0b66L,
  0x37d83bf0L, 0xa9bcae53L, 0xdebb9ec5L, 0x47b2cf7fL, 0x30b5ffe9L,
  0xbdbdf21cL, 0xcabac28aL, 0x53b39330L, 0x24b4a3a6L, 0xbad03605L,
  0xcdd70693L, 0x54de5729L, 0x23d967bfL, 0xb3667a2eL, 0xc4614ab8L,
  0x5d681b02L, 0x2a6f2b94L, 0xb40bbe37L, 0xc30c8ea1L, 0x5a05df1bL,
  0x2d02ef8dL
};

/* ========================================================================= */
#define DO1(buf) crc = crc_table[((int)crc ^ (*buf++)) & 0xff] ^ (crc >> 8);
#define DO2(buf)  DO1(buf); DO1(buf);
#define DO4(buf)  DO2(buf); DO2(buf);
#define DO8(buf)  DO4(buf); DO4(buf);

/* ========================================================================= */
u32 crc32(crc, buf, len)
    u32 crc;
    const char *buf;
    int len;
{
    crc = crc ^ 0xffffffffL;
    while (len >= 8)
    {
	DO8(buf);
	len -= 8;
    }
    if (len) do {
	DO1(buf);
    } while (--len);
    return crc ^ 0xffffffffL;
}

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cttest.c"

/* cttest.c - parse /proc/net/ip_conntrack, compute bucket occupation
 *
 * This is how lines look:
 *
 * udp      17 0 src=213.6.73.215 dst=62.104.191.241 sport=1858 dport=53 src=62.104.191.241 dst=213.6.73.215 sport=53 dport=1858 use=1 
 * tcp      6 114 TIME_WAIT src=62.104.211.64 dst=212.7.144.66 sport=34685 dport=80 src=212.7.144.66 dst=62.104.211.64 sport=80 dport=34685 [ASSURED] use=1 
 */

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>
#include <getopt.h>
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>

typedef unsigned long u32;
typedef unsigned short u16;
typedef unsigned char u8;

struct ct_key {
	u32 sip;
	u32 dip;
	u16 sport;
	u16 dport;
	u8 proto;
};

static u32 hash_conntrack(struct ct_key *key)
{
	return ntohl(key->sip + key->dip
		+ key->sport + key->dport
		+ key->proto)
		+ ntohs(key->sport);
}

#include "crc32.c"

static u32 hash_crc32(struct ct_key *key)
{
	u32 crc = crc32(0, (const char *) &key->proto, sizeof(key->proto));
	u32 v32;
	u16 v16;
	v32 = ntohl(key->sip);
	crc = crc32(crc, (const char *) &v32, sizeof(v32));
	v32 = ntohl(key->dip);
	crc = crc32(crc, (const char *) &v32, sizeof(v32));
	v16 = ntohs(key->sport);
	crc = crc32(crc, (const char *) &v16, sizeof(v16));
	v16 = ntohs(key->dport);
	crc = crc32(crc, (const char *) &v16, sizeof(v16));
	return crc;
}

static u32 hash_random(struct ct_key *key)
{
	return (u32) random();
}

struct hash_def {
	char *name;
	u32 (*hash_f)(struct ct_key *);
};

#define NR_HASHES (sizeof(hashes)/sizeof(hashes[0]))

static struct hash_def hashes[] = {
	{ "original", hash_conntrack },
	{ "random", hash_random },
	{ "crc32", hash_crc32 },
};

static u32 htable_size = 7168;
static u32 *occupation;
static struct hash_def *test_hash = hashes;

static void do_init(void)
{
	u32 idx;
	occupation = malloc(sizeof(*occupation) * htable_size);
	for (idx=0; idx<htable_size; idx++)
		occupation[idx] = 0;
}

static int display_target = -1;

static int do_count(struct ct_key *key)
{
	u32 idx = test_hash->hash_f(key) % htable_size;
	occupation[idx]++;
	return ((int)idx) == display_target;
}

static u32 parse_ip(char *t)
{
	char *p = strchr(t, '=');
	if (!p++) return 0;
	return inet_addr(p);
}

static u16 parse_port(char *t)
{
	char *p = strchr(t, '=');
	if (!p++) return 0;
	return (u16) strtoul(p, 0, 10);
}

static int unidir;

static int process(char *p)
{
	struct ct_key key[1];
	char *tok;
	int res;

	strtok(p, " \t\n");					/* prot text */
	tok = strtok(0, " \t\n");
	key->proto = (u8) strtoul(tok, 0, 10);			/* prot num */
	strtok(0, " \t\n");					/* timeout */
	switch (key->proto) {
		case 6:  strtok(0, " \t\n");			/* tcp state */
		case 17: break;
		default: return 0;
	}
	/* forward */
	tok = strtok(0, " \t\n"); key->sip = parse_ip(tok);	/* src ip */
	tok = strtok(0, " \t\n"); key->dip = parse_ip(tok);	/* dst ip */
	tok = strtok(0, " \t\n"); key->sport = parse_port(tok);	/* src port */
	tok = strtok(0, " \t\n"); key->dport = parse_port(tok);	/* dst port */
	res = do_count(key);
	if (unidir) return res;
	/* reverse */
	tok = strtok(0, " \t\n"); key->sip = parse_ip(tok);	/* src ip */
	tok = strtok(0, " \t\n"); key->dip = parse_ip(tok);	/* dst ip */
	tok = strtok(0, " \t\n"); key->sport = parse_port(tok);	/* src port */
	tok = strtok(0, " \t\n"); key->dport = parse_port(tok);	/* dst port */
	return res | do_count(key);
}

static int occupation_target = -1;

static void show_occupation(void)
{
	u32 idx, maxlen, total, partial, *agg;

	for (maxlen=0, total=0, idx=0; idx<htable_size; idx++) {
		total += occupation[idx];
		if (occupation[idx] > maxlen)
			maxlen = occupation[idx];
	}
	printf("hash function: %s\n", test_hash->name);
	printf("maximum bucket list length: %lu\n", maxlen);
	printf("total number of entries: %lu\n", total);
	agg = malloc(sizeof(*agg) * (maxlen+1));
	for (idx=0; idx<=maxlen; idx++)
		agg[idx] = 0;
	for (idx=0; idx<htable_size; idx++) {
		agg[occupation[idx]]++;
		if (((int)occupation[idx]) == occupation_target) {
			printf("occupation target %d at %lu\n",
				occupation_target, idx);
			occupation_target = -1;
		}
	}
	printf("Count\tLength\tCT\n");
	for (partial=0, idx=maxlen; idx>0; idx--) {
		double d;
		if (agg[idx] == 0) continue;
		partial += idx * agg[idx];
		d = (100.0 * partial) / (1.0 * total);
		printf("%lu\t%lu\t%.02f%%\n", agg[idx], idx, d);
	}
	printf("%lu\t0\t100.00%%\n", agg[idx]);
}

static struct hash_def *find_hash(char *name)
{
	u32 idx;
	for (idx=0; idx<NR_HASHES; idx++)
		if (0 == strcmp(name, hashes[idx].name))
			return hashes+idx;
	fprintf(stderr, "no hash function named '%s'\n", name);
	return 0;
}

static void usage(void)
{
}

int main(int argc, char **argv)
{
	int c;
	char buf[512], copy[512];
	char *filename = "/proc/net/ip_conntrack";
	FILE *fp;

	while (EOF != (c = getopt(argc, argv, "f:us:h:i:t:"))) switch(c) {
		case 'f': filename = optarg; break;
		case 'u': unidir = 1; break;
		case 's': htable_size = strtoul(optarg, 0, 10); break;
		case 'h': test_hash = find_hash(optarg); break;
		case 'i': display_target = strtol(optarg, 0, 10); break;
		case 't': occupation_target = strtol(optarg, 0, 10); break;
		default: usage();
	}
	if (!test_hash) return 1;
	fp = (0 == strcmp(filename, "-")) ? stdin : fopen(filename, "r");
	if (!fp) {
		fprintf(stderr, "%s: %s\n", filename, strerror(errno));
		exit(1);
	}
	printf("filename: %s\n", filename);
	do_init();
	while (fgets(buf, sizeof(buf), fp)) {
		if (display_target != -1)
			strcpy(copy, buf);
		if (process(buf))
			printf("[%d]\t%s", display_target, copy);
	}
	if (fp != stdin) fclose(fp);
	show_occupation();
	return 0;
}

--WhfpMioaduB5tiZL--
