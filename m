Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27486C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 07:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8B522D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 07:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfHUH4U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 03:56:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42788 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfHUH4U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 03:56:20 -0400
Received: from 2.general.paelzer.uk.vpn ([10.172.196.173] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <christian.ehrhardt@canonical.com>)
        id 1i0LTd-0001fr-L5; Wed, 21 Aug 2019 07:56:17 +0000
From:   Christian Ehrhardt <christian.ehrhardt@canonical.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: [RFC 0/1] avoid busy loop in __nft_build_cache
Date:   Wed, 21 Aug 2019 09:56:10 +0200
Message-Id: <20190821075611.30918-1-christian.ehrhardt@canonical.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have ran into a busy loop in netfilter due to the testing that Ubuntu does
=> https://bugs.launchpad.net/ubuntu/+source/iptables/+bug/1840633

This only occurs with 1.8.3, and in the same test didn't affet 1.6.*

It seems to be rare, we run that test quite a few times and only in one
special environment it does trigger.
But there 100%, I don't know exact steps to reproduce, but once in that
broken mode any call to "iptables -N" will fail with a hang.

Here is a stacktrace of a new -N call into the loop (the last few lines will
just repeat).
=> https://paste.ubuntu.com/p/YTQStdg6vm/

Note: once in that bad state other calls hang as well, like "iptables -L"
Note: Nothing suspicious in dmesg or journal
Note: not sure if it is important, but this happened on Ubuntu kernel
      5.2.0-10-generic. Due to the way I need to trigger this it is hard
      to test
others until I have found an easier way to reproduce it.

I have attached gdb to one such hanging process and found it looping in:
 static void __nft_build_cache(struct nft_handle *h)
 {
 »···uint32_t genid_start, genid_stop;

 retry:
 »···mnl_genid_get(h, &genid_start);
 »···fetch_chain_cache(h);
 »···fetch_rule_cache(h);
 »···h->have_cache = true;
 »···mnl_genid_get(h, &genid_stop);

 »···if (genid_start != genid_stop) {
 »···»···flush_chain_cache(h, NULL);
 »···»···goto retry;
 »···}

 »···h->nft_genid = genid_start;
 }

It seems that "if (genid_start != genid_stop)" never is untrue, I get
 (gdb) p genid_stop
 $5 = 32767
 (gdb) p genid_start
 $6 = 3596142128
And those values never change.
I don't know how to handle this, but we could either detect through the loop
if both genid_* values don't change to fail with an error.
If so what would be the proper return value from here?

Since I don't exactly know how to trigger this scenario, but can run our
tests into it let me know if I should get some data from the test system.

This goes down
  mnl_genid_get
    -> mnl_talk
And there we see the socket calls that I have seen in strace.

In mll_talk it gets to this:

 ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
 while (ret > 0) {
 »···ret = mnl_cb_run(buf, ret, h->seq, h->portid, cb, data);
 »···if (ret <= 0)
 »···»···break;

Which first gets 40 back from the socket and then runs mnl_cb_run.
This returns -1; and due to that breaks.
That makes it return -1 and have no new generation id set.

IMHO in __nft_build_cache if mnl_genid_get returns -1 than things are broken
and we can not rely on the values it was supposed to place in
"uint32_t *genid".

The problem is that __nft_build_cache itself has no return value and we can't
set anything "smart" to its final action:
    1597 »···h->nft_genid = genid_start;

We could track if the genid's are "not changing" but that could in theory be
a valid case. The -1 instead clearly means something went wrong.
I was attaching gdb to a new iptables -N run and it immediately enters this
error condition.

(gdb) run -N ufw-caps-test2
  Starting program: /usr/sbin/iptables -N ufw-caps-test2
  Breakpoint 1, 0x000000010001e348 in __nft_build_cache (h=0x7fffffffed00)
  at nft.c:1582
  1582    {
  [...]
  (gdb) p genid_start
  $1 = 4294961248
  (gdb) p genid_stop
  [...]
  1592            if (genid_start != genid_stop) {
  (gdb) p genid_stop
  $3 = 32767
  (gdb) p genid_start
  $4 = 4294961248
  (gdb) n
  [...]
  (gdb) n
  1592            if (genid_start != genid_stop) {
  (gdb) p genid_start
  $5 = 4294961248
  (gdb) p genid_stop

So whatever happened to make the system respond that way it then is persistent.

There also is h->have_cache which is
a) a requirement to enter __nft_build_cache
b) something set to true after creation
We might want/need to unset this on the error condition and consumers check on
it before usage.

Users and their error conditions:
cache creation (just let them retry every time):
 - nft_rebuild_cache
 - nft_build_cache

cache usage:
 - nftnl_table_list_get -> ret NULL
 - nft_chain_list_get  -> ret NULL

The problem here is that this is just "better error handling" the error
persists and in this environment we won't be able to set up any cache maybe
even no chain at all.

I installed a version with my RFC fix applied and that at least got no
busy hang anymore.
What I found was that formerly (with the hang in -N) no rules got create at
all. Due to my fix for -N actually works, I now see them added (seen in nft).
But it seems that iptables -L tries to access the cache (which we know fails
to be created) and therefore goes into an error path.

  iptables v1.8.3 (nf_tables): table `filter' is incompatible, use 'nft' tool.

This message might not be perfect (or maybe it is and I don't realize).
But it made me check nft and if it knows anything about the rules that might
help.

With nft I see the current rules (maybe those are suspicious to you?).

$ sudo nft list ruleset
table ip mangle {
        chain PREROUTING {
                type filter hook prerouting priority mangle; policy accept;
        }

        chain INPUT {
                type filter hook input priority mangle; policy accept;
        }

        chain FORWARD {
                type filter hook forward priority mangle; policy accept;
                meta l4proto tcp tcp flags & (syn|rst) == syn counter packets
                     0 bytes 0 tcp option maxseg size set rt mtu
        }

        chain OUTPUT {
                type route hook output priority mangle; policy accept;
        }

        chain POSTROUTING {
                type filter hook postrouting priority mangle; policy accept;
        }
}

And with the fix iptables -N adds entries at the bottom like:
table ip filter {
        chain foo1 {
        }

        chain foo2 {
        }
}

This might be the "filter" that the error of "iptables -L" is referring to.
Flushing all rules with nft doesn't change anything in regard to the broken
situation.

I guess we need to find/understand the root cause as my patch just makes the
symptom "a bit less fatal". So far the system is up and running still and I
can debug/check whatever you need.

With more experience of the area or the codebas there might be a much better
solution. Due to that this is meant as RFC to get things going and I'm
reaching out to your expertise.

Christian Ehrhardt (1):
  nft: abort cache creation if mnl_genid_get fails

 iptables/nft.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.22.0

