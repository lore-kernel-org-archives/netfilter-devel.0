From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables] testing at sparc
Date: Wed, 2 Apr 2014 18:23:03 +0200
Message-ID: <CAOkSjBjhsQ7wS4_0YMrcV0Mm5yKOSVh8rn+sg3JK5zTH2qhYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:41044 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbaDBQX0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:23:26 -0400
Received: by mail-la0-f47.google.com with SMTP id pn19so364422lab.34
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Apr 2014 09:23:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there!

I've been testing nftables at sparc, looking for endianess issues.
Unfortunately, weird things happened.

Adding some rule:

% nft add table filter
% nft add chain filter input
% nft add rule filter input tcp dport 22 counter
% nft list table filter
table ip filter {
  chain input {
    payload @th,16,16 0x0 [invalid type] counter packets 0 bytes 0
  }
}

However, matching happened when I generated some traffic.

Also, compiling the nft cli tool:

% make
-e   SUBDIR src/
-e   LEX src/scanner.l
-e   DEP src/scanner.c
-e   YACC src/parser.y
-e   DEP src/parser.c
-e   DEP src/mnl.c
-e   DEP src/erec.c
-e   DEP src/utils.c
-e   DEP src/gmputil.c
-e   DEP src/rbtree.c
-e   DEP src/segtree.c
-e   DEP src/netlink_delinearize.c
-e   DEP src/netlink_linearize.c
-e   DEP src/netlink.c
-e   DEP src/ct.c
-e   DEP src/meta.c
-e   DEP src/exthdr.c
-e   DEP src/payload.c
-e   DEP src/proto.c
-e   DEP src/evaluate.c
-e   DEP src/expression.c
-e   DEP src/datatype.c
-e   DEP src/statement.c
-e   DEP src/rule.c
-e   DEP src/cli.c
-e   DEP src/main.c
-e   LEX src/scanner.l
-e   DEP src/scanner.c
-e   YACC src/parser.y
-e   DEP src/parser.c
-e   DEP src/scanner.c
-e   CC src/main.c
src/main.c: In function 'nft_netlink':
src/main.c:176:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:176:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:194:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:194:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:194:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:195:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:195:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:209:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:209:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/main.c:209:2: warning: cast increases required alignment of target
type [-Wcast-align]
-e   CC src/cli.c
-e   CC src/rule.c
src/rule.c: In function 'set_lookup':
src/rule.c:89:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:89:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'rule_print':
src/rule.c:154:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:154:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'scope_release':
src/rule.c:172:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:172:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:172:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'symbol_lookup':
src/rule.c:196:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:196:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'chain_free':
src/rule.c:261:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:261:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:261:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'chain_lookup':
src/rule.c:277:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:277:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'chain_print':
src/rule.c:353:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:353:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'table_free':
src/rule.c:379:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:379:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:379:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'table_lookup':
src/rule.c:397:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:397:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'table_print':
src/rule.c:413:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:413:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:420:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:420:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'do_add_table':
src/rule.c:520:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:520:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:525:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:525:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'do_list_sets':
src/rule.c:595:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:595:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:595:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'do_command_list':
src/rule.c:645:4: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:645:4: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:671:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:671:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:681:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:681:3: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:692:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:692:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:692:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:705:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:705:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:705:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:710:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:710:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:710:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c: In function 'payload_try_merge':
src/rule.c:843:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:843:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/rule.c:843:2: warning: cast increases required alignment of target
type [-Wcast-align]
-e   CC src/statement.c
src/statement.c: In function 'stmt_list_free':
src/statement.c:45:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/statement.c:45:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/statement.c:45:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/datatype.c
src/datatype.c: In function 'ipaddr_type_parse':
src/datatype.c:385:11: warning: cast increases required alignment of
target type [-Wcast-align]
src/datatype.c: In function 'ip6addr_type_parse':
src/datatype.c:443:11: warning: cast increases required alignment of
target type [-Wcast-align]
src/datatype.c: In function 'inet_service_type_parse':
src/datatype.c:555:11: warning: cast increases required alignment of
target type [-Wcast-align]
src/datatype.c: In function 'concat_type_alloc':
src/datatype.c:858:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/datatype.c:858:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/expression.c
src/expression.c: In function 'compound_expr_clone':
src/expression.c:647:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c:647:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c: In function 'compound_expr_destroy':
src/expression.c:655:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c:655:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c:655:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c: In function 'compound_expr_print':
src/expression.c:664:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c:664:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c: In function 'set_expr_set_type':
src/expression.c:738:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/expression.c:738:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/evaluate.c
src/evaluate.c: In function 'get_set':
src/evaluate.c:134:9: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'list_member_evaluate':
src/evaluate.c:592:22: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'expr_evaluate_concat':
src/evaluate.c:612:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:612:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:612:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'expr_evaluate_list':
src/evaluate.c:648:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:648:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:648:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'expr_evaluate_set':
src/evaluate.c:676:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:676:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:676:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'binop_transfer':
src/evaluate.c:846:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:846:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:851:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:851:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:851:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'rule_evaluate':
src/evaluate.c:1276:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:1276:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'chain_evaluate':
src/evaluate.c:1342:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:1342:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c: In function 'table_evaluate':
src/evaluate.c:1356:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:1356:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:1361:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/evaluate.c:1361:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/proto.c
-e   CC src/payload.c
-e   CC src/exthdr.c
-e   CC src/meta.c
-e   CC src/ct.c
-e   CC src/netlink.c
src/netlink.c: In function 'netlink_gen_concat_data':
src/netlink.c:218:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:218:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:225:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:225:3: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c: In function 'netlink_add_rule_list':
src/netlink.c:336:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:336:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c: In function 'netlink_list_chains':
src/netlink.c:562:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:562:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c: In function 'alloc_setelem_cache':
src/netlink.c:913:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/netlink.c:913:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/netlink_linearize.c
src/netlink_linearize.c: In function 'netlink_gen_concat':
src/netlink_linearize.c:49:2: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_linearize.c:49:2: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_linearize.c: In function 'netlink_linearize_rule':
src/netlink_linearize.c:720:2: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_linearize.c:720:2: warning: cast increases required
alignment of target type [-Wcast-align]
-e   CC src/netlink_delinearize.c
src/netlink_delinearize.c: In function 'payload_match_postprocess':
src/netlink_delinearize.c:639:3: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c:639:3: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c: In function 'expr_postprocess':
src/netlink_delinearize.c:783:3: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c:783:3: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c: In function 'rule_parse_postprocess':
src/netlink_delinearize.c:880:2: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c:880:2: warning: cast increases required
alignment of target type [-Wcast-align]
src/netlink_delinearize.c:880:2: warning: cast increases required
alignment of target type [-Wcast-align]
-e   CC src/segtree.c
src/segtree.c: In function 'seg_tree_init':
src/segtree.c:71:10: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function 'ei_lookup':
src/segtree.c:119:8: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function '__ei_insert':
src/segtree.c:145:8: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function 'set_to_segtree':
src/segtree.c:355:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:355:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:355:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function 'segtree_linearize':
src/segtree.c:397:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function 'set_to_intervals':
src/segtree.c:482:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:482:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:482:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c: In function 'interval_map_decompose':
src/segtree.c:540:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:540:2: warning: cast increases required alignment of
target type [-Wcast-align]
src/segtree.c:540:2: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/rbtree.c
-e   CC src/gmputil.c
-e   CC src/utils.c
-e   CC src/erec.c
src/erec.c: In function 'erec_print_list':
src/erec.c:158:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/erec.c:158:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/erec.c:158:2: warning: cast increases required alignment of target
type [-Wcast-align]
-e   CC src/mnl.c
src/mnl.c: In function 'mnl_nft_socket_sendmsg':
src/mnl.c:217:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/mnl.c:217:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/mnl.c:217:2: warning: cast increases required alignment of target
type [-Wcast-align]
src/mnl.c: In function 'mnl_batch_talk':
src/mnl.c:264:26: warning: cast increases required alignment of target
type [-Wcast-align]
-e   CC src/parser.c
src/parser.y: In function 'nft_parse':
src/parser.y:1045:5: warning: cast increases required alignment of
target type [-Wcast-align]
src/parser.y:1045:5: warning: cast increases required alignment of
target type [-Wcast-align]
-e   CC src/scanner.c
-e   LD src/nft
-e   SUBDIR files/
-e   SUBDIR doc/
-e   MAN doc/nftables.8


--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
