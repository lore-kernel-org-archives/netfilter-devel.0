Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B5AEE800D
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbjIHORh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjIHORg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:17:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4A21BF1
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 07:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SMzIyavN/O1a0eiEN9I+NJ6CCmyLH+FTNl6OFn+nKao=;
        b=RDUvYPPdmiV1ET/jvlTujtN0MqBn0HWqPQ0MW0GmMsLkN/+8knDWUO72ojcigImgp3SFke
        b/OyzS/HKn5jzPUk3hzbLOdiRwoyV1VdvZI931DSb6RPlHUw1mNkAFB2gb9gS081ktcUOZ
        2T/Kgqw+kVB3JqDBy4u9A3ww2LV6be8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-lFYl_IaVP721cJixzH1nDA-1; Fri, 08 Sep 2023 10:16:47 -0400
X-MC-Unique: lFYl_IaVP721cJixzH1nDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3CB53C1ACFE
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 14:16:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F072240ED774;
        Fri,  8 Sep 2023 14:16:44 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/4] tests/shell: add missing .nft and .nodump files
Date:   Fri,  8 Sep 2023 16:14:23 +0200
Message-ID: <20230908141634.1023071-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Followup and obsoletes:
  [PATCH nft 1/2] tests/shell: honor .nodump file for tests without nft dumps
  [PATCH nft 2/2] tests/shell: add missing ".nodump" file for tests without dumps

Changes are that instead of adding all ".nodump" files, add the expected
.nft ruleset to check. A few .nodump files are still there, as it makes
sense.

