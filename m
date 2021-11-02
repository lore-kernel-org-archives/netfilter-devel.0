Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828A5C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 14:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF90610CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 14:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhKBOfV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:35:21 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40603 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBOfU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 10:35:20 -0400
Received: by mail-wr1-f42.google.com with SMTP id r8so20808024wra.7
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Nov 2021 07:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=5L/TCvadw1+881z0MMyXKqMsE6aNRiUj21c7qZYhZFs=;
        b=ONydZJvS8+Trs14qJoWz9wWwZJ347oxHiRSCQrTLf+fkhB1XkxeiP9ut5Hg0X7o/If
         x2cwjOesRxKKJOtENcg5jVnLIsbatUIKvXMRJqdcYf+J2F1rwxMNfLgSNIAs/ppv+6wy
         ioEmu/q3bFMCKx7isQv8alp9pqVdaKCLrlSqL46jiAfKscKIFOF+qPI1iBlfAKGlkiT8
         VdS5rV59+PuGmePmvsFV2F4y1SxqN8JirMLv/FfO0JeEnoQ/EMewacaX0rGw5vbjezkS
         loldnjFBa8lR63j2NudnkqcFQQmB+zLzl+/ZyxPc9R0wuoe3yUc59PcVSJJsrsPGLurw
         QwyA==
X-Gm-Message-State: AOAM531fT36EIJY7Eola6YE0J8cqVTI6iPEy82lhX7b2snMlbAT2pw8m
        Hc0p3qs2ikArIcu/ayySKf8chOZoYMo=
X-Google-Smtp-Source: ABdhPJz5BxFKRxP9dS/ar69ARLfIggkzGw/fWFtMbYVccLZYTlBJ4xNQcGB0rYV6IDakgntWjBNeHA==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr38490333wrm.406.1635863564957;
        Tue, 02 Nov 2021 07:32:44 -0700 (PDT)
Received: from [192.168.1.130] ([213.194.129.197])
        by smtp.gmail.com with ESMTPSA id v5sm2622906wmh.37.2021.11.02.07.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 07:32:43 -0700 (PDT)
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Potential problem with VRF+conntrack after kernel upgrade
Message-ID: <1a816689-3960-eb6b-2256-9478265d2d8e@netfilter.org>
Date:   Tue, 2 Nov 2021 15:32:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9DFE971FCDE217CB51B6AA88"
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------9DFE971FCDE217CB51B6AA88
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi there!

We experienced a major network outage today when upgrading kernels.

The affected servers run the VRF+conntrack+nftables combo. They are edge 
firewalls/NAT boxes, meaning most interesting traffic is not locally generated, 
but forwarded.

What we experienced is NATed traffic in the reply direction never being 
forwarded back to the original client.

Good kernel: 5.10.40 (debian 5.10.0-0.bpo.7-amd64)
Bad kernel: 5.10.70 (debian 5.10.0-0.bpo.9-amd64)

I suspect the problem may be related to this patch: 
https://x-lore.kernel.org/stable/20210824165908.709932-58-sashal@kernel.org/

Would it be possible to confirm the offending change, and to get some advice on 
how to workaround the problem? I could run more tests and give additional 
information on demand.

Some bits of our configuration follows. The setup is rather simple, two 
interfaces, one pointing to the internet (eno2.2120) and the other to the 
internal network (eno2.2107). Both interfaces are attached to a VRF device 
'vrf-cloudgw'. The VRF is used to isolate forwarded traffic from the host 
network (eno1). The nftables firewall is also split: a table 'basefirewall' for 
input/output chains, a table 'cloudgw' for forwarded traffic, to perform NAT.


Interfaces setup:

=== 8< ===
user@cloudgw2002-dev:~ $ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group 
default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
     inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
     inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group 
