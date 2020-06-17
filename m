Return-Path: <SRS0=x4zc=76=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413FAC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 23:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212FE21534
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 23:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgFQXgR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 19:36:17 -0400
Received: from mail.thelounge.net ([91.118.73.15]:18835 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgFQXgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 19:36:17 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49nLzz2rNTzXSh;
        Thu, 18 Jun 2020 01:36:10 +0200 (CEST)
Subject: Re: ipset restore for bitmap:port terrible slow
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <ffe689dd-63d8-1b8f-42f2-20c875d124b6@thelounge.net>
 <alpine.DEB.2.22.394.2006172102360.27120@blackhole.kfki.hu>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <5db535e7-c418-1c6b-f511-f7d0d8bc04ac@thelounge.net>
Date:   Thu, 18 Jun 2020 01:36:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2006172102360.27120@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 17.06.20 um 21:06 schrieb Jozsef Kadlecsik:
> On Wed, 17 Jun 2020, Reindl Harald wrote:
> 
>> the restore of a "bitmap:port" ipset with a lot of entries is *terrible* 
>> slow, when you add a port-range like 42000–42999 it ends in 999 "add 
>> PORTS_RESTRICTED" lines in the save-file and restore takes virtually 
>> ages
>>
>> the cpu-time below is the whole systemd-unit which restores iptables, 
>> ipset and configures the network with 3 nics, a bridge and wireguard
>>
>> why is this *that much* inefficient given that the original command with
>> port ranges returns instantly?
>>
>> on a datacenter firewall that makes the difference of 5 seconds or 15
>> seconds downtime at reboot
>> ---------------------------
>>
>> Name: PORTS_RESTRICTED
>> Type: bitmap:port
>> Header: range 1-55000
>>
>> ---------------------------
>>
>> /usr/sbin/ipset -file /etc/sysconfig/ipset restore
>>
>> CPU: 9.594s - Number of entries: 5192
>> CPU: 6.246s - Number of entries: 3192
>> CPU: 1.511s - Number of entries: 53
>>
>> ---------------------------
> 
> I cannot reproduce the issue. What is your ipset version (both userspace 
> tool and kernel modules)?

5.7.0-1.fc33.x86_64
ipset-7.5-1.fc31.x86_64

it's practically the same with 5.6.18 and i found it out by luck what
ruined my boot times that much because i saved the one with 5192 empty

>> 42000–42999 looks in /etc/sysconfig/ipset like below and frankly either
>> that can be speeded up or should be saved as ranges wherever it's
>> possible like hash:net prefers cidr
> 
> The bitmap port type does not support ranges, just individual port 
> elements. 

but it does support when you want to add 42000–42999 on the cli and that
works way faster than restore at reboot

if one could restore just the ipset definitions so that you can load the
iptables ruleset and after that load the values would improve the
situation dramatically given that 99% of the ruleset works with empty
ipsets good enough for some seconds

> In my test restoring a set with 10000 elements took less than 1s

well, that's a nested VMware ESXi within Vmware Workstation where many
things are more expensive

but 9 seconds on a single vcore to restore ipset, iptables, create a
brdige and assign two interfaces to it with a few ethtool commands on
the production vm with Intel(R) Xeon(R) Gold 6128 CPU @ 3.40GHz is still
terrible given that the machine don't do anything else

i remember times where i lost 4 ping packets to the machines behind the
firewall but than i added a lot of ports to some ipsets

[root@firewall:~]$  systemd-analyze blame
9.601s network-up.service
