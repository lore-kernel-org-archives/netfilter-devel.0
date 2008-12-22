From: Jan Engelhardt <jengelh@medozas.de>
Subject: Compiler warnings on libnetfilter_*
Date: Mon, 22 Dec 2008 19:13:20 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYLVSNW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:13:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


I have compiled all the libnetfilter* libraries and conntrack-tools,
and this is the collection of compiler warnings I obtained.
(Note: running a silenced automake is a big win.)


+ make -j2
Making all in src
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnfnetlink/src'
  CC       iftable.lo
  CC       libnfnetlink.lo
iftable.c:176: warning: 'iftable_up' defined but not used
  CC       rtnl.lo
  CCLD     libnfnetlink.la
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnfnetlink/src'
+ popd
/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222



+ make -j2
Making all in conntrack
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/conntrack'
  CC       api.lo
  CC       callback.lo
mkdir: cannot create directory `.libs': File exists
callback.c: In function '__callback':
callback.c:30: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
api.c: In function 'nfct_parse_conntrack':
api.c:668: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
  CC       getter.lo
  CC       setter.lo
  CC       parse.lo
  CC       build.lo
  CC       snprintf.lo
  CC       snprintf_default.lo
  CC       snprintf_xml.lo
  CC       objopt.lo
  CC       compare.lo
  CC       copy.lo
  CC       filter.lo
  CC       bsf.lo
  CC       grp.lo
  CC       grp_getter.lo
  CC       grp_setter.lo
  CC       stack.lo
  CCLD     libnfconntrack.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/conntrack'
Making all in expect
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/expect'
  CC       api.lo
  CC       callback.lo
callback.c: In function '__expect_callback':
callback.c:30: warning: passing argument 2 of '__parse_expect' from incompatible pointer type
api.c: In function 'nfexp_parse_expect':
api.c:491: warning: passing argument 2 of '__parse_expect' from incompatible pointer type
  CC       getter.lo
  CC       setter.lo
  CC       parse.lo
  CC       build.lo
  CC       snprintf.lo
  CC       snprintf_default.lo
  CCLD     libnfexpect.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/expect'
Making all in deprecated
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated'
Making all in extensions
make[3]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated/extensions'
  CC       libnetfilter_conntrack_tcp.lo
  CC       libnetfilter_conntrack_udp.lo
  CC       libnetfilter_conntrack_icmp.lo
  CC       libnetfilter_conntrack_sctp.lo
  CCLD     libnfct_proto_tcp.la
  CCLD     libnfct_proto_udp.la
  CCLD     libnfct_proto_icmp.la
  CCLD     libnfct_proto_sctp.la
make[3]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated/extensions'
Making all in l3extensions
make[3]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated/l3extensions'
  CC       libnetfilter_conntrack_ipv4.lo
  CC       libnetfilter_conntrack_ipv6.lo
mkdir: cannot create directory `.libs': File exists
  CCLD     libnfct_l3proto_ipv4.la
  CCLD     libnfct_l3proto_ipv6.la
make[3]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated/l3extensions'
make[3]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated'
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/deprecated'
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src'
  CC       main.lo
  CC       deprecated.lo
(deprecated warnings that are ok)
  CCLD     libnetfilter_conntrack.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src'



+ make -j2
Making all in extensions
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools/extensions'
  CC       libct_proto_tcp.lo
  CC       libct_proto_udp.lo
libct_proto_tcp.c: In function 'final_check':
libct_proto_tcp.c:167: warning: unused parameter 'ct'
libct_proto_udp.c: In function 'final_check':
libct_proto_udp.c:139: warning: unused parameter 'ct'
  CC       libct_proto_icmp.lo
  CC       libct_proto_icmpv6.lo
