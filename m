Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CBEC3DA7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Jan 2023 08:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjAEI4c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 03:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjAEI4b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 03:56:31 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748E6101CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2023 00:56:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 31D3B604F1;
        Thu,  5 Jan 2023 09:56:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672908987; bh=a7N595rbgmZx5GOv6f0QRkflqUby1dT+jlsG91P5DSQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=H3xPK5Cj5Tfbw+I0E6p/hSoRHSX8vbGL+zuwDDYO6rqUvTPMGNLmCpxp0rLtui/IN
         r2y4NydcDZDZjpLp0OViiN9PPECJIjYyWrv2Ni6FoHdEf10QvMxhdqEh75DxAwnI04
         q4yjM9Cjm4g9/s3y4nDGIzOUnj40uqb9w2kWTE4wExVWpQJlY4ffG0xcovc+atGYMX
         8z7PUSMKu73X5kWNAocSlNRriqRiVQdToHM6RKupunQ3En/JCCf4fVS5DWXlBKNSew
         u9Z3DJNvmLWdz1PDtEMHfRXWoLJrKlBttFJcH2VPY+V09CXIsmVHxrPxlTRdwgXTDh
         aTtQNu2jSutsQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id buEZ64gepKCy; Thu,  5 Jan 2023 09:56:24 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 3E20A604F0;
        Thu,  5 Jan 2023 09:56:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672908984; bh=a7N595rbgmZx5GOv6f0QRkflqUby1dT+jlsG91P5DSQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=lSE4V7OmXget9nfwFZuAwzjjvXB+MWYFXnMcdLzJvwbrSUSrcpodMYBYFFVV1rmfe
         NxCCu29bE7I407QTB7ZEiTHf8uHo4AaTGJdBvuzeQ7U9kPKh8aKZ29qkYzUp/aphta
         L2SAmpREeOHn0k6bHFOYFI+x5GaCKONCUIryUakGgM1EqvfVPtmwH04d8QvfdBstoI
         qW4BEVOCl3MLtaYS2wQTY0fHu4mA5Jw7c3Ku2V4q9lgbKBGRlpTRz9iwgZ5YEr21s3
         XoIUNVBycbqfaW8B/t06vC24DDofjHPPghrxUKfTjAPSya7beLstipGjdqQHBRwWvd
         mkKejUrrvxwMQ==
