Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2CEC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 06:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D522082F
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 06:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfKSGkM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:40:12 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:53671 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKSGkM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 01:40:12 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id EA69041A59;
        Tue, 19 Nov 2019 14:40:07 +0800 (CST)
Subject: Re: [PATCH nf-next 0/4] netfilter: nf_flow_table_offload: support
 tunnel match
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
 <20191115214827.lyu35l2y3nqusplh@salvia>
 <eb382034-7462-ef2c-4b76-518c488771f8@ucloud.cn>
 <20191118215950.5xm6om55dd3krexs@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <5c5df191-732d-84d1-0d85-8d1918af7467@ucloud.cn>
Date:   Tue, 19 Nov 2019 14:40:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118215950.5xm6om55dd3krexs@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUhIS0tLSk5CSU1ITUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODo6KQw5Tzg6LQkxQk0UNhwe
        MC9PCjVVSlVKTkxPSk9OTUtDSU1KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTk9JQzcG
X-HM-Tid: 0a6e8263c9da2086kuqyea69041a59
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 11/19/2019 5:59 AM, Pablo Neira Ayuso wrote:
> On Sat, Nov 16, 2019 at 04:06:02PM +0800, wenxu wrote:
>> 在 2019/11/16 5:48, Pablo Neira Ayuso 写道:
>>> On Fri, Nov 15, 2019 at 08:03:26PM +0800, wenxu@ucloud.cn wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> This patch provide tunnel offload based on route lwtunnel. 
>>>> The first two patches support indr callback setup
>>>> Then add tunnel match and action offload
>>> Could you provide a configuration script for this tunnel setup?
>>>
>>> Thanks.
>> The following is a simple configure for tunnel offload forward
>>
>>
>> ip link add dev gre_sys type gretap key 1000
>>
>> ip link add user1 type vrf table 1
>>
>> ip l set dev gre1000 master user1
>>
>> ip l set dev vf master user1
>>
>> ip r a 10.0.0.7 dev vf table 1
>> ip r a default via 10.0.0.100 encap ip id 1000 dst 172.168.0.7 key dev gre1000 table 1 onlink
>>
>> nft add flowtable firewall fb1 { hook ingress priority 0 \;  flags offload \; devices = { gre1000, vf } \; }
> Thanks for describing, but how does this work in software?
>
> I'd appreciate if you can describe a configuration in software (no
> offload) that I can use here for testing, including how you're
> generating traffic there for testing.

There is the whole test script for software only. flowtable offload is

already can work with vrf.


ip netns add ns1
ip netns add cl
ip l add dev veth1 type veth peer name eth0 netns ns1
ip l add dev vethc type veth peer name eth0 netns cl
ip netns exec ns1 ifconfig eth0 10.0.0.7/24 up
ip netns exec ns1 ip r add default via 10.0.0.1

ifconfig vethc 172.168.0.7/24 up
ip l add dev tun1 type gretap external

ip netns exec cl ifconfig eth0 172.168.0.17/24 up
ip netns exec cl ip l add dev tun type gretap local 172.168.0.17 remote 172.168.0.7 key 1000
ip netns exec cl ifconfig tun 10.0.1.7/24 up
ip netns exec cl ip r add default via 10.0.1.1

ip link add user1 type vrf table 1
ip l set user1 up
ip l set dev tun1 master user1
ifconfig veth1 down
ip l set dev veth1 master user1
ifconfig veth1 10.0.0.1/24 up
ifconfig tun1 10.0.1.1/24 up

ip r r 10.0.0.7 dev veth1 table 1
ip r r 10.0.1.7 encap ip id 1000 dst 172.168.0.17 key dev tun1 table 1

nft add table firewall
nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "veth1" : 1 }
nft add chain firewall rule-1000-ingress
nft add rule firewall rule-1000-ingress ct zone 1 ct state established,related counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ct state invalid counter drop
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 5001 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ip protocol icmp ct state new counter accept
nft add rule firewall rule-1000-ingress counter drop
nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
nft add rule firewall rules-all meta iifkind "vrf" counter accept
nft add rule firewall rules-all iif vmap { "tun1" : jump rule-1000-ingress }

nft add flowtable firewall fb1 { hook ingress priority 0 \; devices = { veth1, tun1 } \; }
nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1



you can test it with

ip netns exec ns1 exec iperf -s

ip netns exec ns1 exec iperf -c 10.0.0.7 -t 100 -i 2


cat /proc/net/nf_conntrack | grep zone=1
ipv4     2 tcp      6 src=10.0.1.7 dst=10.0.0.7 sport=56290 dport=5001 src=10.0.0.7 dst=10.0.1.7 sport=5001 dport=56290 [OFFLOAD] mark=0 zone=1 use=3


Ps:  there are some tricks. It is better the tun1 as "ip l add dev tun1 type gretap key 1000"

but not " ip l add dev tun1 type gretap external"

But the specific key id gretap when receive the packet will not push up the tun_info which will lead arp response

with no tun_info

I will post a patch to support this in gre.





>
