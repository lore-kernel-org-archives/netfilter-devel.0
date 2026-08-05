Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D373E5598
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785920595; cv=none; b=t/drcfwwEsDG4M6mXN1M1MN/V9/n20/5liEgZghUaN0kcaQJsViaIINR6t81MXUCdlFU6H+s0bEBQ4jlmK63bQWu/suU+3w2ywqmzrELOX+47a+INVZ+hbT6j2++TaNp+APyh/Appo9yzfTXjsZ833fPzClIcuRwKeLza+2LihA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785920595; c=relaxed/simple;
	bh=3okNddUNMMKJLxYEvGq4To4XewtsNzzsNOGi+EcxEJM=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=N20Gozp8aEjWtRThQ1iXl/qmNjneAAmktFBl3Xg2sRiLCt52f2ClZ3L3DIFKPb5Zgz1/udvu9GRticiM4ucvpyYJXpQIf8qahJyY2XsdJ5cvXBE3peJ3RcHZXO0naakc/JvAQvSo9jgRk0gMn1eZdy4tYfljok6g4G+UFUJZUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6U0eF5J; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6U0eF5J"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fd4531020so425600f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2026 02:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785920592; x=1786525392; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tCjs3K798zUAHJS4Im4IiN0IAqAb0cx8X6grJLzTFKg=;
        b=O6U0eF5JiVZ2usxoeGpE+FavXe3+gM3xAxS9XEuVBKdKYAj8mBroWXzVEOVcZXKdNw
         c3ZBoFvecYSlurRptz+fJjDyxe9VRFiYPr6Yad18BL4Hr4E86iG2v6Sn6Oq2EspN3eOE
         m9LrEppzXEZGw/S0yuDR8PkyXHNdWidK3xZP6E7hSnfgq71poKObjHVanmNuzeCi7IqW
         4tlD+qsVA4vk86hSNyuxlW/5hC1zvM6ixJnLXnHqdx67mlYcd6sZ8XhyM9vfAF84cNYD
         DAfzmgX2iN104EzDBCYxMQvgVpfslQTwwRBHAr1jPJS/oBkEKUuy/k1IAvYtCQttHAAu
         6oxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785920592; x=1786525392;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tCjs3K798zUAHJS4Im4IiN0IAqAb0cx8X6grJLzTFKg=;
        b=tEafIwtie1MtLIrKlqUvZTusLcKRFa29Jykmrl+sxySTPTURlcG48PHWEumLCdciyc
         LePXqRgv8tylGPThqcC9hjNkbMShhcnX5jZjDQPShPwwbAbcoE9KuOGROlaoYDgqLn0f
         tQ9WLrhQ9iEpH9lt1ugOuCekSE7xutOn6xplH46Vfjn1QqUcn8Kad9d6xV3sHpLmFozT
         h7N2EHv2TguL7Rdb4CoY4ivm3wP7/gA27nA2GhotK+lBPrR2gbBDpH2YwjRrkjsOEPB6
         AqUTzXRphddK3i3qjt0yBo+kvDvcUIGkH4kiQv0xn3+wX8/9obFsUGGpp2Lor20BnOA3
         k49w==
X-Forwarded-Encrypted: i=1; AHgh+Rp+be2fDQ3njZTt9tv/rQItsXY6N+l68iroY3OMDSdpfFmlD5N/6yy1+4w1Ys7HVwJcio2ZL0DMB48Ldt6o9ew=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXkYqImmnKLehluoJlincbKCE35bSQMM+R1EjcOYUzy+i1n0kw
	YN5CrKrqu71q8537++X+TEUYcQTFkstrtFu7PfXwxL3Nis44W4IoLIy/
X-Gm-Gg: AR+sD10WWM2zPl4jYXln8SRkxt1z1B15VgeBpOJ+mfhSZuPUnk+2gHthHWKt8xTxwgT
	P782Uq+QXwWb5QfvZUw5buB7EdaKu92KoYT0CPO6ALSA1SWHbZW4e72ra4Sm3N5T4slGBBNQaU7
	5deF2AYr4zRwi0ykTR63jklv3Rr8VjTpl03qC5Pfu5J45Ytl3jsZmIYPkzdDOw7Aps/v9EF6N7A
	OlsaHXzTa3iwK5Ihv8N1fpFMKJwXI3Z+fIG03ngpmU61Ik5yrzoJnBM317izehO7TTEOdeKUs1Z
	pZjWUpotYF82rD5mjquKOIUE/U4Gdxb9t2Y6zTdtjhHCBio3sXIPP5rz9Ff02VLbKavv38U0t0h
	CeUeGy4g/tfeXctXN01gkPM2ijkmD7H5EJw45PR7/ZiELfXk3sCVKqMiGUHjWp+0N12gQ05T1ll
	lMSMSytU1o18M3b3K82KJ6lwaMWV/g9QIe7Mp+dYXKZBKMDvl1PngRUPTwxQb5nLYrohNq9wF4C
	GTf/HWlPUtDiR4JxT8siJ2xeY88+OU=
