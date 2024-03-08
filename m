Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF4F53377
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 09:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709889607; cv=none; b=Ap3mC9R+mcfLTVpZhEaQGojRE3SxQhCH91oSSUNzbxjTLUW3jok1X5kIDwFPhCJSELw78iyIgehPEvOWyPUIg+XlXNdE2FobG5JpvX4sCxyk65mNlB2RQQGZDj/p02jmS4CNN1wxWUJvyV6K6GHt+jEmbkpUeJ7Tn4AaZ1cqsSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709889607; c=relaxed/simple;
	bh=JSCvCMUToT6XqM2f8zZYnxnHnSPqnsUNX9bZTKmYQUA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=RBrq1Iep/TIZEARTUzHEg0iDhNfS+Q56rLHOQrCMmpoBQ+wcFnVWELicYYLFZa4b6AP9tpeIFUL2/32s3rD8IJPj+IXTlfaaL6mqazSNQH+BwUKfkxywWe0BLVVD9kK6ny4M3JVXlZg7oBl9A15VEBgYb5ycvdHinAJIXQcXzgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIaqfn3V; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIaqfn3V"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-690ae5ce241so5638826d6.2
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Mar 2024 01:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709889604; x=1710494404; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L8a4ipKazHTClO7Ju1zYKotgNrFHt2kS4nUAhqW0gsw=;
        b=CIaqfn3VyNBG1DW3jsk2jPmyvcOBZZ8BSwOnI2em2bnzovy3sW224yFPl1FaGnWTQC
         0g/01UWeIwYGE/jZHeT2IlBo6eu1uK/5v19lsiJ98YC5HolbeVaSBkQHt9fVFRyg2yi0
         JxJt4pG5a8WgI40645uNN4Z7FcYBC3HhvKKPBub5DkYHyDBw4sopwqwzpd373bRTfF2I
         tGtvIt6Bbvygw93IZoomvLvUpkm6IvfZxmS7gPHGpm2GI0YoqSNzdGg8wixRKLFGNdO2
         eQBSMtg8Mo+uVQhAZbxP0YMpoa4aVWu6glj7C0DBZfyg8xJME2t8h2FwOhK21jmyVcvn
         Y+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709889604; x=1710494404;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L8a4ipKazHTClO7Ju1zYKotgNrFHt2kS4nUAhqW0gsw=;
        b=AM0d85qUBClQ5C0Tb7Irg262lNKBkJgH0NPlSAmYj0XbJUGk9hu9Vk4PqPC4LE48Uc
         2g4XjXX/a14o5FQYtyvaRhQUZfbPG4+5F1rtogd04hahMJ+g77/n4acYoK39qkkqpOA9
         PE6+2K6M4j7TT+ezI1cDFyLyYS3wJMzvujyZh1CU1z7AWHxUzN6roKB7SaGtFG2kAp2L
         J8AJqaQT8allDnZMSOU3lax08fzPTS3L/fZwUEyzceoNHoqKYj0LaFoNzYqjksDQ13Ys
         S846tkqOKDcGUg0ZuYrJVvUgwZE35Q9TDg1yRDlPMHUM9KDi/HRpaYEGQNqHRUCVOQnY
         CD1Q==
X-Gm-Message-State: AOJu0YxImvUi+aAoM8iryluJDkFa1h7zYb9/e1N/7zFEYUu2pfpBe2oU
	ZdX8AG2oGLG2De9+v/OmmSZbtn5KV6r66a9ikM0qWWMCZfMM9s7IWg5786cpXZUqKVLxvFylZMf
	L7Nm7W+AbElCEPkyvaY13+VYyY5B7wgCP
X-Google-Smtp-Source: AGHT+IH2n5PnZIEVePAIZ3jDi/6PYijxT9brz6Tlrx8ckwwRb5rMdCOQlgTS8jt914HhLKz4gveCbqCL6m2gWufAD6s=
X-Received: by 2002:a05:6214:3288:b0:690:b098:1407 with SMTP id
 mu8-20020a056214328800b00690b0981407mr2793624qvb.3.1709889603957; Fri, 08 Mar
 2024 01:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Fri, 8 Mar 2024 14:49:38 +0530