libct_proto_icmp.c: In function 'parse':
libct_proto_icmp.c:65: warning: unused parameter 'exptuple'
libct_proto_icmp.c:66: warning: unused parameter 'mask'
libct_proto_icmp.c: In function 'final_check':
libct_proto_icmp.c:96: warning: unused parameter 'ct'
libct_proto_icmpv6.c: In function 'parse':
libct_proto_icmpv6.c:68: warning: unused parameter 'exptuple'
libct_proto_icmpv6.c:69: warning: unused parameter 'mask'
libct_proto_icmpv6.c: In function 'final_check':
libct_proto_icmpv6.c:99: warning: unused parameter 'ct'
  CC       libct_proto_unknown.lo
  CCLD     libct_proto_tcp.la
  CCLD     libct_proto_udp.la
  CCLD     libct_proto_icmp.la
  CCLD     libct_proto_icmpv6.la
  CCLD     libct_proto_unknown.la
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools/extensions'
Making all in src
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools/src'
  CC       conntrack.o
  CC       alarm.o
  CC       main.o
conntrack.c: In function 'event_sighandler':
conntrack.c:638: warning: unused parameter 's'
conntrack.c: In function 'dump_cb':
conntrack.c:698: warning: unused parameter 'type'
conntrack.c: In function 'delete_cb':
conntrack.c:735: warning: unused parameter 'type'
conntrack.c: In function 'print_cb':
conntrack.c:773: warning: unused parameter 'type'
conntrack.c:775: warning: unused parameter 'data'
conntrack.c: In function 'update_cb':
conntrack.c:794: warning: unused parameter 'type'
conntrack.c: In function 'dump_exp_cb':
conntrack.c:848: warning: unused parameter 'type'
conntrack.c:850: warning: unused parameter 'data'
main.c: In function 'main':
main.c:264: warning: ignoring return value of 'chdir', declared with attribute warn_unused_result
  CC       run.o
run.c: In function 'killer':
run.c:37: warning: unused parameter 'foo'
run.c: In function 'child':
run.c:62: warning: unused parameter 'foo'
run.c: In function 'do_overrun_alarm':
run.c:205: warning: unused parameter 'a'
run.c:205: warning: unused parameter 'data'
run.c: In function 'event_handler':
run.c:213: warning: unused parameter 'data'
run.c: In function 'dump_handler':
run.c:244: warning: unused parameter 'data'
  CC       hash.o
  CC       queue.o
  CC       rbtree.o
  CC       local.o
  CC       log.o
  CC       mcast.o
  CC       netlink.o
  CC       vector.o
  CC       filter.o
filter.c: In function '__filter_alloc':
filter.c:135: warning: unused parameter 'filter'
  CC       fds.o
  CC       event.o
  CC       cache.o
cache.c: In function '__del_timeout':
cache.c:381: warning: unused parameter 'a'
  CC       cache_iterators.o
  CC       cache_timer.o
cache_timer.c: In function 'timeout':
cache_timer.c:27: warning: unused parameter 'a'
cache_timer.c: In function 'timer_update':
cache_timer.c:43: warning: unused parameter 'u'
cache_timer.c: In function 'timer_destroy':
cache_timer.c:49: warning: unused parameter 'u'
cache_timer.c: In function 'timer_dump':
cache_timer.c:55: warning: unused parameter 'u'
  CC       cache_lifetime.o
  CC       cache_wt.o
cache_lifetime.c: In function 'lifetime_add':
cache_lifetime.c:25: warning: unused parameter 'u'
cache_lifetime.c: In function 'lifetime_update':
cache_lifetime.c:35: warning: unused parameter 'u'
cache_lifetime.c:35: warning: unused parameter 'data'
cache_lifetime.c: In function 'lifetime_destroy':
cache_lifetime.c:39: warning: unused parameter 'u'
cache_lifetime.c:39: warning: unused parameter 'data'
cache_lifetime.c: In function 'lifetime_dump':
cache_lifetime.c:43: warning: unused parameter 'u'
cache_wt.c: In function 'writethrough_add':
cache_wt.c:70: warning: unused parameter 'data'
cache_wt.c: In function 'writethrough_update':
cache_wt.c:75: warning: unused parameter 'data'
cache_wt.c: In function 'writethrough_destroy':
cache_wt.c:80: warning: unused parameter 'data'
  CC       sync-mode.o
  CC       sync-alarm.o
sync-alarm.c: In function 'cache_alarm_update':sync-mode.c: In function 'purge_step':
sync-alarm.c:55: warning: unused parameter 'u'
sync-alarm.c: In function 'cache_alarm_destroy':
sync-alarm.c:63: warning: unused parameter 'u'