X-Received: by 2002:a05:6000:41d3:b0:45e:e1a4:c4c3 with SMTP id ffacd0b85a97d-47fec628b57mr8844522f8f.15.1785920591607;
        Wed, 05 Aug 2026 02:03:11 -0700 (PDT)
Received: from [127.0.0.1] ([193.252.113.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm7175258f8f.20.2026.08.05.02.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 02:03:10 -0700 (PDT)
From: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
X-Google-Original-From: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Message-ID: <7b7fbe75-1531-49f9-8134-033c34fa13cb@orange.com>
Date: Wed, 5 Aug 2026 11:02:48 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nf_dup_netdev: scrub duplicates to
 preserve the direct path
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
 edumazet@google.com, netdev@vger.kernel.org
References: <20260804201150.16364-1-alexandre.ferrieux@orange.com>
 <anLzQeYulW2CQItC@chamomile>
Content-Language: fr, en-US
Organization: Orange
In-Reply-To: <anLzQeYulW2CQItC@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/5/26 10:24 AM, Pablo Neira Ayuso wrote:
> Hi,
>
> On Tue, Aug 04, 2026 at 10:11:50PM +0200, Alexandre Ferrieux wrote:
>> The nftables 'dup' action clones the skb with its full glory of
>> metadata, including references to its destination and conntrack
>> information. As a consequence, a link failure on the duplicate's
>> egress path ends up doing the same as it would for the direct path,
>> for example invalidating the original packet's destination, which
>> typically breaks all TCP connections to that address.
>>
>> In other words, the "dup" path has the potential to wreak havoc
>> in the direct path as a consequence of secondary link failures. This
>> is very bad behavior for a monitoring tool, which is the most
>> obvious application of 'dup'.
>
> Can you describe your use-case a bit and how it breaks?
Sure:

 - assume hosts A.eth0 and B.eth0 have active production traffic (say TCP)
 - assume we have a monitoring tool on A that dups eth0's egress to some other
interface $MON

    nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
filter ; policy accept ; }'
    nft add rule netdev ta ch dup to $MON

 - assume something goes wrong on $MON generating link failures. In my case it
was a GRETAP with L3 destination suddenly unreachable.

 - The next A->B packet goes through normally, but its duplicate hits
ipv4_link_failure(), hence the dst (which is B) is expired.

 - As a result, (say) TCP disruptions occur. The thermometer killed the patient :)

Note: as a straightforward repro, you can simply witness "noise" in simple ping
sessions, with ghost unreach reports muxed with normal measurement:

    ip link add gre1 type gretap remote 192.168.1.99 ;# on the LAN, nonexistent
IP => will generate link failures
    ip link set dev gre1 up
    nft add table netdev ta
    nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
filter ; policy accept ; }'
    nft add rule netdev ta ch counter dup to gre1
    ping -n 8.8.8.8
 =>
    PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
    64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=19.9 ms
    64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=12.8 ms
    64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=36.0 ms
    64 bytes from 8.8.8.8: icmp_seq=4 ttl=115 time=30.3 ms
    From 192.168.1.13 icmp_seq=5 Destination Host Unreachable
    64 bytes from 8.8.8.8: icmp_seq=5 ttl=115 time=31.0 ms
    From 192.168.1.13 icmp_seq=6 Destination Host Unreachable
    64 bytes from 8.8.8.8: icmp_seq=6 ttl=115 time=38.0 ms
    From 192.168.1.13 icmp_seq=7 Destination Host Unreachable
    64 bytes from 8.8.8.8: icmp_seq=7 ttl=115 time=36.8 ms
    From 192.168.1.13 icmp_seq=8 Destination Host Unreachable
    64 bytes from 8.8.8.8: icmp_seq=8 ttl=115 time=23.5 ms
    ^C


>
>> This patch fixes all similar scenarii by calling skb_scrub_pkt()
>> on the clone, severing its link to precious direct-path state.
>
> This patch is targetted at the net tree, but nf.git is preferred.
Okay, will retarget :)

> As for the conntrack and dst, you have to explain what it breaks on
> your end.
Dst as shown above. Conntrack is more speculation, but my take is that in any
case the dup path should *never* have any kind of retroaction on the observed
path, so any "complex state" attached to the direct path should be absolutely
isolated from "whatever happens on the dup path". Am I mistaken ?

-Alex


