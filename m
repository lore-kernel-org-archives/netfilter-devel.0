From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Small profile of a fileserver
Date: 17 Mar 2003 22:44:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047937471.1521.40.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Here's the netfilter/iptables stuff from a profile of a fileserver, it's
not terrible busy but it peaks at ~200Mbit/s sometimes. (I hope I didn't
miss anything when cutting out everything else from the profile, and
I've probably forgot to delete some of the other stuff...)

UP AMD Athlon XP 1600+ with gigE NIC. 256MB ddr ram.

37.5 days uptime, booted with profile=2
Everything compiled into kernel. It has conntrack, filter, nat, mangle
tables. Only 4 rules in filter/INPUT and 2 rules in filter/OUTPUT, just
a few counters, otherwise it's clean.

Doesn't handle many connections so the hashtable isn't tuned in any way
(not even decreased to 2^n-1 to help the current hashfunction) (logs
have been rotated away so I can't check how many buckets it's running
with but ip_conntrack_max / 8 = 2048)

Usually 100-200 entries in conntrack.


307350492 total                                    208.7094
279059673 default_idle                             5813743.1875
765178 ipt_do_table                             839.0110
248488 __ip_conntrack_find                      862.8056
219687 nf_hook_slow                             686.5219
207563 nf_iterate                               1621.5859
170847 ip_conntrack_in                          273.7933
147667 ip_nat_fn                                341.8218
132799 do_bindings                              172.9154
108599 ipt_local_hook                           522.1106
 96266 del_timer                                1504.1562
 81923 add_timer                                365.7277
 70049 ip_conntrack_get                         1459.3542
 54586 ip_nat_local_fn                          379.0694
 50726 ip_refrag                                528.3958
 42281 ip_local_deliver                         105.7025
 37866 __ip_ct_find_proto                       788.8750
 35780 ip_nat_out                               319.4643
 34108 ipt_route_hook                           710.5833
 33327 get_conntrack_index                      520.7344
 33054 ip_output                                114.7708
 32912 ip_conntrack_local                       342.8333
 29252 ip_ct_refresh                            261.1786
 28507 ip_ct_find_proto                         445.4219
 24893 ipt_local_out_hook                       259.3021
 19118 ip_conntrack_find_get                    238.9750
 13023 ipt_hook                                 271.3125
  8795 nf_register_queue_handler                 91.6146
  5394 ip_frag_queue                              6.6103
  2604 arpt_do_table                              2.4291
  2201 ip_defrag                                  7.2401
   615 ip_ct_gather_frags                         2.1354
   600 init_conntrack                             0.7212
   588 ip_nat_setup_info                          0.8352
   578 skb_linearize                              2.4083
   480 ip_nat_seq_adjust                          1.3636
   321 __ip_conntrack_confirm                     0.5280
   234 .text.lock.netfilter                       1.0685
   233 find_nat_proto                             4.8542
   226 ip_conntrack_alter_reply                   0.8828
   224 arpt_hook                                  4.6667
   206 ip_ct_find_helper                          1.6094
   205 ip_frag_create                             1.1648
   187 ip_nat_cheat_check                         2.3375
   165 ip_conntrack_expect_related                0.1289
   145 ip_frag_destroy                            1.0069
    85 ip_route_me_harder                         0.2099
    82 ip_nat_rule_find                           0.4659
    81 find_best_ips_proto_fast                   0.7232
    47 ip_conntrack_tuple_taken                   0.7344
    41 ftp_nat_expected                           0.1971
    31 ip_rt_frag_needed                          0.0538
    28 invert_tuple                               0.5833
    20 ip_nat_used_tuple                          0.4167
    11 ip_nat_cleanup_conntrack                   0.0859
    11 icmp_error_track                           0.0246
     9 manip_pkt                                  0.0703
     7 destroy_conntrack                          0.0337
     5 death_by_timeout                           0.0625
     1 icmp_pkt_to_tuple                          0.0208
     1 .text.lock.ip_conntrack_proto_tcp          0.0137

the nat code uses a lot of cpu even though I don't have _any_ rules in
the nat-table. It does have some traffic on the ftpserver on port 21 and
ip_conntrack_ftp and ip_nat_ftp is compiled into the kernel.

nf_iterate uses a lot of cpu, the only thing it does is to call all
registered hook-callbacks in order for each hook.

The server spends 9.2% of it's time in kernel and 9.69% of that is spent
in netfilter/iptables (0.89% of the total time)

A fileserver is an easy load for conntrack, I will see if I can use
oprofile on one of our routers.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
