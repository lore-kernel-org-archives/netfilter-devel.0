Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5C27A47F;
	Tue, 15 Sep 2026 00:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431639; cv=none; b=GjVEmkq8C7OC6qZo6l9yV+eYXZl/2q6CJI9gsLBxSM70LRSJtg5wr9DoPbSySvq7818N5UqCIndNbXSrxQVYlpUsnbVF5aAVtxjGl8i+IvbgjES+qNn6GHk8a6ArOsnFdXjvQsGpE3XDYz8wupyKDHhnFhTUZwwsP1isAzqqGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431639; c=relaxed/simple;
	bh=at/mkSwKK/sgDOyC4NiR4P+UYyAD/Db+XedYzMT+8Nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mTW0SWrCoVmBXZ1KpJHxexdR+sYXx4WUadWj1kezOH7Vi0ecBU8NUie1uMAXxGzgN8K+03AZuWJ6Oh2U5K8q96+zKcj1bJcxKAdoFIEt4659we+PGpn3XbRsrM2PTWPRYtDwv+0bi2VPzprBocjDm9SKltvsldrYpfC0I8cMUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de; spf=pass smtp.mailfrom=hauke-m.de; dkim=pass (2048-bit key) header.d=hauke-m.de header.i=@hauke-m.de header.b=vpAMK4NQ; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hauke-m.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hauke-m.de header.i=@hauke-m.de header.b="vpAMK4NQ"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hkN2g1yQPzMlDk;
	Tue, 15 Sep 2026 02:20:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
	t=1789431627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CpljDtNike4KVEVL9SOnc0NaK5QukU+03MiOs6oubNA=;
	b=vpAMK4NQpuPJjWNRu2IbF5PxGH/mGsFUa903es85mBXgrf5Acw6xq1pAQDXysr3sr/+1xM
	PiaeHDPhkNasXejayqCBD65XVsCzVSRArUnuMIkm5Wrmjkf0FINySXCKjfPyfOcgaxEPzx
	iSjA3ZXImpWdOk5NO5d5yxvYmrY6v2frNq/DB2CDVM/OhhWoI5myFSxe0zTpRQiJ7MJPaY
	l28og+B0UzG5yHvegUsIROsYOV7xqKel+qxdw+o2m8WFZ8LbdSHuECDpgE0WAhrSGbf2SL
	U95OYEGDRHWVZ64ag4KWopNHMs0R76m3EIPAVUxPt/F9LYL+/iuHbhEavQ0MuA==
Message-ID: <a031049b-ca94-4e11-b7b8-7b4c2acba954@hauke-m.de>
Date: Tue, 15 Sep 2026 02:20:25 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: network flow offloading broken in 6.18.45+
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
References: <7dfa42f6-64c1-4084-bfea-d57500c245cf@hauke-m.de>
 <aqcfvRE3aHoAx8s7@chamomile> <aqcgG0y-nYz4DWz3@chamomile>
 <aqfofgtUfyXlfHLr@chamomile> <aqfqQPP2Y7iG3kM_@chamomile>
Content-Language: en-US
From: Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <aqfqQPP2Y7iG3kM_@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 14:36, Pablo Neira Ayuso wrote:
> On Mon, Sep 14, 2026 at 02:28:49PM +0200, Pablo Neira Ayuso wrote:
>> Hi,
>>
>> On Mon, Sep 14, 2026 at 12:13:50AM +0200, Pablo Neira Ayuso wrote:
>>> On Mon, Sep 14, 2026 at 12:12:16AM +0200, Pablo Neira Ayuso wrote:
>>>> Hi Hauke,
>>>>
>>>> On Wed, Sep 09, 2026 at 06:29:50PM +0200, Hauke Mehrtens wrote:
>>>>> Hi,
>>>>>
>>>>> flow offloading is currently broken in Linux 6.18.45.
>>>>>
>>>>> Since the backport of commit b5964aac51e0 ("netfilter: flowtable:
>>>>> consolidate xmit path") to Linux 6.18.45. This is happening in a router with
>>>>> traffic from wifi to the Ethernet device when mac80211 returns -EOPNOTSUPP.
>>>>>
>>>>> Upstream fixed it in 871df5007eda ("netfilter: flowtable: bail out if
>>>>> forward path cannot be discovered") by not offloading the flow at all.
>>>>> backporting this change looks more complicated.
>>>>>
>>>>> This cam up in a discussion in an OpenWrt PR:
>>>>> https://github.com/openwrt/openwrt/pull/24800
>>>>>
>>>>> An LLM suggested this change: https://github.com/openwrt/openwrt/pull/24800/changes/394d741e6e76ecd172dbbf1d9ba171e378211734
>>>>
>>>> Patch went away.
>>>>
>>>>> It seams to work, but I do not understand this part of the code god enough
>>>>> to judge if this is correct.
>>>>
>>>> Could you attach the patch to this email for review?
>>>
>>> I've found it :)
>>>
>>> https://github.com/openwrt/openwrt/commit/d2b53b8043e17087b877bfc2335cbba87dffb4e0
>>
>> I've proposed the following fix:
>>
>> https://lore.kernel.org/netfilter-devel/20260914122456.1963453-1-pablo@netfilter.org/
> 
> Actually, this v2 should work:
> 
> https://lore.kernel.org/netfilter-devel/20260914123334.1964397-1-pablo@netfilter.org/

Hi Pablo,

Thank you for looking into this.

I think we have to handle DEV_PATH_MTK_WDMA like we do it with 
DEV_PATH_DSA in nft_dev_path_info() too.

mt7915_net_fill_forward_path() from 
drivers/net/wireless/mediatek/mt76/mt7915/main.c could also return 
-ENODEV like mac80211 does. Should we backport 871df5007eda to 6.18 instead?

Hauke
