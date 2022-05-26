Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C911EC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 06:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiEZGdm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 02:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiEZGdm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 02:33:42 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC100BDA3B
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 23:33:36 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:47760.1627341664
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id D408C2800C3;
        Thu, 26 May 2022 14:33:31 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 43c3a7a024ae408d8bf4de1a86b15086 for netfilter-devel@vger.kernel.org;
        Thu, 26 May 2022 14:33:32 CST
X-Transaction-ID: 43c3a7a024ae408d8bf4de1a86b15086
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Subject: Re: [PATCH nf-next v2] selftests: netfilter: flowtable vlan filtering
 bridge support
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1653467894-5724-1-git-send-email-wenxu@chinatelecom.cn>
From:   wenxu <wenxu@chinatelecom.cn>
Message-ID: <f55b177c-3243-f6b4-9e37-383121cec066@chinatelecom.cn>
Date:   Thu, 26 May 2022 14:33:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1653467894-5724-1-git-send-email-wenxu@chinatelecom.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


Please drop this first. This test case should base on the vlan encap 
offload feature


BR

wenxu

ÔÚ 2022/5/25 16:38, wenxu@chinatelecom.cn Ð´µÀ:
> From: wenxu <wenxu@chinatelecom.cn>
>
> Add vlan_filtering enabled bridge and vlan case.
> Add a vlan_filtering bridge device to the Router1 (nsr1) container
> and attach the veth0 device to the bridge. Set the IP address to
> the bridge device to exercise the bridge forwarding path.
> The veth0 add in the vlan 10 domain and the br0 also add in the
> vlan 10 domain with untaged.
>
> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
> ---
> v2: fix set up the br0
>      change iif br0 to iifname br0 for br0 destroy
>      All the test PASS
>   
>   tools/testing/selftests/netfilter/nft_flowtable.sh | 28 +++++++++++++++++++---
>   1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
> index d4ffebb..13e03e3 100755
> --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> @@ -37,6 +37,7 @@ checktool "nft --version" "run test without nft tool"
>   checktool "ip -Version" "run test without ip tool"
>   checktool "which nc" "run test without nc (netcat)"
>   checktool "ip netns add nsr1" "create net namespace"
> +checktool "bridge -Version" "run test without bridge tool"
>   
>   ip netns add ns1
>   ip netns add ns2
> @@ -388,7 +389,7 @@ flush table ip nat
>   table ip nat {
>      chain prerouting {
>         type nat hook prerouting priority 0; policy accept;
> -      meta iif "br0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
> +      meta iifname "br0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
>      }
>   
>      chain postrouting {
> @@ -431,12 +432,33 @@ else
>   	ret=1
>   fi
>   
> -# restore test topology (remove bridge and VLAN)
> -ip -net nsr1 link set veth0 nomaster
> +# Another test:
> +# Add vlan filtering bridge interface br0 to Router1, with NAT and VLAN.
> +ip -net nsr1 link set veth0.10 nomaster
>   ip -net nsr1 link set veth0 down
>   ip -net nsr1 link set veth0.10 down
>   ip -net nsr1 link delete veth0.10 type vlan
>   ip -net nsr1 link delete br0 type bridge
> +ip -net nsr1 link add name br0 type bridge vlan_filtering 1
> +ip -net nsr1 link set up dev veth0
> +ip -net nsr1 link set veth0 master br0
> +ip -net nsr1 link set up dev br0
> +ip -net nsr1 addr add 10.0.1.1/24 dev br0
> +bridge -n nsr1 vlan add dev veth0 vid 10 pvid
> +bridge -n nsr1 vlan add dev br0 vid 10 pvid untagged self
> +
> +if test_tcp_forwarding_nat ns1 ns2; then
> +	echo "PASS: flow offloaded for ns1/ns2 with vlan filtering bridge NAT and VLAN"
> +else
> +	echo "FAIL: flow offload for ns1/ns2 with vlan filtering bridge NAT and VLAN" 1>&2
> +	ip netns exec nsr1 nft list ruleset
> +	ret=1
> +fi
> +
> +# restore test topology (remove bridge and VLAN)
> +ip -net nsr1 link set veth0 nomaster
> +ip -net nsr1 link set veth0 down
> +ip -net nsr1 link delete br0 type bridge
>   ip -net ns1 addr flush dev eth0.10
>   ip -net ns1 link set eth0.10 down
>   ip -net ns1 link set eth0 down