Message-ID: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
Subject: iptables-nft: Wrong payload merge of rule filter - "! --sport xx !
 --dport xx"
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

iptables-nft based on nftables has an issue with the way the rule
filter - "! --sport xx ! --dport xx" is wrongly merged and rendered.

This experiment below demonstrates the issue  -

% ip -d addr show vm1; ip -d addr show vm2

203: vm1@vm2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000

    link/ether 2a:a2:43:13:94:d7 brd ff:ff:ff:ff:ff:ff promiscuity 0
minmtu 68 maxmtu 65535

    veth numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

    inet6 fe80::28a2:43ff:fe13:94d7/64 scope link

       valid_lft forever preferred_lft forever

202: vm2@vm1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000

    link/ether 9e:00:fa:a3:c9:48 brd ff:ff:ff:ff:ff:ff promiscuity 1
minmtu 68 maxmtu 65535

    veth numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

    inet 2.2.2.2/32 scope global vm2

       valid_lft forever preferred_lft forever

    inet6 fe80::9c00:faff:fea3:c948/64 scope link

       valid_lft forever preferred_lft forever

% export IPTABLES=/usr/sbin/iptables-nft; sudo $IPTABLES -A INPUT -p
tcp ! --sport 22 ! --dport 22 -i vm2; echo -e "\n---- Before data
----\n"; sudo $IPTABLES -L INPUT -vvvn; sudo python -c "from scapy.all
import *; sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
dst='2.2.2.2')/TCP(sport=23, dport=22), iface='vm1')"; echo -e "\n----
After data with either one of tcp sport/dport being 22 ----\n"; sudo
$IPTABLES -L INPUT -vn; sudo python -c "from scapy.all import *;
sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
dst='2.2.2.2')/TCP(sport=23, dport=23), iface='vm1')"; echo -e "\n----
After data with neither one of tcp sport/dport being 22 ----\n"; sudo
$IPTABLES -L INPUT -vn; sudo $IPTABLES -D INPUT -p tcp ! --sport 22 !
--dport 22 -i vm2

---- Before data ----

ip filter INPUT 39
  [ meta load iifname => reg 1 ]
  [ cmp eq reg 1 0x00326d76 ]
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ transport header + 0 => reg 1 ]
  [ cmp neq reg 1 0x16001600 ]
  [ counter pkts 0 bytes 0 ]


Chain INPUT (policy ACCEPT 0 packets, 0 bytes)

 pkts bytes target     prot opt in     out     source               destination

    0     0            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22


---- After data with either one of tcp sport/dport being 22 ----

# Warning: iptables-legacy tables present, use iptables-legacy to see them

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)

 pkts bytes target     prot opt in     out     source               destination

    1    46            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22


---- After data with neither one of tcp sport/dport being 22 ----

# Warning: iptables-legacy tables present, use iptables-legacy to see them

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)

 pkts bytes target     prot opt in     out     source               destination

    2    92            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22


% export IPTABLES=/usr/local/sbin/iptables-legacy; sudo $IPTABLES -A
INPUT -p tcp ! --sport 22 ! --dport 22 -i vm2; echo -e "\n---- Before
data ----\n"; sudo $IPTABLES -L INPUT -vvvn; sudo python -c "from
scapy.all import *;
sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
dst='2.2.2.2')/TCP(sport=23, dport=22), iface='vm1')"; echo -e "\n----
After data with either one of tcp sport/dport being 22 ----\n"; sudo
$IPTABLES -L INPUT -vn; sudo python -c "from scapy.all import *;
sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
dst='2.2.2.2')/TCP(sport=23, dport=23), iface='vm1')"; echo -e "\n----
After data with neither one of tcp sport/dport being 22 ----\n"; sudo
$IPTABLES -L INPUT -vn; sudo $IPTABLES -D INPUT -p tcp ! --sport 22 !
--dport 22 -i vm2


---- Before data ----

ip filter INPUT 41
  [ meta load iifname => reg 1 ]
  [ cmp eq reg 1 0x00326d76 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 0 => reg 1 ]
  [ cmp neq reg 1 0x00001600 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp neq reg 1 0x00001600 ]
  [ counter pkts 0 bytes 0 ]


