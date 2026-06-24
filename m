Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0241DFDA1
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782297856; cv=none; b=pzpGffTVAu3r7q93ArAi1AAPe9DeItz9h6Ma2uAsfyFWhhrdnPHYXzzxE6OGvhJqg6MjCAkT/9XwZ9LXcsSAt7tyI3ZEJQDcAIzTQtigor/Tc3IMyRV1NH7D8Xs5wrzcX9nqhoenPugPPxm9eAnlgDH5GQqs+IWaL62YKLakzAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782297856; c=relaxed/simple;
	bh=J2zYlNxQzpmdjZ9qbZ4ZuXmE7cLOy0Qu5cJPzx/gshs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TibhB6aBljWo3rmhx4os87Nrk1tUgscTudGwwufTnb8cqZZ7Ck09s1W5rimL4amWlu/mSkJgW3LU6OPSyckJUQ1Wr3/YnsgrdV0sIW/BEmWZhxO2iaV7dbh3MPwIeYTcBHcrGq7VtAKap7Z7qxalQQv2jJu4xCf+y/3iOIBkk4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XMU89uwO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vw4VJ394; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XMU89uwO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vw4VJ394; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XMU89uwO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vw4VJ394";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XMU89uwO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vw4VJ394"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77B826D4C5;
	Wed, 24 Jun 2026 10:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782297852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJKt+ATe7cSzccrxASfRzyjfBryJ0PV6OxRXINexJI4=;
	b=XMU89uwOlL1qyJY2dWV3ElJ2bLwasAQ/vjALz4XLy4LeKD8ChgMVan9lh1DGxkzGpAIJg5
	ajVjvkTIIS4NLjnD8mLQkZuLtvWXK6Ls3J7ZqcJ6DsudWcwH78GbeYJSyTOiUFXiBePkRa
	OgTh4fc4KVGJJsklgD+aLP8rZyYlLyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782297852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJKt+ATe7cSzccrxASfRzyjfBryJ0PV6OxRXINexJI4=;
	b=Vw4VJ394Xu4tCPb2LyUtmKvaXEGIxB9Dbr5XcpWW6jn4k5DBwaKMDkfV2iHkM+tbpQswmv
	BFfmWz+/KI6BwBBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782297852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJKt+ATe7cSzccrxASfRzyjfBryJ0PV6OxRXINexJI4=;
	b=XMU89uwOlL1qyJY2dWV3ElJ2bLwasAQ/vjALz4XLy4LeKD8ChgMVan9lh1DGxkzGpAIJg5
	ajVjvkTIIS4NLjnD8mLQkZuLtvWXK6Ls3J7ZqcJ6DsudWcwH78GbeYJSyTOiUFXiBePkRa
	OgTh4fc4KVGJJsklgD+aLP8rZyYlLyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782297852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJKt+ATe7cSzccrxASfRzyjfBryJ0PV6OxRXINexJI4=;
	b=Vw4VJ394Xu4tCPb2LyUtmKvaXEGIxB9Dbr5XcpWW6jn4k5DBwaKMDkfV2iHkM+tbpQswmv
	BFfmWz+/KI6BwBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26EC6779A8;
	Wed, 24 Jun 2026 10:44:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K954Bvy0O2rGZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 24 Jun 2026 10:44:12 +0000
Message-ID: <992feeed-cff4-4f55-a501-21521c54aaa1@suse.de>
Date: Wed, 24 Jun 2026 12:44:00 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression
 support
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>, Eric Garver <egarver@redhat.com>
References: <20250821091302.9032-1-fmancera@suse.de>
 <20250821091302.9032-3-fmancera@suse.de>
 <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
 <0f9b3772-0b38-40ae-ad3f-e2e790695054@suse.de> <ajsKozU_JZ3PQLhF@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ajsKozU_JZ3PQLhF@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

