Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAD7C77B61
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Apr 2023 13:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345984AbjD1NAT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Apr 2023 09:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjD1NAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2023 09:00:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93891FC3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2023 06:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5VSCmAqpGKx++y/CzHChoG5a0Rsy4wbS0ksi0QlKqNA=; b=JhbgLj3wNeklUYWEalxCI+BoZp
        jc4D5Bhiw4g7BsHgdTX1fFRnxy7bMe7KL5PqkaF+KIPzTrnZ/5DLDK914hOcrPI+P2H36fl8jKICp
        eSz6rsmPTzDUfJKJi2c5qeE5vchZRWFNP76KECFS3b3FYXfFaXmUEppXzHT0OEyKkWXsmgCP5i7Vi
        Idqqs4auewYAnmKsIjRXH/fjEq8B6sn//4tqMS0tBpnDPRGLoMReieP59NGYdy90eG6hOxWx44sz/
        7PkZY3ma8FVNlNXUJx4qVkbkZ0F0tiDI0qTfzFlCxOrMy9dZovhvLtbj5XIMDH71t8/y3Yvd5S/OX
        l44ImjeQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1psNhv-0001ze-1o
        for netfilter-devel@vger.kernel.org; Fri, 28 Apr 2023 15:00:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] xshared: Fix parsing of option arguments in same word
Date:   Fri, 28 Apr 2023 15:05:31 +0200
Message-Id: <20230428130531.14195-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428130531.14195-1-phil@nwl.cc>
References: <20230428130531.14195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When merging commandline parsers, a decision between 'argv[optind - 1]'
and 'optarg' had to be made in some spots. While the implementation of
check_inverse() required the former, use of the latter allows for the
common syntax of '--opt=arg' or even '-oarg' as 'optarg' will point at
the suffix while 'argv[optind - 1]' will just point at the following
option.

Fix the mess by making check_inverse() update optarg pointer if needed
so calling code may refer to and always correct 'optarg'.

Fixes: 0af80a91b0a98 ("nft: Merge xtables-arp-standalone.c into xtables-standalone.c")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1677
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_standard.t |  2 ++
 extensions/libxt_standard.t   |  3 ++
 iptables/xshared.c            | 61 +++++++++++++++++------------------
 3 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/extensions/libarpt_standard.t b/extensions/libarpt_standard.t
index e84a00b780488..007fa2b8335e8 100644
--- a/extensions/libarpt_standard.t
+++ b/extensions/libarpt_standard.t
@@ -12,3 +12,5 @@
 -i lo --destination-mac 11:22:33:44:55:66;-i lo --dst-mac 11:22:33:44:55:66;OK
 --source-mac Unicast;--src-mac 00:00:00:00:00:00/01:00:00:00:00:00;OK
 ! --src-mac Multicast;! --src-mac 01:00:00:00:00:00/01:00:00:00:00:00;OK
+--src-mac=01:02:03:04:05:06 --dst-mac=07:08:09:0A:0B:0C --h-length=6 --opcode=Request --h-type=Ethernet --proto-type=ipv4;--src-mac 01:02:03:04:05:06 --dst-mac 07:08:09:0a:0b:0c --opcode 1 --proto-type 0x800;OK
+--src-mac ! 01:02:03:04:05:06 --dst-mac ! 07:08:09:0A:0B:0C --h-length ! 6 --opcode ! Request --h-type ! Ethernet --proto-type ! ipv4;! --src-mac 01:02:03:04:05:06 ! --dst-mac 07:08:09:0a:0b:0c ! --h-length 6 ! --opcode 1 ! --h-type 1 ! --proto-type 0x800;OK
diff --git a/extensions/libxt_standard.t b/extensions/libxt_standard.t
index 56d6da2e5884e..6ed978e442b80 100644
--- a/extensions/libxt_standard.t
+++ b/extensions/libxt_standard.t
@@ -21,3 +21,6 @@
 -s 10.11.12.13/255.128.0.0;-s 10.0.0.0/9;OK
 -s 10.11.12.13/255.0.255.0;-s 10.0.12.0/255.0.255.0;OK
 -s 10.11.12.13/255.0.12.0;-s 10.0.12.0/255.0.12.0;OK