default qlen 1000
     link/ether 2c:ea:7f:7b:e1:04 brd ff:ff:ff:ff:ff:ff
     inet 10.192.20.18/24 brd 10.192.20.255 scope global eno1
        valid_lft forever preferred_lft forever
     inet6 2620:0:860:118:10:192:20:18/64 scope global
        valid_lft 2591995sec preferred_lft 604795sec
     inet6 fe80::2eea:7fff:fe7b:e104/64 scope link
        valid_lft forever preferred_lft forever
3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group 
default qlen 1000
     link/ether 2c:ea:7f:7b:e1:05 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::2eea:7fff:fe7b:e105/64 scope link
        valid_lft forever preferred_lft forever
4: vrf-cloudgw: <NOARP,MASTER,UP,LOWER_UP> mtu 65575 qdisc noqueue state UP 
group default qlen 1000
     link/ether 1e:04:99:69:3e:56 brd ff:ff:ff:ff:ff:ff
5: eno2.2107@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue 
master vrf-cloudgw state UP group default qlen 1000
     link/ether 2c:ea:7f:7b:e1:05 brd ff:ff:ff:ff:ff:ff
     inet 185.15.57.9/30 scope global eno2.2107
        valid_lft forever preferred_lft forever
     inet6 fe80::2eea:7fff:fe7b:e105/64 scope link
        valid_lft forever preferred_lft forever
6: eno2.2120@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue 
master vrf-cloudgw state UP group default qlen 1000
     link/ether 2c:ea:7f:7b:e1:05 brd ff:ff:ff:ff:ff:ff
     inet 208.80.153.189/29 brd 208.80.153.191 scope global eno2.2120
        valid_lft forever preferred_lft forever
     inet 208.80.153.190/29 scope global secondary eno2.2120
        valid_lft forever preferred_lft forever
     inet6 fe80::2eea:7fff:fe7b:e105/64 scope link
        valid_lft forever preferred_lft forever
=== 8< ===

VRF routing table:

=== 8< ===
user@cloudgw2002-dev:~ $ ip route list vrf vrf-cloudgw
default via 208.80.153.185 dev eno2.2120 onlink
172.16.128.0/24 via 185.15.57.10 dev eno2.2107 proto 112 onlink
185.15.57.0/29 via 185.15.57.10 dev eno2.2107 proto 112 onlink
185.15.57.8/30 dev eno2.2107 proto kernel scope link src 185.15.57.9
208.80.153.184/29 dev eno2.2120 proto kernel scope link src 208.80.153.189
=== 8< ===

Find attached nftables ruleset.

--------------9DFE971FCDE217CB51B6AA88
Content-Type: text/plain; charset=UTF-8;
 name="ruleset.nft"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ruleset.nft"

