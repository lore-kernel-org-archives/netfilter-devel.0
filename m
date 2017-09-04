From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [nft PATCH V2] tests: shell: Add tests for json import
Date: Mon, 4 Sep 2017 18:09:59 +0530
Message-ID: <CAOfkYf6VNKCSb4tuiGTimnJaay=u-vSLGQGzcfOO+B1_O44y2A@mail.gmail.com>
References: <1504395174-15192-1-git-send-email-mayhs11saini@gmail.com> <CAOkSjBgXvKuCV3Am--Qr1OiE1eL9Rau2Q9SS2XLOgZ+Ff7VPgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33543 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdIDMkB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 08:40:01 -0400
Received: by mail-oi0-f68.google.com with SMTP id k191so193665oih.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Sep 2017 05:40:00 -0700 (PDT)
In-Reply-To: <CAOkSjBgXvKuCV3Am--Qr1OiE1eL9Rau2Q9SS2XLOgZ+Ff7VPgA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> These test cases can be used to test upcoming "import json" command.
>>
>> Here is the short description of the files:
>> all_ruleset_list   ->    contains list of all the individual rules
>> json_import_0      ->    script that runs json run-tests.sh
>>
>>         For Example:
>>         $ ./run-tests.sh testcases/import/json_import_0
>>
>> Below mentioned files contains individual rules in json format and
>> are added for the reference:
>> rules_ipv4*        ->    ip  table rules files
>> rules_ipv6*        ->    ip6 table rules files
>> rules_arp*         ->    arp table rules files
>> rules_bridge*      ->    bridge table rules files
>>
>> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
>> ---
>
> This is v2: generally in this patch section we include patch changelog
> information.
> Please, take a look at this when sending v3 :-)
>
>>  tests/shell/testcases/import/all_ruleset_list      | 46 ++++++++++++++
>>  tests/shell/testcases/import/json_import_0         | 72 ++++++++++++++++++++++
>>  .../testcases/import/rules_arp_hlen_range.json     |  1 +
>>  tests/shell/testcases/import/rules_arp_htype.json  |  1 +
>>  .../testcases/import/rules_arp_operation.json      |  1 +
>>  .../import/rules_arp_operation_check.json          |  1 +
>>  .../shell/testcases/import/rules_arp_ptype_ip.json |  1 +
>>  .../shell/testcases/import/rules_bridge_vlan.json  |  1 +
>>  .../testcases/import/rules_bridge_vlan_id.json     |  1 +
>>  ...bridge_vlan_id_saddr_udp_dport_drop_domain.json |  1 +
>>  .../import/rules_ipv4_ct_state_accept.json         |  1 +
>>  .../rules_ipv4_icmp_type_echo-request_accept.json  |  1 +
>>  .../rules_ipv4_icmp_type_echo-request_counter.json |  1 +
>>  .../import/rules_ipv4_iifname_accept.json          |  1 +
>>  .../import/rules_ipv4_saddr_daddr_counter.json     |  1 +
>>  .../testcases/import/rules_ipv4_set_elements.json  |  1 +
>>  .../import/rules_ipv4_tcp_dport_http_ssh.json      |  1 +
>>  .../testcases/import/rules_ipv4_tcp_flags.json     |  1 +
>>  .../import/rules_ipv6_daddr_udp_dport_counter.json |  1 +
>>  ...es_ipv6_daddr_udp_dport_counter_masquerade.json |  1 +
>>  .../testcases/import/rules_ipv6_icmpv6_id.json     |  1 +
>>  ...iifname_ct_state_tcp_dport_vmap_masquerade.json |  1 +
>>  .../import/rules_ipv6_l4proto_tcp_masquerade.json  |  1 +
>>  ...dport_ssh_daddr_mapping_ether_saddr_accept.json |  1 +
>>  24 files changed, 140 insertions(+)
>>  create mode 100644 tests/shell/testcases/import/all_ruleset_list
>>  create mode 100755 tests/shell/testcases/import/json_import_0
>>  create mode 100644 tests/shell/testcases/import/rules_arp_hlen_range.json
>>  create mode 100644 tests/shell/testcases/import/rules_arp_htype.json
>>  create mode 100644 tests/shell/testcases/import/rules_arp_operation.json
>>  create mode 100644 tests/shell/testcases/import/rules_arp_operation_check.json
>>  create mode 100644 tests/shell/testcases/import/rules_arp_ptype_ip.json
>>  create mode 100644 tests/shell/testcases/import/rules_bridge_vlan.json
>>  create mode 100644 tests/shell/testcases/import/rules_bridge_vlan_id.json
>>  create mode 100644 tests/shell/testcases/import/rules_bridge_vlan_id_saddr_udp_dport_drop_domain.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_ct_state_accept.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_icmp_type_echo-request_accept.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_icmp_type_echo-request_counter.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_iifname_accept.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_saddr_daddr_counter.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_set_elements.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_tcp_dport_http_ssh.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv4_tcp_flags.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_daddr_udp_dport_counter.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_daddr_udp_dport_counter_masquerade.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_icmpv6_id.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_iifname_ct_state_tcp_dport_vmap_masquerade.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_l4proto_tcp_masquerade.json
>>  create mode 100644 tests/shell/testcases/import/rules_ipv6_tcp_dport_ssh_daddr_mapping_ether_saddr_accept.json
>>
>> diff --git a/tests/shell/testcases/import/all_ruleset_list b/tests/shell/testcases/import/all_ruleset_list
>> new file mode 100644
>> index 000000000000..4e25a76d8016
>> --- /dev/null
>> +++ b/tests/shell/testcases/import/all_ruleset_list
>> @@ -0,0 +1,46 @@
>> +table ip mangle {
>> +        set blackhole {
>> +                type ipv4_addr
>> +                elements = { 192.168.1.4, 192.168.1.5 }
>> +        }
>> +
>> +        chain prerouting {
>> +                type filter hook prerouting priority 0; policy accept;
>> +                tcp dport { ssh, http } accept
>> +                ip saddr @blackhole drop
>> +                icmp type echo-request accept
>> +                iifname "lo" accept
>> +                icmp type echo-request counter packets 0 bytes 0
>> +                ct state established,related accept
>> +                tcp flags != syn counter packets 7 bytes 841
>> +                ip saddr 192.168.1.100 ip daddr 192.168.1.1 counter packets 0 bytes 0
>> +        }
>> +}
>> +table arp x {
>> +        chain y {
>> +                arp htype 22
>> +                arp ptype ip
>> +                arp operation != rrequest
>> +                arp operation { request, reply, rrequest, rreply, inrequest, inreply, nak }
>> +                arp hlen 33-45
>> +        }
>> +}
>> +table bridge x {
>> +        chain y {
>> +                type filter hook input priority 0; policy accept;
>> +                vlan id 4094
>> +                vlan id 4094 vlan cfi 0
>> +                vlan id 1 ip saddr 10.0.0.0/23 udp dport domain
>> +        }
>> +}
>> +table ip6 x {
>> +        chain y {
>> +                type nat hook postrouting priority 0; policy accept;
>> +                icmpv6 id 33-45
>> +                ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0
>> +                meta l4proto tcp masquerade to :1024
>> +                iifname "wlan0" ct state established,new tcp dport vmap { ssh : drop, 222 : drop } masquerade
>> +                tcp dport ssh ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
>> +                ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0 masquerade
>> +        }
>> +}
>
> Now that we included the ruleset in the testcase itself this file is
> no longer useful?
> Please, drop it.
>
>> diff --git a/tests/shell/testcases/import/json_import_0 b/tests/shell/testcases/import/json_import_0
>> new file mode 100755
>> index 000000000000..a469a4dda754
>> --- /dev/null
>> +++ b/tests/shell/testcases/import/json_import_0
>> @@ -0,0 +1,72 @@
>> +#!/bin/bash
>> +
>> +tmpfile=$(mktemp)
>> +
>> +if [ ! -w $tmpfile ] ; then
>> +       echo "Failed to create tmp file" >&2
>> +       exit 0
>> +fi
>> +
>> +trap "rm -rf $tmpfile" EXIT # cleanup if aborted
>> +
>> +RULESET="table ip mangle {
>> +       set blackhole {
>> +               type ipv4_addr
>> +               elements = { 192.168.1.4, 192.168.1.5 }
>> +       }
>> +
>> +       chain prerouting {
>> +               type filter hook prerouting priority 0; policy accept;
>> +               tcp dport { ssh, http } accept
>> +               ip saddr @blackhole drop
>> +               icmp type echo-request accept
>> +               iifname \"lo\" accept
>> +               icmp type echo-request counter packets 0 bytes 0
>> +               ct state established,related accept
>> +               tcp flags != syn counter packets 7 bytes 841
>> +               ip saddr 192.168.1.100 ip daddr 192.168.1.1 counter packets 0 bytes 0
>> +       }
>> +}
>> +table arp x {
>> +       chain y {
>> +               arp htype 22
>> +               arp ptype ip
>> +               arp operation != rrequest
>> +               arp operation { request, reply, rrequest, rreply, inrequest, inreply, nak }
>> +               arp hlen 33-45
>> +       }
>> +}
>> +table bridge x {
>> +       chain y {
>> +               type filter hook input priority 0; policy accept;
>> +               vlan id 4094
>> +               vlan id 4094 vlan cfi 0
>> +               vlan id 1 ip saddr 10.0.0.0/23 udp dport domain
>> +       }
>> +}
>> +table ip6 x {
>> +       chain y {
>> +               type nat hook postrouting priority 0; policy accept;
>> +               icmpv6 id 33-45
>> +               ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0
>> +               meta l4proto tcp masquerade to :1024
>> +               iifname \"wlan0\" ct state established,new tcp dport vmap { ssh : drop, 222 : drop } masquerade
>> +               tcp dport ssh ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
>> +               ip6 daddr fe00::1-fe00::200 udp dport domain counter packets 0 bytes 0 masquerade
>> +       }
>> +}"
>> +
>> +echo "$RULESET" > $tmpfile
>> +$NFT -f $tmpfile
>> +$NFT export json > $tmpfile
>> +$NFT flush ruleset
>> +cat $tmpfile | $NFT import json
>> +
>> +RESULT="$($NFT list ruleset)"
>> +
>> +
>> +if [ "$RULESET" != "$RESULT" ] ; then
>> +       DIFF="$(which diff)"
>> +       [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$RESULT")
>
> exit 1 in this case?
>
>> +fi
>> +
>
>
> What is the pourpose of these json files? I guess they are no longer useful.
>
>> diff --git a/tests/shell/testcases/import/rules_arp_hlen_range.json b/tests/shell/testcases/import/rules_arp_hlen_range.json

Thanks a  lot Arturo for all these suggestions :)
