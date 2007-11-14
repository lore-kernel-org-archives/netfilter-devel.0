From: Luca Tettamanti <kronos.it@gmail.com>
Subject: [2.6.24][BUG] Compact code broken?
Date: Wed, 14 Nov 2007 22:28:55 +0100
Message-ID: <20071114212855.GA580@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Cc: coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.235]:61459 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbXKNV2y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:28:54 -0500
Received: by hu-out-0506.google.com with SMTP id 19so2885458hue
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Nov 2007 13:28:51 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
I'm testing a 64bit kernel on my machine and I've found an issue with
iptables (32 bit). Kernel is git current (9418d5dc).

I'm unable to add any rule to the filter table, with kernel returning
EFAULT:

socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\377@\212r\200\377\377\377\3778 \230)\0\201\377"..., [84]) = 0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [656]) = 0
setsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 860) = -1 EFAULT (Bad address)
write(2, "iptables: Bad address\n", 22) = 22

With a bit of printk I've tracked it to the first copy_from_user in
compat_do_replace:

compat_do_replace:1859: user = ffffffff883cc370, len = 860
compat_do_replace:1864: copy_from_user = 92

Userspace reports:

iptc_init: valid_hooks=0x0000000e, num_entries=4, size=620
cache_add_entry: entering...0:0 new builtin chain: 0x8055910 (rules=0x8055960)
0:0 normal rule: 0x8055980: standard, verdict=-2
cache_add_entry: entering...1:148 new builtin chain: 0x8055a40 (rules=0x8055a90)
iptcc_delete_rule: deleting rule 0x8055980 (offset 0)
1:148 normal rule: 0x8055980: standard, verdict=-2
cache_add_entry: entering...2:296 new builtin chain: 0x8055ab0 (rules=0x8055b00)
iptcc_delete_rule: deleting rule 0x8055980 (offset 148)
2:296 normal rule: 0x8055980: standard, verdict=-2
cache_add_entry: entering...3:444: end of table:
iptcc_delete_rule: deleting rule 0x8055980 (offset 296)
iptcc_compile_chain_offsets: INPUT: chain_head 0, offset=0
iptcc_compile_chain_offsets: rule 0, offset=0, index=0
iptcc_compile_chain_offsets: INPUT; chain_foot 1, offset=148, index=1
iptcc_compile_chain_offsets: FORWARD: chain_head 2, offset=296
iptcc_compile_chain_offsets: FORWARD; chain_foot 2, offset=296, index=2
iptcc_compile_chain_offsets: OUTPUT: chain_head 3, offset=444
iptcc_compile_chain_offsets: OUTPUT; chain_foot 3, offset=444, index=3
iptc_commit: num_entries=5, size=768, num_counters=4
iptc_commit: repl=0x8055be0 <--- this is the argument of setsockopt
iptables: Bad address

I'm also attaching the 2 blobs created by iptables.

The test command was:
iptables -A INPUT -s 123.123.123.132 -i eth0 -j DROP

32 bit userspace with 32 kernel works fine; I'm unable to test with 64
bit userspace (it would require a big surgery on my existing 32 bit
installation).

Luca
-- 
"In linea di principio sarei indifferente al natale, se solo il natale
 ricambiasse la cortesia e mi lasciasse in pace." -- Marco d'Itri

--y0ulUmNC+osPPQO6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="blobs.tar.gz"
Content-Transfer-Encoding: base64

H4sICHxnO0cCA2Jsb2JzLnRhcgDt1btKxEAUBuCz6sJiYWlhlULEwkvuNhY21i7prJbNMmog
mJCMVRoLQR9gH8TGztIH8Fl8gI2T7EogZqJCNhvh/yBM5kwuhwT+8T3XC/nkMA5G14yP2C2P
PBYfuX7gUlNUwTTNfBTKo6brKmnqiWbbtmHoBqmapVoaKSq14C7m40hRKAoCXnfdT+v/1JXn
cxbJ1/215b07pClljz/ens/3Xg7ycXex/v52+pQK5ftmFbUme9qoqK+6p4EYNxff6fFjpwM9
PVfWz+jccS4cGkp6mq9CV/hF/sci/yMW+uMJaz7/7Zr8twzzW/6byP9O5P+WOPrZyXpR2+8R
vfaK+bRUy/Lz/rI/SJLkIZt/5QDjN7W/NE1/F1hh/kZ5Rtc9f5kZTTV7mcyshZ7++p3a6Em2
l62mp/q9TAZ7GQAAAAAAAAAAAAAAAAB0yScjikJkACgAAA==

--y0ulUmNC+osPPQO6--
