From: Florian Westphal <fw@strlen.de>
Subject: Re: .config for iptables icmp rule delete failure
Date: Mon, 8 May 2017 22:22:36 +0200
Message-ID: <20170508202236.GC9660@breakpoint.cc>
References: <20170507204306.GW25861@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fwestpha@redhat.com, netfilter-devel@vger.kernel.org,
        pmoore@redhat.com, pvrabec@redhat.com, willemb@google.com
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41138 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752594AbdEHUXD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 16:23:03 -0400
Content-Disposition: inline
In-Reply-To: <20170507204306.GW25861@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Guy Briggs <rgb@redhat.com> wrote:

[ CC'ing Willem ]

> (Summary of IRC conversation for background...)
> Paul Moore and I hit what appears to be a bug since f25's 4.10.11 and
> upstream's 4.11-rc3 that would fail to locate on deletion an icmp rule
> in iptables.  Paul narrowed it down to the icmp option.
> Here's our issue where it came up: 
> 	https://github.com/linux-audit/audit-testsuite/pull/43#issuecomment-296831880
> 
> The test case is:
> # iptables -t mangle -I INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
> # iptables -t mangle -D INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
> The error we're getting is "iptables: No chain/target/match by that name."

This is a iptables (yes, userspace) bug exposed with
f77bc5b23fb1af51fc0faa8a479dea8969eb5079
(iptables: use match, target and data copy_to_user helpers)

icmp is 4 byte in size, but for some silly(?) reason userspace size
in iptables userland is set as XT_ALIGN(sizeof(ipt_icmp), so userspace
thinks its 8.

In 4.10, kernel copied the full kernel blob to userspace, and since
its allocated with kz/vzalloc the 4 padding bytes are 0.

libiptc uses malloc, so in case that contains garbage bytes the
memcmp() used to figure out if we found the correct rule in libiptc
during -D mode returns false because it chokes on the extra padding
after struct ipt_icmp match :-/

Simples fix is to use calloc/memset to 0 in libiptc, but we can't
go with userspace-only fix ...

So we have to fix this in the kernel and have xt_data_to_user()
zero out any padding as well.

Willem, if you don't have time to fix this let me know and i'll
try to work on this tomorrow.

For testing, this iptables patch makes things barf reliably regardless what
malloc/libc is doing:

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 2c66d04..9497a5e 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1286,6 +1286,7 @@ alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
        if (!h->entries)
                goto out_free_handle;
 
+       memset(h->entries, 0x42, sizeof(STRUCT_GET_ENTRIES) + size);
        strcpy(h->entries->name, tablename);
        h->entries->size = size;

iptables -A INPUT -p icmp --icmp-type 1 &&
iptables -D INPUT -p icmp --icmp-type 1

Works on 4.10, but not >= 4.11 (assumes x86_64 kernel+userland).