On 6/24/26 12:37 AM, Florian Westphal wrote:
> Hi Fernando
> 
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 12/29/25 2:51 PM, Yi Chen wrote:
>>> Hello Pablo and Fernando,
>>> I have started working on a test script (attached) to exercise this
>>> feature, using a geneve tunnel with an egress hook.
>>> Please let me know if egress is the correct hook to use in this context.
>>>
>>> However, the behavior is not what I expected: the tunnel template does
>>> not appear to be attached, and even ARP packets are not being
>>> encapsulated.
>>> I would appreciate any guidance on what I might be missing, or
>>> suggestions on how this test could be improved.
>>> Thank you for your time and help.
>>>
>>
>> As my patch is taking longer than expected because I am polishing all the
>> details related to the tunnel object let me explain it here briefly to
>> unblock you.
>>
>> The tunnel expression/object is used to attach tunnel metadata into a packet
>> so in essence support Lightweight Tunneling (LWT) using Nftables. The LWT
>> support is useful on virtualization environments where the users need to
>> created a lot of tunnels to interconnect containers that are inside
>> different VMs. Instead of creating one interface per container, the idea is
>> that the user can create a single one and then attach the metadata as
>> needed. Imagine the topology described below.
> 
> I'm trying to get Yi's test script to work but I am failing as well.
> AFAICS the entire feature doesn't work *by design*.
> 
>> +------------------------+                   +------------------------+
>> |--------+          VM A |                   | VM B          +--------|
>> |Box     | +------+ +---+|(192.168.124.49)   +----+ +------+ |Box     |
>> |10.0.0.1|-|vxlan0|-|eth0|-------------------|eth0|-|vxlan0|-|10.0.0.2|
>> |--------+ +------+ +---+|  (192.168.124.134)+----+ +------+ +--------|
>> |                        |                   |                        |
>> |                        |                   |                        |
>> +------------------------+                   +------------------------+
> 
> How do I read this diagram?
> Are these 4 computers or 2?
> What is "Box" ? Is that a container inside of VM A / B ?
> And if so, how does it connect to VM A?  veth?  The diagram reads like
> its a container connected to VM A via a vxlan tunnel...
> 
> Which makes no sense to me.
> 
>> We want to reach 10.0.0.2 from 10.0.0.1, the nftables ruleset on VM A will
>> look like this:
>>
>> ```
>> table netdev filter_tunnel {
>> 	tunnel vxlan_tmpl {
>> 		id 100
>> 		ip saddr 192.168.124.49
>> 		ip daddr 192.168.124.134
>> 		dport 8472
>> 		ttl 255
>> 		vxlan {
>> 			gbp 100
>> 		}
>> 	}
>>
>> 	chain redirect_to_tunnel {
>> 		type filter hook ingress device "veth_host" priority filter; policy
>> accept;
>> 		ip daddr 10.0.0.2 tunnel name "vxlan_tmpl" fwd to "vxlan0"
>> 	}
>>
>> 	chain redirect_from_tunnel {
>> 		type filter hook ingress device "vxlan0" priority filter; policy accept;
>> 		ip daddr 10.0.0.1 fwd to "veth_host"
> 
> How can this work?  I tried to get this to run but *ingress* sees no
> packets.  Which is not surprising to me, as packets are *egressing* from
> VM A, not coming in.
> 
> The only way that I can get it to work is via normal tunnel device +
> routes, no nftables rules needed.
> 
> Can you make a test script for packetpath?
> Or add documentation that explains how to use this feature?
> 

I am contributing this upstream but this is in essence the simplest 
example I could find. I have adapted another script I used to test this. 
I shared that other script with Yi. But that one requires 2 VMs and some 
other stuff, so let's keep it simple.

New diagram:

OVERLAY (The Virtual Network)
=============================
     [ ns1: 10.0.0.1 ]     [ ns2: 10.0.0.2 ]     [ ns3: 10.0.0.3 ]
            |                      |                     |
         (vxlan0)               (vxlan0)              (vxlan0)
            |                      |                     |
    ~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~
            |                 nftables                   |
            |         (attaches the Underlay IP)         |
    ~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~
            |                      |                     |
     [ 192.168.1.1 ]       [ 192.168.1.2 ]       [ 192.168.1.3 ]
            |                      |                     |
            +------------------[ Bridge ]----------------+
===============================
UNDERLAY (The Physical Network)

Once running the script attached below, you should have 3 namespaces 
connected to each other through a linux bridge and veths. Then, each of 
them has a VXLAN interface that allows them to reach other over the 
overlay network (10.0.0.0/24).

Why is this relevant? Well, usually, one would need one device per 
remote and also one route for each. Here we use a single device for all 
the endpoints.

After running the script, you should be able to do:

sudo ip netns exec ns1 ping 10.0.0.2
sudo ip netns exec ns1 ping 10.0.0.3

Please, if it doesn't work for you or something is off, let me know. I 
have an environment using this feature so it should work.

Thanks,
Fernando.


#!/bin/bash

ip netns del ns1 2>/dev/null || true
ip netns del ns2 2>/dev/null || true
ip netns del ns3 2>/dev/null || true
ip netns del sw  2>/dev/null || true

ip netns add ns1
ip netns add ns2
ip netns add ns3
ip netns add sw

ip -n sw link add br0 type bridge
ip -n sw link set br0 up

for i in 1 2 3; do
     # create the link and move ends to appropriate namespaces
     ip link add veth$i type veth peer name veth${i}_sw netns sw
     ip link set veth$i netns ns$i

     # linux bridge (switch)
     ip -n sw link set veth${i}_sw master br0 up

     # configure the node side
     ip -n ns$i addr add 192.168.1.$i/24 dev veth$i
     ip -n ns$i link set veth$i up
     ip -n ns$i link set lo up

     # create the Overlay VXLAN interface
     ip -n ns$i link add vxlan0 type vxlan dstport 4789 external
     ip -n ns$i addr add 10.0.0.$i/24 dev vxlan0
     ip -n ns$i link set vxlan0 up

     # route the ENTIRE overlay subnet into the single VXLAN device
     ip -n ns$i route add 10.0.0.0/24 dev vxlan0
done

# Node 1
ip netns exec ns1 nft -f - <<EOF
table netdev my_overlay {
     tunnel tun_to_ns2 { id 100; ip saddr 192.168.1.1; ip daddr 
192.168.1.2; }
     tunnel tun_to_ns3 { id 100; ip saddr 192.168.1.1; ip daddr 
192.168.1.3; }

     chain egress_filter {
         type filter hook egress device "vxlan0" priority 0; policy accept;

         # IPv4 Traffic
         ip daddr 10.0.0.2 tunnel name "tun_to_ns2"
         ip daddr 10.0.0.3 tunnel name "tun_to_ns3"

         # ARP Traffic (Unicasting ARP directly to the correct node)
         arp daddr ip 10.0.0.2 tunnel name "tun_to_ns2"
         arp daddr ip 10.0.0.3 tunnel name "tun_to_ns3"
     }
}
EOF

# Node 2
ip netns exec ns2 nft -f - <<EOF
table netdev my_overlay {
     tunnel tun_to_ns1 { id 100; ip saddr 192.168.1.2; ip daddr 
192.168.1.1; }
     tunnel tun_to_ns3 { id 100; ip saddr 192.168.1.2; ip daddr 
192.168.1.3; }

     chain egress_filter {
         type filter hook egress device "vxlan0" priority 0; policy accept;

         ip daddr 10.0.0.1 tunnel name "tun_to_ns1"
         ip daddr 10.0.0.3 tunnel name "tun_to_ns3"

         arp daddr ip 10.0.0.1 tunnel name "tun_to_ns1"
         arp daddr ip 10.0.0.3 tunnel name "tun_to_ns3"
     }
}
EOF

# Node 3
ip netns exec ns3 nft -f - <<EOF
table netdev my_overlay {
     tunnel tun_to_ns1 { id 100; ip saddr 192.168.1.3; ip daddr 
192.168.1.1; }
     tunnel tun_to_ns2 { id 100; ip saddr 192.168.1.3; ip daddr 
192.168.1.2; }

     chain egress_filter {
         type filter hook egress device "vxlan0" priority 0; policy accept;

         ip daddr 10.0.0.1 tunnel name "tun_to_ns1"
         ip daddr 10.0.0.2 tunnel name "tun_to_ns2"

         arp daddr ip 10.0.0.1 tunnel name "tun_to_ns1"
         arp daddr ip 10.0.0.2 tunnel name "tun_to_ns2"
     }
}
EOF
