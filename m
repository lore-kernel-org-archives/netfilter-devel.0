From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Small profile of a fileserver
Date: 17 Mar 2003 23:11:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047939091.744.52.camel@tux.rsn.bth.se>
References: <1047937471.1521.40.camel@tux.rsn.bth.se>
	 <20030317215907.GG15383@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030317215907.GG15383@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-03-17 at 22:59, Patrick Schaaf wrote:

> > 765178 ipt_do_table                             839.0110
> 
> Pet peeve: I assume you don't use any interface matches, right?
> Could you try again with the horrible interface matching stuff
> disabled inline in the kernel code? And then, could we please
> devise a scheme to make those optional?

Correct, no interface matches. I'll see what I can do, this is the first
time the server has been stable this long (ripped out the
promise-controllers...), I'll probably have to strongarm the other
admins into letting me play with it :)

> This is a bit of a wild guess, but what's in there besides that?

the machine has three tables: filter, nat and mangle.
it only has 6 rules in total. 4 in filter/INPUT and 2 in filter/OUTPUT.
That's it. They only match on ipaddresses and no targets, just simple
counters.

> > 248488 __ip_conntrack_find                      862.8056
> 
> Tune the hashes, and that will improve, I think.

We need prefetching and grouping stuff together on the same cacheline as
well, have you seen Andi Kleen's hlist for dcache stuff in 2.5?

> It is clearly interesting that lots of iptables is up there
> above the base network stack, even though you describe your
> tables as simple.

Here's the first 195 lines of the full profile (not edited to just show
netfilter/iptables):