dGFibGUgaW5ldCBiYXNlZmlyZXdhbGwgewoJc2V0IG1vbml0b3JpbmdfaXB2NCB7CgkJdHlw
ZSBpcHY0X2FkZHIKCQllbGVtZW50cyA9IHsgMjA4LjgwLjE1My44NCwgMjA4LjgwLjE1NC44
OCB9Cgl9CgoJc2V0IG1vbml0b3JpbmdfaXB2NiB7CgkJdHlwZSBpcHY2X2FkZHIKCQllbGVt
ZW50cyA9IHsgMjYyMDowOjg2MDozOjIwODo4MDoxNTM6ODQsCgkJCSAgICAgMjYyMDowOjg2
MTozOjIwODo4MDoxNTQ6ODggfQoJfQoKCXNldCBzc2hfYWxsb3dlZF9pcHY0IHsKCQl0eXBl
IGlwdjRfYWRkcgoJCWVsZW1lbnRzID0geyAxMC42NC4zMi4yNSwgMTAuMTkyLjMyLjQ5LAoJ
CQkgICAgIDEwLjE5Mi40OC4xNiwgOTEuMTk4LjE3NC42LAoJCQkgICAgIDEwMy4xMDIuMTY2
LjYsIDE5OC4zNS4yNi4xMywKCQkJICAgICAyMDguODAuMTUzLjU0LCAyMDguODAuMTU1LjEx
MCB9Cgl9CgoJc2V0IHNzaF9hbGxvd2VkX2lwdjYgewoJCXR5cGUgaXB2Nl9hZGRyCgkJZWxl
bWVudHMgPSB7IDIwMDE6ZGYyOmU1MDA6MToxMDM6MTAyOjE2Njo2LAoJCQkgICAgIDI2MjA6
MDo4NjA6MjoyMDg6ODA6MTUzOjU0LAoJCQkgICAgIDI2MjA6MDo4NjA6MTAzOjEwOjE5Mjoz
Mjo0OSwKCQkJICAgICAyNjIwOjA6ODYwOjEwNDoxMDoxOTI6NDg6MTYsCgkJCSAgICAgMjYy
MDowOjg2MTo0OjIwODo4MDoxNTU6MTEwLAoJCQkgICAgIDI2MjA6MDo4NjE6MTAzOjEwOjY0
OjMyOjI1LAoJCQkgICAgIDI2MjA6MDo4NjI6MTo5MToxOTg6MTc0OjYsCgkJCSAgICAgMjYy
MDowOjg2MzoxOjE5ODozNToyNjoxMyB9Cgl9CgoJc2V0IHByb21ldGhldXNfbm9kZXNfaXB2
NCB7CgkJdHlwZSBpcHY0X2FkZHIKCQllbGVtZW50cyA9IHsgMTAuMTkyLjAuMTQ1LCAxMC4x
OTIuMTYuMTg5IH0KCX0KCglzZXQgcHJvbWV0aGV1c19ub2Rlc19pcHY2IHsKCQl0eXBlIGlw
djZfYWRkcgoJCWVsZW1lbnRzID0geyAyNjIwOjA6ODYwOjEwMToxMDoxOTI6MDoxNDUsCgkJ
CSAgICAgMjYyMDowOjg2MDoxMDI6MTA6MTkyOjE2OjE4OSB9Cgl9CgoJc2V0IHByb21ldGhl
dXNfcG9ydHMgewoJCXR5cGUgaW5ldF9zZXJ2aWNlCgkJZWxlbWVudHMgPSB7IDkxMDAsIDkx
MDUsIDk3MTAgfQoJfQoKCWNoYWluIGlucHV0IHsKCQl0eXBlIGZpbHRlciBob29rIGlucHV0
IHByaW9yaXR5IGZpbHRlcjsgcG9saWN5IGRyb3A7CgkJY3Qgc3RhdGUgZXN0YWJsaXNoZWQs
cmVsYXRlZCBhY2NlcHQKCQlpaWZuYW1lICJsbyIgYWNjZXB0CgkJbWV0YSBwa3R0eXBlIG11
bHRpY2FzdCBhY2NlcHQKCQltZXRhIGw0cHJvdG8gaXB2Ni1pY21wIGFjY2VwdAoJCWlwIHBy
b3RvY29sIGljbXAgYWNjZXB0CgkJaXAgc2FkZHIgQG1vbml0b3JpbmdfaXB2NCBjdCBzdGF0
ZSBuZXcgYWNjZXB0CgkJaXA2IHNhZGRyIEBtb25pdG9yaW5nX2lwdjYgY3Qgc3RhdGUgbmV3
IGFjY2VwdAoJCWlwIHNhZGRyIEBzc2hfYWxsb3dlZF9pcHY0IHRjcCBkcG9ydCAyMiBjdCBz
dGF0ZSBuZXcgY291bnRlciBwYWNrZXRzIDEgYnl0ZXMgNjAgYWNjZXB0CgkJaXA2IHNhZGRy
IEBzc2hfYWxsb3dlZF9pcHY2IHRjcCBkcG9ydCAyMiBjdCBzdGF0ZSBuZXcgY291bnRlciBw
YWNrZXRzIDYgYnl0ZXMgNDgwIGFjY2VwdAoJCWlwIHNhZGRyIEBwcm9tZXRoZXVzX25vZGVz
X2lwdjQgdGNwIGRwb3J0IEBwcm9tZXRoZXVzX3BvcnRzIGN0IHN0YXRlIG5ldyBjb3VudGVy
IHBhY2tldHMgNDIxIGJ5dGVzIDI1MjYwIGFjY2VwdAoJCWlwNiBzYWRkciBAcHJvbWV0aGV1
c19ub2Rlc19pcHY2IHRjcCBkcG9ydCBAcHJvbWV0aGV1c19wb3J0cyBjdCBzdGF0ZSBuZXcg
Y291bnRlciBwYWNrZXRzIDQyMiBieXRlcyAzMzc2MCBhY2NlcHQKCQlpcCBzYWRkciAxMC4x
OTIuMjAuMTggdGNwIGRwb3J0IDM3ODAgY3Qgc3RhdGUgbmV3IGFjY2VwdAoJCWNvdW50ZXIg
cGFja2V0cyAxMjEzIGJ5dGVzIDY4NDYwIGNvbW1lbnQgImNvdW50ZXIgZHJvcHBlZCBwYWNr
ZXRzIgoJfQoKCWNoYWluIG91dHB1dCB7CgkJdHlwZSBmaWx0ZXIgaG9vayBvdXRwdXQgcHJp
b3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNjZXB0OwoJCWNvdW50ZXIgcGFja2V0cyA2Nzk0MCBi
eXRlcyAzODg0Mjk5NSBjb21tZW50ICJjb250ZXIgYWNjZXB0ZWQgcGFja2V0cyIKCX0KfQp0
YWJsZSBpbmV0IGNsb3VkZ3cgewoJc2V0IGRtel9jaWRyX3NldCB7CgkJdHlwZSBpcHY0X2Fk
ZHIKCQljb3VudGVyCgkJZWxlbWVudHMgPSB7IDEwLjY0LjQuMTUgY291bnRlciBwYWNrZXRz
IDAgYnl0ZXMgMCwgMTAuNjQuMzcuMTMgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwKCQkJ
ICAgICAxMC42NC4zNy4xOCBjb3VudGVyIHBhY2tldHMgMCBieXRlcyAwLCA5MS4xOTguMTc0
LjE5MiBjb3VudGVyIHBhY2tldHMgMCBieXRlcyAwLAoJCQkgICAgIDkxLjE5OC4xNzQuMjA4
IGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsIDEwMy4xMDIuMTY2LjIyNCBjb3VudGVyIHBh
Y2tldHMgMCBieXRlcyAwLAoJCQkgICAgIDEwMy4xMDIuMTY2LjI0MCBjb3VudGVyIHBhY2tl
dHMgMCBieXRlcyAwLCAxOTguMzUuMjYuOTYgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwK
CQkJICAgICAxOTguMzUuMjYuMTEyIGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsIDIwOC44
MC4xNTMuMTUgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwKCQkJICAgICAyMDguODAuMTUz
LjQyIGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsIDIwOC44MC4xNTMuNTkgY291bnRlciBw
YWNrZXRzIDAgYnl0ZXMgMCwKCQkJICAgICAyMDguODAuMTUzLjc1IGNvdW50ZXIgcGFja2V0
cyAwIGJ5dGVzIDAsIDIwOC44MC4xNTMuNzggY291bnRlciBwYWNrZXRzIDIxMDggYnl0ZXMg
MjMxNTU1LAoJCQkgICAgIDIwOC44MC4xNTMuMTA3IGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVz
IDAsIDIwOC44MC4xNTMuMTE2IGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsCgkJCSAgICAg
MjA4LjgwLjE1My4xMTggY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwgMjA4LjgwLjE1My4y
MjQgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwKCQkJICAgICAyMDguODAuMTUzLjI0MCBj
b3VudGVyIHBhY2tldHMgMCBieXRlcyAwLCAyMDguODAuMTUzLjI1MiBjb3VudGVyIHBhY2tl
dHMgMCBieXRlcyAwLAoJCQkgICAgIDIwOC44MC4xNTQuMTUgY291bnRlciBwYWNrZXRzIDAg
Ynl0ZXMgMCwgMjA4LjgwLjE1NC4yMyBjb3VudGVyIHBhY2tldHMgMCBieXRlcyAwLAoJCQkg
ICAgIDIwOC44MC4xNTQuMjQgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwgMjA4LjgwLjE1
NC4zMCBjb3VudGVyIHBhY2tldHMgMCBieXRlcyAwLAoJCQkgICAgIDIwOC44MC4xNTQuODUg
Y291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwgMjA4LjgwLjE1NC4xMzIgY291bnRlciBwYWNr
ZXRzIDAgYnl0ZXMgMCwKCQkJICAgICAyMDguODAuMTU0LjEzNyBjb3VudGVyIHBhY2tldHMg
MCBieXRlcyAwLCAyMDguODAuMTU0LjE0MyBjb3VudGVyIHBhY2tldHMgMCBieXRlcyAwLAoJ
CQkgICAgIDIwOC44MC4xNTQuMjI0IGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsIDIwOC44
MC4xNTQuMjQwIGNvdW50ZXIgcGFja2V0cyAwIGJ5dGVzIDAsCgkJCSAgICAgMjA4LjgwLjE1
NC4yNTIgY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCwgMjA4LjgwLjE1NS4xMTkgY291bnRl
ciBwYWNrZXRzIDAgYnl0ZXMgMCwKCQkJICAgICAyMDguODAuMTU1LjEyNSBjb3VudGVyIHBh
Y2tldHMgMCBieXRlcyAwLCAyMDguODAuMTU1LjEyNiBjb3VudGVyIHBhY2tldHMgMCBieXRl
cyAwIH0KCX0KCgljaGFpbiBwcmVyb3V0aW5nIHsKCQl0eXBlIG5hdCBob29rIHByZXJvdXRp
bmcgcHJpb3JpdHkgZHN0bmF0OyBwb2xpY3kgYWNjZXB0OwoJfQoKCWNoYWluIHBvc3Ryb3V0
aW5nIHsKCQl0eXBlIG5hdCBob29rIHBvc3Ryb3V0aW5nIHByaW9yaXR5IHNyY25hdDsgcG9s
aWN5IGFjY2VwdDsKCQlvaWZuYW1lICE9ICJlbm8yLjIxMjAiIGNvdW50ZXIgcGFja2V0cyA2
MjkgYnl0ZXMgNDI5MjkgYWNjZXB0CgkJaXAgc2FkZHIgIT0gMTcyLjE2LjEyOC4wLzI0IGNv
dW50ZXIgcGFja2V0cyA1MzYgYnl0ZXMgNTgyNDggYWNjZXB0CgkJaXAgZGFkZHIgQGRtel9j
aWRyX3NldCBjb3VudGVyIHBhY2tldHMgMjEwOCBieXRlcyAyMzE1NTUgYWNjZXB0IGNvbW1l
bnQgImRtel9jaWRyIgoJCWNvdW50ZXIgcGFja2V0cyAxMiBieXRlcyA3MjAgc25hdCBpcCB0
byAxODUuMTUuNTcuMSBjb21tZW50ICJyb3V0aW5nX3NvdXJjZV9pcCIKCX0KCgljaGFpbiBm
b3J3YXJkIHsKCQl0eXBlIGZpbHRlciBob29rIGZvcndhcmQgcHJpb3JpdHkgZmlsdGVyOyBw
b2xpY3kgZHJvcDsKCQlpaWZuYW1lICJ2cmYtY2xvdWRndyIgb2lmbmFtZSB7ICJlbm8yLjIx
MjAiLCAiZW5vMi4yMTA3IiB9IGNvdW50ZXIgcGFja2V0cyA2OTk0IGJ5dGVzIDExNzE5MTEg
YWNjZXB0CgkJY291bnRlciBwYWNrZXRzIDAgYnl0ZXMgMCBjb21tZW50ICJjb3VudGVyIGRy
b3BwZWQgcGFja2V0cyIKCX0KfQo=
--------------9DFE971FCDE217CB51B6AA88--