Thomas Haller (4):
  tests/shell: honor .nodump file for tests without nft dumps
  tests/shell: generate and add ".nft" dump files for existing tests
  tests/shell: add missing ".nodump" file for tests without dumps
  tests/shell: add ".nft" dump files for tests without dumps/ directory

 tests/shell/helpers/test-wrapper.sh           |  10 +-
 .../bogons/dumps/assert_failures.nft          |   0
 .../cache/dumps/0003_cache_update_0.nft       |  18 +
 .../cache/dumps/0004_cache_update_0.nft       |   5 +
 .../cache/dumps/0005_cache_chain_flush.nft    |  14 +
 .../cache/dumps/0006_cache_table_flush.nft    |  14 +
 .../cache/dumps/0008_delete_by_handle_0.nft   |   2 +
 .../0009_delete_by_handle_incorrect_0.nft     |   0
 .../cache/dumps/0010_implicit_chain_0.nft     |   7 +
 .../testcases/chains/dumps/0002jumps_1.nft    |  68 ++
 .../chains/dumps/0003jump_loop_1.nft          |  64 ++
 .../testcases/chains/dumps/0004busy_1.nft     |   8 +
 .../testcases/chains/dumps/0005busy_map_1.nft |   8 +
 .../chains/dumps/0007masquerade_1.nft         |   5 +
 .../chains/dumps/0008masquerade_jump_1.nft    |   9 +
 .../chains/dumps/0009masquerade_jump_1.nft    |   9 +
 .../chains/dumps/0010endless_jump_loop_1.nft  |   4 +
 .../chains/dumps/0011endless_jump_loop_1.nft  |  13 +
 .../testcases/chains/dumps/0014rename_0.nft   |   7 +
 .../chains/dumps/0015check_jump_loop_1.nft    |   8 +
 .../chains/dumps/0017masquerade_jump_1.nft    |   9 +
 .../chains/dumps/0018check_jump_loop_1.nft    |   8 +
 .../chains/dumps/0019masquerade_jump_1.nft    |   9 +
 .../testcases/chains/dumps/0020depth_1.nft    |  84 ++
 .../chains/dumps/0022prio_dummy_1.nft         |   2 +
 .../chains/dumps/0023prio_inet_srcnat_1.nft   |   6 +
 .../chains/dumps/0024prio_inet_dstnat_1.nft   |   6 +
 .../testcases/chains/dumps/0025prio_arp_1.nft |   2 +
 .../chains/dumps/0026prio_netdev_1.nft        |   2 +
 .../chains/dumps/0027prio_bridge_dstnat_1.nft |   2 +
 .../chains/dumps/0028prio_bridge_out_1.nft    |   2 +
 .../chains/dumps/0029prio_bridge_srcnat_1.nft |   2 +
 .../chains/dumps/0033priority_variable_1.nft  |   0
 .../chains/dumps/0034priority_variable_1.nft  |   0
 .../chains/dumps/0036policy_variable_0.nft    |   5 +
 .../chains/dumps/0037policy_variable_1.nft    |   0
 .../chains/dumps/0038policy_variable_1.nft    |   0
 .../chains/dumps/0039negative_priority_0.nft  |   5 +
 .../chains/dumps/0043chain_ingress_0.nft      |  13 +
 .../dumps/0002create_flowtable_0.nft          |   6 +
 .../flowtable/dumps/0003add_after_flush_0.nft |   6 +
 .../dumps/0004delete_after_add_0.nft          |   2 +
 .../flowtable/dumps/0005delete_in_use_1.nft   |  10 +
 .../flowtable/dumps/0006segfault_0.nft        |   2 +
 .../testcases/flowtable/dumps/0007prio_0.nft  |   2 +
 .../testcases/flowtable/dumps/0008prio_1.nft  |   2 +
 .../dumps/0009deleteafterflush_0.nft          |   4 +
 .../flowtable/dumps/0010delete_handle_0.nft   |   2 +
 .../dumps/0011deleteafterflush_0.nft          |   4 +
 .../flowtable/dumps/0013addafterdelete_0.nft  |   7 +
 .../flowtable/dumps/0014addafterdelete_0.nft  |  12 +
 .../include/dumps/0004endlessloop_1.nft       |   0
 .../include/dumps/0005glob_empty_0.nft        |   0
 .../dumps/0008glob_nofile_wildcard_0.nft      |   0
 .../include/dumps/0009glob_nofile_1.nft       |   0
 .../include/dumps/0010glob_broken_file_1.nft  |   0
 .../include/dumps/0012glob_dependency_1.nft   |   0
 ...0013input_descriptors_included_files_0.nft |   0
 .../include/dumps/0014glob_directory_0.nft    |   0
 .../include/dumps/0016maxdepth_0.nft          |   0
 .../dumps/0017glob_more_than_maxdepth_1.nft   |   0
 .../include/dumps/0018include_error_0.nft     |   0
 .../include/dumps/0019include_error_0.nft     |   0
 tests/shell/testcases/json/dumps/netdev.nft   |   2 +
 .../testcases/listing/dumps/0002ruleset_0.nft |   0
 .../testcases/listing/dumps/0003table_0.nft   |   2 +
 .../testcases/listing/dumps/0004table_0.nft   |   4 +
 .../listing/dumps/0005ruleset_ip_0.nft        |  10 +
 .../listing/dumps/0006ruleset_ip6_0.nft       |  10 +
 .../listing/dumps/0007ruleset_inet_0.nft      |  10 +
 .../listing/dumps/0008ruleset_arp_0.nft       |  10 +
 .../listing/dumps/0009ruleset_bridge_0.nft    |  10 +
 .../testcases/listing/dumps/0010sets_0.nft    |  39 +
 .../testcases/listing/dumps/0011sets_0.nft    |  25 +
 .../testcases/listing/dumps/0012sets_0.nft    |  39 +
 .../testcases/listing/dumps/0014objects_0.nft |  12 +
 .../testcases/listing/dumps/0015dynamic_0.nft |   7 +
 .../listing/dumps/0016anonymous_0.nft         |   6 +
 .../testcases/listing/dumps/0017objects_0.nft |   5 +
 .../testcases/listing/dumps/0018data_0.nft    |   5 +
 .../testcases/listing/dumps/0019set_0.nft     |   5 +
 .../listing/dumps/0020flowtable_0.nft         |  20 +
 .../dumps/0021ruleset_json_terse_0.nft        |   9 +
 .../testcases/listing/dumps/0022terse_0.nft   |  12 +
 .../dumps/0003map_add_many_elements_0.nft     | 486 ++++++++++++
 .../0004interval_map_create_once_0.nodump     |   0
 .../maps/dumps/0008interval_map_delete_0.nft  |  15 +
 .../testcases/maps/dumps/0016map_leak_0.nft   |   0
 .../maps/dumps/0017_map_variable_0.nft        |  11 +
 .../maps/dumps/0018map_leak_timeout_0.nft     |   0
 .../maps/dumps/different_map_types_1.nft      |   5 +
 .../testcases/netns/dumps/0001nft-f_0.nft     |   0
 .../netns/dumps/0002loosecommands_0.nft       |   0
 .../testcases/netns/dumps/0003many_0.nft      |   0
 .../nft-f/dumps/0001define_slash_0.nft        |   0
 .../nft-f/dumps/0006action_object_0.nft       |   0
 .../0007action_object_set_segfault_1.nft      |   0
 .../nft-f/dumps/0011manydefines_0.nodump      |   0
 .../testcases/nft-f/dumps/0013defines_1.nft   |   0
 .../testcases/nft-f/dumps/0014defines_1.nft   |   0
 .../testcases/nft-f/dumps/0015defines_1.nft   |   0
 .../testcases/nft-f/dumps/0016redefines_1.nft |   6 +
 .../nft-f/dumps/0018ct_expectation_obj_0.nft  |  13 +
 .../nft-f/dumps/0019jump_variable_1.nft       |   0
 .../nft-f/dumps/0020jump_variable_1.nft       |   0
 .../testcases/nft-f/dumps/0023check_1.nft     |   5 +
 .../testcases/nft-f/dumps/0026listing_0.nft   |   5 +
 .../nft-f/dumps/0029split_file_0.nft          |  10 +
 .../nft-f/dumps/0031vmap_string_0.nft         |   0
 .../testcases/nft-i/dumps/0001define_0.nft    |   0
 .../testcases/optimizations/dumps/ruleset.nft |   0
 .../optimizations/dumps/variables.nft         |   0
 .../dumps/comments_objects_dup_0.nft          |   0
 .../dumps/delete_object_handles_0.nft         |  18 +
 .../testcases/optionals/dumps/handles_1.nft   |   5 +
 .../dumps/update_object_handles_0.nft         |   9 +
 .../owner/dumps/0001-flowtable-uaf.nft        |   0
 .../testcases/parsing/dumps/describe.nft      |   0
 tests/shell/testcases/parsing/dumps/log.nft   |   0
 tests/shell/testcases/parsing/dumps/octal.nft |   0
 .../dumps/0001addinsertposition_0.nft         |   7 +
 .../dumps/0002addinsertlocation_1.nft         |   6 +
 .../rule_management/dumps/0005replace_1.nft   |   4 +
 .../rule_management/dumps/0006replace_1.nft   |   4 +
 .../rule_management/dumps/0008delete_1.nft    |   4 +
 .../rule_management/dumps/0009delete_1.nft    |   4 +
 .../rule_management/dumps/0010replace_0.nft   |   0
 .../sets/dumps/0011add_many_elements_0.nodump |   0
 .../0014malformed_set_is_not_defined_0.nft    |   0
 .../sets/dumps/0018set_check_size_1.nft       |   7 +
 .../testcases/sets/dumps/0028autoselect_0.nft |  26 +
 .../sets/dumps/0028delete_handle_0.nft        |  15 +
 .../0030add_many_elements_interval_0.nodump   |   0
 .../sets/dumps/0031set_timeout_size_0.nft     |  13 +
 .../sets/dumps/0033add_set_simple_flat_0.nft  |  11 +
 .../sets/dumps/0034get_element_0.nft          |  23 +
 .../dumps/0035add_set_elements_flat_0.nft     |   6 +
 .../0036add_set_element_expiration_0.nodump   |   0
 .../testcases/sets/dumps/0038meter_list_0.nft |  11 +
 .../sets/dumps/0039delete_interval_0.nft      |   7 +
 .../dumps/0040get_host_endian_elements_0.nft  |   7 +
 .../testcases/sets/dumps/0041interval_0.nft   |   7 +
 .../testcases/sets/dumps/0042update_set_0.nft |  15 +
 .../sets/dumps/0043concatenated_ranges_0.nft  |  11 +
 .../sets/dumps/0043concatenated_ranges_1.nft  | 116 +++
 .../sets/dumps/0044interval_overlap_0.nodump  |   0
 .../sets/dumps/0044interval_overlap_1.nft     | 106 +++
 .../testcases/sets/dumps/0050set_define_1.nft |   0
 .../sets/dumps/0056dynamic_limit_0.nft        |   0
 .../sets/dumps/0057set_create_fails_0.nft     |   7 +
 .../sets/dumps/0062set_connlimit_0.nft        |  16 +
 .../sets/dumps/0065_icmp_postprocessing.nft   |   6 +
 .../0068interval_stack_overflow_0.nodump      |   0
 .../testcases/sets/dumps/automerge_0.nodump   |   0
 tests/shell/testcases/sets/dumps/errors_0.nft |   0
 .../testcases/sets/dumps/exact_overlap_0.nft  |  13 +
 .../transactions/dumps/0003table_0.nft        |   4 +
 .../transactions/dumps/0014chain_1.nft        |   0
 .../transactions/dumps/0015chain_0.nft        |   0
 .../transactions/dumps/0020rule_0.nft         |   0
 .../transactions/dumps/0022rule_1.nft         |   0
 .../transactions/dumps/0023rule_1.nft         |   0
 .../transactions/dumps/0036set_1.nft          |   0
 .../transactions/dumps/0041nat_restore_0.nft  |   5 +
 .../dumps/0042_stateful_expr_0.nft            |   5 +
 .../transactions/dumps/0043set_1.nft          |   0
 .../transactions/dumps/0044rule_0.nft         |   0
 .../transactions/dumps/0045anon-unbind_0.nft  |   0
 .../transactions/dumps/0046set_0.nft          |   2 +
 .../transactions/dumps/0047set_0.nft          |  11 +
 .../transactions/dumps/0048helpers_0.nft      |   2 +
 .../transactions/dumps/0049huge_0.nft         | 749 ++++++++++++++++++
 .../transactions/dumps/0050rule_1.nft         |   0
 .../transactions/dumps/0051map_0.nft          |   7 +
 .../transactions/dumps/30s-stress.nft         |   0
 .../transactions/dumps/anon_chain_loop.nft    |   0
 176 files changed, 2554 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/dumps/assert_failures.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0003_cache_update_0.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0004_cache_update_0.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0005_cache_chain_flush.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0006_cache_table_flush.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0008_delete_by_handle_0.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0009_delete_by_handle_incorrect_0.nft
 create mode 100644 tests/shell/testcases/cache/dumps/0010_implicit_chain_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0002jumps_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0003jump_loop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0004busy_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0005busy_map_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0007masquerade_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0008masquerade_jump_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0009masquerade_jump_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0010endless_jump_loop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0014rename_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0015check_jump_loop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0017masquerade_jump_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0018check_jump_loop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0019masquerade_jump_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0020depth_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0022prio_dummy_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0023prio_inet_srcnat_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0024prio_inet_dstnat_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0025prio_arp_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0026prio_netdev_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0027prio_bridge_dstnat_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0028prio_bridge_out_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0029prio_bridge_srcnat_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0033priority_variable_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0034priority_variable_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0036policy_variable_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0037policy_variable_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0038policy_variable_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0039negative_priority_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0043chain_ingress_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0002create_flowtable_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0003add_after_flush_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0004delete_after_add_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0006segfault_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0007prio_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0008prio_1.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0009deleteafterflush_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0010delete_handle_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0011deleteafterflush_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0004endlessloop_1.nft
 create mode 100644 tests/shell/testcases/include/dumps/0005glob_empty_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0008glob_nofile_wildcard_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0009glob_nofile_1.nft
 create mode 100644 tests/shell/testcases/include/dumps/0010glob_broken_file_1.nft
 create mode 100644 tests/shell/testcases/include/dumps/0012glob_dependency_1.nft
 create mode 100644 tests/shell/testcases/include/dumps/0013input_descriptors_included_files_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0014glob_directory_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0016maxdepth_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0017glob_more_than_maxdepth_1.nft
 create mode 100644 tests/shell/testcases/include/dumps/0018include_error_0.nft
 create mode 100644 tests/shell/testcases/include/dumps/0019include_error_0.nft
 create mode 100644 tests/shell/testcases/json/dumps/netdev.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0002ruleset_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0003table_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0004table_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0005ruleset_ip_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0006ruleset_ip6_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0007ruleset_inet_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0008ruleset_arp_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0009ruleset_bridge_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0010sets_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0011sets_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0012sets_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0014objects_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0015dynamic_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0016anonymous_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0017objects_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0018data_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0019set_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0020flowtable_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0021ruleset_json_terse_0.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0022terse_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0003map_add_many_elements_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0004interval_map_create_once_0.nodump
 create mode 100644 tests/shell/testcases/maps/dumps/0008interval_map_delete_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0016map_leak_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0017_map_variable_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/0018map_leak_timeout_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/different_map_types_1.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0001nft-f_0.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0002loosecommands_0.nft
 create mode 100644 tests/shell/testcases/netns/dumps/0003many_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0001define_slash_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0006action_object_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0007action_object_set_segfault_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0011manydefines_0.nodump
 create mode 100644 tests/shell/testcases/nft-f/dumps/0013defines_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0014defines_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0015defines_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0016redefines_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0018ct_expectation_obj_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0019jump_variable_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0020jump_variable_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0023check_1.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0026listing_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0029split_file_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0031vmap_string_0.nft
 create mode 100644 tests/shell/testcases/nft-i/dumps/0001define_0.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/ruleset.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/variables.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_objects_dup_0.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/delete_object_handles_0.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/handles_1.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/update_object_handles_0.nft
 create mode 100644 tests/shell/testcases/owner/dumps/0001-flowtable-uaf.nft
 create mode 100644 tests/shell/testcases/parsing/dumps/describe.nft
 create mode 100644 tests/shell/testcases/parsing/dumps/log.nft
 create mode 100644 tests/shell/testcases/parsing/dumps/octal.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0001addinsertposition_0.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0002addinsertlocation_1.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0005replace_1.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0006replace_1.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0008delete_1.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0009delete_1.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0010replace_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0011add_many_elements_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/0014malformed_set_is_not_defined_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0018set_check_size_1.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0028autoselect_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0028delete_handle_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0030add_many_elements_interval_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/0031set_timeout_size_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0034get_element_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0036add_set_element_expiration_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/0038meter_list_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0039delete_interval_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0041interval_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0042update_set_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0044interval_overlap_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/0044interval_overlap_1.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0050set_define_1.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0056dynamic_limit_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0062set_connlimit_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0065_icmp_postprocessing.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0068interval_stack_overflow_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/automerge_0.nodump
 create mode 100644 tests/shell/testcases/sets/dumps/errors_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/exact_overlap_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0003table_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0014chain_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0015chain_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0020rule_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0022rule_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0023rule_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0036set_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0041nat_restore_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0042_stateful_expr_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0043set_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0044rule_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0045anon-unbind_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0046set_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0047set_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0048helpers_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0049huge_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0051map_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/30s-stress.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/anon_chain_loop.nft

-- 
2.41.0