307350492 total                                    208.7094
279059673 default_idle                             5813743.1875
5128175 handle_IRQ_event                         53418.4896
2846529 file_read_actor                          19767.5625
2793087 csum_partial_copy_generic                10910.4961
908555 kfree                                    4732.0573
900094 do_softirq                               5114.1705
772004 ide_outb                                 48250.2500
765178 ipt_do_table                             839.0110
459249 skb_clone                                1103.9639
411838 alloc_skb                                1072.4948
389875 ide_do_request                           566.6788
363444 kmalloc                                  1261.9583
355463 skb_release_data                         3173.7768
335945 ide_intr                                 1166.4757
335753 __kfree_skb                              1165.8090
330264 tcp_sendmsg                               78.7844
315843 tcp_write_xmit                           448.6406
261123 tcp_transmit_skb                         185.4567
248488 __ip_conntrack_find                      862.8056
245119 eth_type_trans                           1392.7216
235043 tcp_clean_rtx_queue                      312.5572
219687 nf_hook_slow                             686.5219
214571 kfree_skbmem                             2235.1146
207563 nf_iterate                               1621.5859
201294 tcp_packet                               599.0893
187459 generic_file_write                       103.6831
174719 ide_inb                                  10919.9375
171076 tcp_rcv_established                       93.7917
170847 ip_conntrack_in                          273.7933
155039 tcp_v4_rcv                               111.3786
153983 page_cache_read                          801.9948
152690 kmem_cache_free                          867.5568
148321 do_generic_file_read                     144.8447
147667 ip_nat_fn                                341.8218
143992 ip_queue_xmit2                           283.4488
135036 rmqueue                                  241.1357
132799 do_bindings                              172.9154
131708 ip_queue_xmit                            105.5353
121735 process_backlog                          447.5551
120490 schedule                                 209.1840
109189 get_hash_table                           758.2569
108599 ipt_local_hook                           522.1106
105241 tcp_ack                                  128.9718
104045 unlock_page                              928.9732
102585 system_call                              1831.8750
100527 __make_request                            71.3970
 99795 __block_prepare_write                    138.6042
 96266 del_timer                                1504.1562
 92137 ip_finish_output2                        442.9663
 90961 kmem_cache_alloc                         406.0759
 89337 fast_copy_page                           398.8259
 88207 journal_try_to_free_buffers              551.2938
 88131 ip_rcv                                   102.0035
 81923 add_timer                                365.7277
 79444 dev_queue_xmit                           137.9236
 79383 netif_rx                                 215.7147
 78545 ip_route_input                           233.7649
 78332 sys_select                                68.9542
 74419 generic_make_request                     244.7993
 72111 sys_read                                 300.4625
 70364 netif_receive_skb                        231.4605
 70074 pfifo_fast_dequeue                       729.9375
 70049 ip_conntrack_get                         1459.3542
 68569 try_to_release_page                      857.1125
 67486 __free_pages_ok                          102.8750
 65922 tcp_sacktag_write_queue                   54.9350
 64573 __rdtsc_delay                            2017.9062
 64269 ide_build_sglist                         148.7708
 64018 fget                                     1333.7083
 62846 __wake_up                                561.1250
 61293 shrink_cache                              78.1798
 60565 ext3_get_branch                          270.3795
 59361 _mmx_memcpy                              168.6392
 58527 sys_write                                243.8625
 58261 do_get_write_access                       47.2898
 55873 csum_partial                             194.0035
 54991 ext3_do_update_inode                      59.2575
 54809 journal_dirty_metadata                   142.7318
 54586 ip_nat_local_fn                          379.0694
 53205 ext3_get_inode_loc                       144.5788
 50726 ip_refrag                                528.3958
 49051 ip_local_deliver_finish                  161.3520
 48193 block_read_full_page                      86.0589
 46319 do_select                                 96.4979
 45536 generic_unplug_device                    948.6667
 44672 tcp_recvmsg                               20.9925
 44142 net_tx_action                            275.8875
 42992 mod_timer                                167.9375
 42976 ip_rcv_finish                             99.4815
 42730 qdisc_restart                            205.4327
 42281 ip_local_deliver                         105.7025
 42125 d_lookup                                 164.5508
 41845 __tcp_select_window                      186.8080
 40745 fput                                     181.8973
 40395 mark_page_accessed                       841.5625
 39500 kmem_cache_reap                           77.1484
 39333 __tcp_data_snd_check                     189.1010
 39314 journal_add_journal_head                 189.0096
 38848 journal_get_write_access                 404.6667
 37866 __ip_ct_find_proto                       788.8750
 37039 ext3_get_block_handle                     62.5659
 35780 ip_nat_out                               319.4643
 35431 link_path_walk                            16.5257
 34108 ipt_route_hook                           710.5833
 34100 pfifo_fast_enqueue                       304.4643
 33570 net_rx_action                            123.4191
 33327 get_conntrack_index                      520.7344
 33322 ip_confirm                               694.2083
 33185 ext3_group_sparse                        345.6771
 33054 ip_output                                114.7708
 32912 ip_conntrack_local                       342.8333
 32801 __alloc_pages                             93.1847
 32657 get_unused_buffer_head                   255.1328
 31319 sock_poll                                652.4792
 31211 do_gettimeofday                          325.1146
 30890 tcp_poll                                  91.9345
 30269 tcp_v4_do_rcv                             85.9915
 30044 generic_file_readahead                    93.8875
 29645 ext3_block_to_path                       108.9890
 29486 sock_wfree                               460.7188
 29298 find_inode                               366.2250
 29252 ip_ct_refresh                            261.1786
 29031 do_page_fault                             26.9805
 28507 ip_ct_find_proto                         445.4219
 27887 __remove_inode_page                      217.8672
 27462 tcp_v4_send_check                        156.0341
 25259 ext3_new_block                            12.3335
 24893 ipt_local_out_hook                       259.3021
 23767 do_rw_disk                                16.5049
 23266 ide_outl                                 1454.1250
 22669 journal_stop                              47.2271
 22125 try_to_free_buffers                       92.1875
 21787 zap_page_range                            37.8247
 21219 get_sample_stats                         147.3542
 20967 fast_clear_page                          262.0875
 20670 tcp_data_queue                             8.2285
 20663 journal_cancel_revoke                    107.6198
 20579 ext3_dirty_inode                          98.9375
 20053 __free_pages                             626.6562
 19118 ip_conntrack_find_get                    238.9750
 18626 __journal_file_buffer                     38.8042
 18407 sock_sendmsg                             127.8264
 18000 create_buffers                            80.3571
 17861 __generic_copy_to_user                   223.2625
 17848 getblk                                   223.1000
 17760 ext3_commit_write                         39.6429
 17546 start_this_handle                         47.6793
 17340 set_bh_page                              180.6250
 17181 __brelse                                 536.9062
 16933 ext3_releasepage                         352.7708
 16690 skb_checksum                              28.9757
 16453 add_to_page_cache_unique                 128.5391
 16448 update_atime                             205.6000
 16161 __find_get_page                          336.6875
 15974 tcp_fastretrans_alert                     13.1365
 15858 ext3_find_entry                           20.6484
 15847 inet_sendmsg                             247.6094
 15816 ide_build_dmatable                        35.3036
 15721 add_page_to_hash_queue                   327.5208
 15698 posix_lock_file                           12.4193
 15393 tcp_v4_checksum_init                      60.1289
 15181 bread                                    135.5446
 14653 tcp_ack_update_window                     70.4471
 14600 submit_bh                                130.3571
 14466 copy_page_range                           34.7740
 13598 unlock_buffer                            212.4688
 13247 __remove_from_lru_list                   137.9896
 13023 ipt_hook                                 271.3125
 12994 start_request                             28.0043
 12689 max_select_fd                             72.0966
 12647 ext3_prepare_write                        37.6399
 12457 create_empty_buffers                     129.7604
 11988 fcntl_setlk64                             24.1694
 11959 ext3_reserve_inode_write                  67.9489
 11887 ide_get_queue                            247.6458
 11867 set_buffer_flushtime                     370.8438
 11854 journal_start                             61.7396
 11615 journal_dirty_data                        30.2474
 11591 __mark_inode_dirty                        80.4931
 11284 journal_unlock_journal_head              117.5417
 11266 filemap_nopage                            22.0039
 11148 find_trylock_page                        116.1250
 11004 __lru_cache_del                           98.2500
 10956 buffer_insert_list                       136.9500
 10887 tcp_ack_no_tstamp                         42.5273
 10857 lru_cache_add                            113.0938
 10751 tcp_event_data_recv                       23.1703
 10646 _alloc_pages                             332.6875
 10495 tcp_data_wait                             32.7969
 10329 cleanup_rbuf                              46.1116
 10322 inet_recvmsg                             107.5208
 10277 tcp_new_space                             71.3681
 10188 __find_lock_page_helper                  106.1250
 10054 tcp_parse_options                         17.9536


-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