Message-ID: <f528205d-d8ad-c34b-774e-c5405f099b09@alu.unizg.hr>
Date:   Thu, 5 Jan 2023 09:56:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH nf] selftests: netfilter: fix transaction test script
 timeout handling
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20230104115442.2427-1-fw@strlen.de>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230104115442.2427-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 04. 01. 2023. 12:54, Florian Westphal wrote:
> The kselftest framework uses a default timeout of 45 seconds for
> all test scripts.
> 
> Increase the timeout to two minutes for the netfilter tests, this
> should hopefully be enough,
> 
> Make sure that, should the script be canceled, the net namespace and
> the spawned ping instances are removed.
> 
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   .../selftests/netfilter/nft_trans_stress.sh      | 16 +++++++++-------
>   tools/testing/selftests/netfilter/settings       |  1 +
>   2 files changed, 10 insertions(+), 7 deletions(-)
>   create mode 100644 tools/testing/selftests/netfilter/settings
> 
> diff --git a/tools/testing/selftests/netfilter/nft_trans_stress.sh b/tools/testing/selftests/netfilter/nft_trans_stress.sh
> index a7f62ad4f661..2ffba45a78bf 100755
> --- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
> +++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
> @@ -10,12 +10,20 @@
>   ksft_skip=4
>   
>   testns=testns-$(mktemp -u "XXXXXXXX")
> +tmp=""
>   
>   tables="foo bar baz quux"
>   global_ret=0
>   eret=0
>   lret=0
>   
> +cleanup() {
> +	ip netns pids "$testns" | xargs kill 2>/dev/null
> +	ip netns del "$testns"
> +
> +	rm -f "$tmp"
> +}
> +
>   check_result()
>   {
>   	local r=$1
> @@ -43,6 +51,7 @@ if [ $? -ne 0 ];then
>   	exit $ksft_skip
>   fi
>   
> +trap cleanup EXIT
>   tmp=$(mktemp)
>   
>   for table in $tables; do
> @@ -139,11 +148,4 @@ done
>   
>   check_result $lret "add/delete with nftrace enabled"
>   
> -pkill -9 ping
> -
> -wait
> -
> -rm -f "$tmp"
> -ip netns del "$testns"
> -
>   exit $global_ret
> diff --git a/tools/testing/selftests/netfilter/settings b/tools/testing/selftests/netfilter/settings
> new file mode 100644
> index 000000000000..6091b45d226b
> --- /dev/null
> +++ b/tools/testing/selftests/netfilter/settings
> @@ -0,0 +1 @@
> +timeout=120

Hi,

I've tested the patch last night and the problem appears absent.

Here is the excerpt with the subsystem selftest:

make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/netfilter'
TAP version 13
1..17
# selftests: netfilter: nft_trans_stress.sh
# PASS: nft add/delete test returned 0
# PASS: nft reload test returned 0
# PASS: nft add/delete with nftrace enabled test returned 0
# PASS: nft add/delete with nftrace enabled test returned 0
ok 1 selftests: netfilter: nft_trans_stress.sh
# selftests: netfilter: nft_fib.sh
# PASS: fib expression did not cause unwanted packet drops
# PASS: fib expression did drop packets for 1.1.1.1
# PASS: fib expression did drop packets for 1c3::c01d
# PASS: fib expression forward check with policy based routing
ok 2 selftests: netfilter: nft_fib.sh
# selftests: netfilter: nft_nat.sh
# PASS: netns routing/connectivity: ns0-p9jnhWY0 can reach ns1-p9jnhWY0 and ns2-p9jnhWY0
# PASS: ping to ns1-p9jnhWY0 was ip NATted to ns2-p9jnhWY0
# PASS: ping to ns1-p9jnhWY0 OK after ip nat output chain flush
# PASS: ipv6 ping to ns1-p9jnhWY0 was ip6 NATted to ns2-p9jnhWY0
# timeout: failed to run command ‘socat’: No such file or directory
# timeout: failed to run command ‘socat’: No such file or directory
# ERROR: inet port rewrite
# PASS: ping to ns1-p9jnhWY0 was inet NATted to ns2-p9jnhWY0
# PASS: ping to ns1-p9jnhWY0 OK after inet nat output chain flush
# PASS: ipv6 ping to ns1-p9jnhWY0 was inet NATted to ns2-p9jnhWY0
# PASS: ip IP masquerade  for ns2-p9jnhWY0
# PASS: ip6 IPv6 masquerade  for ns2-p9jnhWY0
# PASS: inet IP masquerade  for ns2-p9jnhWY0
# PASS: inet IPv6 masquerade  for ns2-p9jnhWY0
# PASS: ip IP masquerade fully-random for ns2-p9jnhWY0
# PASS: ip6 IPv6 masquerade fully-random for ns2-p9jnhWY0
# PASS: inet IP masquerade fully-random for ns2-p9jnhWY0
# PASS: inet IPv6 masquerade fully-random for ns2-p9jnhWY0
# PASS: ip IP redirection for ns2-p9jnhWY0
# PASS: ip6 IPv6 redirection for ns2-p9jnhWY0
# PASS: inet IP redirection for ns2-p9jnhWY0
# PASS: inet IPv6 redirection for ns2-p9jnhWY0
# SKIP: Could not run nat port shadowing test without conntrack tool
# SKIP: Could not run stateless nat frag test without socat tool
# FAIL: nftables v1.0.5 (Lester Gooch #4)
not ok 3 selftests: netfilter: nft_nat.sh # exit=1
# selftests: netfilter: bridge_brouter.sh
# PASS: netns connectivity: ns1 and ns2 can reach each other
# ebtables: No chain/target/match by that name
# SKIP: Could not add ebtables broute redirect rule
ok 4 selftests: netfilter: bridge_brouter.sh # SKIP
# selftests: netfilter: conntrack_icmp_related.sh
# PASS: icmp mtu error had RELATED state
# PASS: icmp redirects had RELATED state
ok 5 selftests: netfilter: conntrack_icmp_related.sh
# selftests: netfilter: nft_flowtable.sh
# PASS: netns routing/connectivity: ns1-rSpoqhm9 can reach ns2-rSpoqhm9
# PASS: flow offloaded for ns1/ns2
# PASS: flow offload for ns1/ns2 with masquerade
# PASS: flow offload for ns1/ns2 with dnat ns1 <- ns2
# PASS: flow offload for ns1/ns2 with masquerade and pmtu discovery
# PASS: flow offload for ns1/ns2 with dnat and pmtu discovery ns1 <- ns2
# PASS: flow offload for ns1/ns2 with masquerade and pmtu discovery on bridge
# PASS: flow offload for ns1/ns2 with dnat and pmtu discovery ns1 <- ns2
# PASS: flow offload for ns1/ns2 with masquerade and pmtu discovery bridge and VLAN
# PASS: flow offload for ns1/ns2 with dnat and pmtu discovery ns1 <- ns2
# PASS: ipsec tunnel mode for ns1/ns2
ok 6 selftests: netfilter: nft_flowtable.sh
# selftests: netfilter: ipvs.sh
# SKIP: Could not run test without ipvsadm
ok 7 selftests: netfilter: ipvs.sh # SKIP
# selftests: netfilter: nft_concat_range.sh
# TEST: reported issues
#   Add two elements, flush, re-add                               [ OK ]
#   net,mac with reload                                           [FAIL]
# udp packet to:
#   10.0.0.6
# from:
#   00:01:00:00:07:d1
# should have matched ruleset:
# table inet filter { # handle 2
#       counter test { # handle 2
#               packets 0 bytes 0
#       }
#
#       set test { # handle 3
#               type ipv4_addr . ether_addr
#               flags interval,timeout
#               elements = { 10.0.0.6/31 . 00:01:00:00:07:d1-00:01:00:00:07:d2,
#                            10.0.0.9-10.0.0.11 . 00:01:00:00:07:d4-00:01:00:00:07:d6 }
#       }
#
#       chain input { # handle 1
#               type filter hook prerouting priority filter; policy accept;
#               ip daddr . ether saddr @test counter name "test" # handle 4
#       }
# }
# table netdev perf { # handle 3
#       counter test { # handle 2
#               packets 0 bytes 0
#       }
#
#       counter match { # handle 3
#               packets 0 bytes 0
#       }
#
#       set test { # handle 4
#               type ipv4_addr . ether_addr
#               flags interval
#       }
#
#       set norange { # handle 5
#               type ipv4_addr . ether_addr
#       }
#
#       set noconcat { # handle 6
#               type ipv4_addr
#               flags interval
#       }
#
#       chain test { # handle 1
#               type filter hook ingress device "veth_a" priority filter; policy accept;
#       }
# }
not ok 8 selftests: netfilter: nft_concat_range.sh # exit=1
# selftests: netfilter: nft_conntrack_helper.sh
# SKIP: Could not run test without conntrack tool
ok 9 selftests: netfilter: nft_conntrack_helper.sh # SKIP
# selftests: netfilter: nft_queue.sh
# PASS: ns1-6q0Kh3hs can reach ns2-6q0Kh3hs
# PASS: ip: statement with no listener results in packet drop
# PASS: ip6: statement with no listener results in packet drop
# PASS: Expected and received 10 packets total
# PASS: Expected and received 20 packets total
# PASS: tcp and nfqueue in forward chain
# PASS: tcp via loopback
# PASS: tcp via loopback with connect/close
# PASS: tcp via loopback and re-queueing
# PASS: icmp+nfqueue via vrf
ok 10 selftests: netfilter: nft_queue.sh
# selftests: netfilter: nft_meta.sh
# OK: nftables meta iif/oif counters at expected values
# OK: nftables meta cpu counter at expected values
ok 11 selftests: netfilter: nft_meta.sh
# selftests: netfilter: nf_nat_edemux.sh
# SKIP: Could not run test without iperf3
ok 12 selftests: netfilter: nf_nat_edemux.sh # SKIP
# selftests: netfilter: ipip-conntrack-mtu.sh
# SKIP: Could not run test without socat
ok 13 selftests: netfilter: ipip-conntrack-mtu.sh # SKIP
# selftests: netfilter: conntrack_tcp_unreplied.sh
# INFO: connect ns1-oDzqGeK9 -> ns2-oDzqGeK9 to the virtual ip
# ERROR: ns2-oDzqGeK9 did not pick up tcp connection from peer
not ok 14 selftests: netfilter: conntrack_tcp_unreplied.sh # exit=1
# selftests: netfilter: conntrack_vrf.sh
# FAIL: entry not found in conntrack zone 1
# FAIL: entry not in zone 1 or 2, dumping table
# exec of "conntrack" failed: No such file or directory
# table ip testct {
#       chain rawpre {
#               type filter hook prerouting priority raw; policy accept;
#               iif { "veth0", "tvrf" } counter packets 2 bytes 168 meta nftrace set 1
#               iif "veth0" counter packets 1 bytes 84 ct zone set 1 counter packets 1 bytes 84 return
#               iif "tvrf" counter packets 1 bytes 84 ct zone set 2 counter packets 1 bytes 84 return
#               ip protocol icmp counter packets 0 bytes 0
#               notrack counter packets 0 bytes 0
#       }
#
#       chain rawout {
#               type filter hook output priority raw; policy accept;
#               oif "veth0" counter packets 1 bytes 84 ct zone set 1 counter packets 1 bytes 84 return
#               oif "tvrf" counter packets 1 bytes 84 ct zone set 2 counter packets 1 bytes 84 return
#               notrack counter packets 0 bytes 0
#       }
# }
# exec of "iperf3" failed: No such file or directory
# FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device
# exec of "iperf3" failed: No such file or directory
# FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device
# exec of "iperf3" failed: No such file or directory
# FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device
not ok 15 selftests: netfilter: conntrack_vrf.sh # exit=1
# selftests: netfilter: nft_synproxy.sh
# SKIP: Could not run test without iperf3
ok 16 selftests: netfilter: nft_synproxy.sh # SKIP
# selftests: netfilter: rpath.sh
# PASS: netfilter reverse path match works as intended
ok 17 selftests: netfilter: rpath.sh
make[2]: Leaving directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/netfilter'

Thank you for addressing this problem with your patch at such a short notice.

Have a nice day, and a Happy New Year :)

Kind regards,
Mirsad

--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
-- 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