Chain INPUT (policy ACCEPT 13824 packets, 994K bytes)

 pkts bytes target     prot opt in     out     source               destination

    0     0            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22


---- After data with either one of tcp sport/dport being 22 ----

Chain INPUT (policy ACCEPT 13827 packets, 994K bytes)

 pkts bytes target     prot opt in     out     source               destination

    0     0            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22


---- After data with neither one of tcp sport/dport being 22 ----

Chain INPUT (policy ACCEPT 13831 packets, 994K bytes)

 pkts bytes target     prot opt in     out     source               destination

    1    46            tcp  --  vm2    *       0.0.0.0/0
0.0.0.0/0            tcp spt:!22 dpt:!22

With iptables-nft the logical AND of sport neq and dport neq is
resulting the payload getting merged incorrectly -


  [ payload load 4b @ transport header + 0 => reg 1 ]
  [ cmp neq reg 1 0x16001600 ]


v/s

With iptables-legacy the logical AND of sport neq and dport neq is
resulting in using separate payload matches correctly -

  [ payload load 2b @ transport header + 0 => reg 1 ]
  [ cmp neq reg 1 0x00001600 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp neq reg 1 0x00001600 ]

The iptables-nft has the issue where either one of tcp sport/dport
being 22 still matches the iptables rule - "tcp ! --sport 22 ! --dport
22" while it should not have matched, whereas with the
iptables-legacy, the packet with either one of tcp sport/dport being
22 does not match the iptables rule - "tcp ! --sport 22 ! --dport 22".


The below patch to iptables-nft fixes this issue -

Author: Sriram Rajagopalan <bglsriram@gmail.com>
Date:   Fri Mar 07 20:09:38 2024 -0800

iptables: Fixed the issue with combining the payload in case of invert
filter for tcp src and dst ports

Signed-off-by: Sriram Rajagopalan <bglsriram@gmail.com>
Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>

diff --git a/iptables/nft.c b/iptables/nft.c

index dae6698d..38227d51 100644

--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1307,14 +1307,12 @@ static int add_nft_tcpudp(struct nft_handle
*h,struct nftnl_rule *r,
        uint8_t reg;
        int ret;

-       if (src[0] && src[0] == src[1] &&
+       if (!invert_src &&
+           src[0] && src[0] == src[1] &&
            dst[0] && dst[0] == dst[1] &&
            invert_src == invert_dst) {
                uint32_t combined = dst[0] | (src[0] << 16);

-               if (invert_src)
-                       op = NFT_CMP_NEQ;
-
                expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, 4, &reg);
                if (!expr)
                        return -ENOMEM;

This issue is also present with the nft
tool(https://git.netfilter.org/nftables/) as well and the below patch
fixes the issue with the nft tool -

Author: Sriram Rajagopalan <bglsriram@gmail.com>
Date:   Fri Mar 08 10:06:30 2024 -0800

nftables: Fixed the issue with merging the payload in case of invert
filter for tcp src and dst ports

Signed-off-by: Sriram Rajagopalan <bglsriram@gmail.com>
Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>

diff --git a/src/rule.c b/src/rule.c
index 342c43fb..5def185d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2661,8 +2661,13 @@ static void payload_do_merge(struct stmt *sa[],
unsigned int n)
        for (j = 0, i = 1; i < n; i++) {
                stmt = sa[i];
                this = stmt->expr;
-
-               if (!payload_can_merge(last->left, this->left) ||
+               /* We should not be merging two OP_NEQs. For example -
+                * tcp sport != 22 tcp dport != 23 should not result in
+                * [ payload load 4b @ transport header + 0 => reg 1 ]
+                * [ cmp neq reg 1 0x17001600 ]
+                */
+               if (this->op == OP_NEQ ||
+                   !payload_can_merge(last->left, this->left) ||
                    !relational_ops_match(last, this)) {
                        last = this;
                        j = i;

Please review the patches above and provide your feedback. Please let
me know of any questions/clarifications.

Thanks,
Sriram