+:FORWARD
+--protocol=tcp --source=1.2.3.4 --destination=5.6.7.8/32 --in-interface=eth0 --out-interface=eth1 --jump=ACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
+-ptcp -s1.2.3.4 -d5.6.7.8/32 -ieth0 -oeth1 -jACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ac51fac5ce9ed..17aed04e02b09 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1318,7 +1318,7 @@ static void check_empty_interface(struct xtables_args *args, const char *arg)
 }
 
 static void check_inverse(struct xtables_args *args, const char option[],
-			  bool *invert, int *optidx, int argc)
+			  bool *invert, int argc, char **argv)
 {
 	switch (args->family) {
 	case NFPROTO_ARP:
@@ -1337,12 +1337,11 @@ static void check_inverse(struct xtables_args *args, const char option[],
 		xtables_error(PARAMETER_PROBLEM,
 			      "Multiple `!' flags not allowed");
 	*invert = true;
-	if (optidx) {
-		*optidx = *optidx + 1;
-		if (argc && *optidx > argc)
-			xtables_error(PARAMETER_PROBLEM,
-				      "no argument following `!'");
-	}
+	optind++;
+	if (optind > argc)
+		xtables_error(PARAMETER_PROBLEM, "no argument following `!'");
+
+	optarg = argv[optind - 1];
 }
 
 static const char *optstring_lookup(int family)
@@ -1555,16 +1554,16 @@ void do_parse(int argc, char *argv[],
 			 * Option selection
 			 */
 		case 'p':
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_PROTOCOL,
 				   &args->invflags, invert);
 
 			/* Canonicalize into lower case */
-			for (cs->protocol = argv[optind - 1];
+			for (cs->protocol = optarg;
 			     *cs->protocol; cs->protocol++)
 				*cs->protocol = tolower(*cs->protocol);
 
-			cs->protocol = argv[optind - 1];
+			cs->protocol = optarg;
 			args->proto = xtables_parse_protocol(cs->protocol);
 
 			if (args->proto == 0 &&
@@ -1578,17 +1577,17 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 's':
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_SOURCE,
 				   &args->invflags, invert);
-			args->shostnetworkmask = argv[optind - 1];
+			args->shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_DESTINATION,
 				   &args->invflags, invert);
-			args->dhostnetworkmask = argv[optind - 1];
+			args->dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
@@ -1601,71 +1600,71 @@ void do_parse(int argc, char *argv[],
 #endif
 
 		case 2:/* src-mac */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_S_MAC, &args->invflags,
 				   invert);
-			args->src_mac = argv[optind - 1];
+			args->src_mac = optarg;
 			break;
 
 		case 3:/* dst-mac */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_D_MAC, &args->invflags,
 				   invert);
-			args->dst_mac = argv[optind - 1];
+			args->dst_mac = optarg;
 			break;
 
 		case 'l':/* hardware length */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
 				   invert);
-			args->arp_hlen = argv[optind - 1];
+			args->arp_hlen = optarg;
 			break;
 
 		case 8: /* was never supported, not even in arptables-legacy */
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_OPCODE, &args->invflags,
 				   invert);
-			args->arp_opcode = argv[optind - 1];
+			args->arp_opcode = optarg;
 			break;
 
 		case 5:/* h-type */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
 				   invert);
-			args->arp_htype = argv[optind - 1];
+			args->arp_htype = optarg;
 			break;
 
 		case 6:/* proto-type */
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
 				   invert);
-			args->arp_ptype = argv[optind - 1];
+			args->arp_ptype = optarg;
 			break;
 
 		case 'j':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
 				   invert);
-			command_jump(cs, argv[optind - 1]);
+			command_jump(cs, optarg);
 			break;
 
 		case 'i':
 			check_empty_interface(args, optarg);
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
-			xtables_parse_interface(argv[optind - 1],
+			xtables_parse_interface(optarg,
 						args->iniface,
 						args->iniface_mask);
 			break;
 
 		case 'o':
 			check_empty_interface(args, optarg);
-			check_inverse(args, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, argc, argv);
 			set_option(&cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
-			xtables_parse_interface(argv[optind - 1],
+			xtables_parse_interface(optarg,
 						args->outiface,
 						args->outiface_mask);
 			break;
-- 
2.40.0