sync-mode.c:456: warning: unused parameter 'data1'
sync-mode.c: In function 'overrun_sync':
sync-mode.c:479: warning: unused parameter 'type'
sync-mode.c:481: warning: unused parameter 'data'
  CC       sync-ftfw.o
sync-ftfw.c: In function 'cache_ftfw_add':
sync-ftfw.c:67: warning: unused parameter 'u'
sync-ftfw.c: In function 'cache_ftfw_del':
sync-ftfw.c:75: warning: unused parameter 'u'
sync-ftfw.c: In function 'do_alive_alarm':
sync-ftfw.c:150: warning: unused parameter 'a'
sync-ftfw.c:150: warning: unused parameter 'data'
sync-ftfw.c: In function 'do_cache_to_tx':
sync-ftfw.c:191: warning: unused parameter 'data1'
sync-ftfw.c: In function 'ftfw_local':
sync-ftfw.c:240: warning: unused parameter 'data'
sync-ftfw.c: In function 'rs_list_to_tx':
sync-ftfw.c:303: warning: unused parameter 'c'
sync-ftfw.c: In function 'rs_list_empty':
sync-ftfw.c:328: warning: unused parameter 'c'
sync-ftfw.c: In function 'tx_queue_xmit':
sync-ftfw.c:513: warning: unused parameter 'data2'
  CC       sync-notrack.o
sync-notrack.c: In function 'cache_notrack_add':
sync-notrack.c:39: warning: unused parameter 'u'
sync-notrack.c: In function 'cache_notrack_del':
sync-notrack.c:45: warning: unused parameter 'u'
sync-notrack.c: In function 'do_cache_to_tx':
sync-notrack.c:90: warning: unused parameter 'data1'
sync-notrack.c: In function 'notrack_local':
sync-notrack.c:107: warning: unused parameter 'fd'
sync-notrack.c:107: warning: unused parameter 'data'
sync-notrack.c: In function 'tx_queue_xmit':
sync-notrack.c:156: warning: unused parameter 'data2'
  CC       traffic_stats.o
  CC       stats-mode.o
  CC       network.o
stats-mode.c: In function 'local_handler_stats':
stats-mode.c:60: warning: unused parameter 'data'
stats-mode.c: In function 'overrun_stats':
stats-mode.c:106: warning: unused parameter 'type'
stats-mode.c:108: warning: unused parameter 'data'
stats-mode.c: In function 'purge_step':
stats-mode.c:128: warning: unused parameter 'data1'
  CC       cidr.o
  CC       build.o
  CC       parse.o
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:103:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:106:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:112:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_u32' at build.c:39,
    inlined from 'build_payload' at build.c:116:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_u32' at build.c:39,
    inlined from 'build_payload' at build.c:121:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:125:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:129:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:134:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_group' at build.c:70,
    inlined from 'build_payload' at build.c:138:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_u32' at build.c:39,
    inlined from 'build_payload' at build.c:146:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_u32' at build.c:39,
    inlined from 'build_payload' at build.c:148:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
In function 'memset',
    inlined from 'put_header' at build.c:32,
    inlined from '__build_natseqadj' at build.c:39,
    inlined from 'build_payload' at build.c:156:
/usr/include/bits/string3.h:82: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
parse.c: In function 'parse_nat_seq_adj':
parse.c:154: warning: unused parameter 'attr'
  LEX      read_config_lex.c
  YACC     read_config_yy.c
  CCLD     conntrack
updating read_config_yy.h
  CC       read_config_lex.o
read_config_lex.c: In function 'yylex':
read_config_lex.l:148: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
read_config_lex.c: In function 'yy_get_next_buffer':
read_config_lex.c:4903: warning: comparison between signed and unsigned
  CC       read_config_yy.o
read_config_yy.c: In function 'yyparse':
read_config_yy.c:1706: warning: implicit declaration of function 'yylex'
read_config_yy.y:206: warning: implicit declaration of function 'inet_aton'
read_config_yy.c:2807: warning: implicit declaration of function 'yyerror'
read_config_yy.y: In function 'init_config':
read_config_yy.y:1060: warning: implicit declaration of function 'yyrestart'
  CCLD     conntrackd
build.o: In function `build_payload':
build.c:(.text+0x47): warning: memset used with constant zero length parameter; this could be due to transposed parameters
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools/src'
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools'
+ popd


