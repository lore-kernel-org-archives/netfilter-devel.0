Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC681A9FAF;
	Wed, 29 Jul 2026 04:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785301042; cv=none; b=YRa+YYT6LFZhZMNhSs4NECrjZ0BYWsWhvU53Xdqm0rsgDiuvWiN3/il4Wk+N0Tk8weymQtrnDX4SQWj228heG4sRKR9yjY2RplrPz5u/okFJ0w6F+q4LeBMfNfIlULlbZDAWAIj6sVbp4eA9it2PyTV0myCo2/asPlqU4BK/2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785301042; c=relaxed/simple;
	bh=D9K1Z9cttwQVXeG5RwBAPgv8039N2NxAV6CPkuZcpWg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=DS8f7bH8AKloNcN+YrybEY0YzR5+K+17i8LZKfJm3Yfva6ItH1II5hlivR+94AgSqHv63W9Qhs8ayRCgmFkqKLsArpif4zDm7FhaoYQBwY/b0jiq9XMQg9dhb59fUXfuewNhdGuBEJ9f+MOkCAM+j3MDw9neqzhjLHmxFce1An8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=Z+ky/3zd; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="Z+ky/3zd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:Content-Type:
	Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	Content-Transfer-Encoding:Message-Id:References:To; bh=x+lCC8OPC
	kATc0+7FMzlx7WXWFtyZ9HY6mSThVzeGus=; b=Z+ky/3zdUr2FA6ZldeDd+9spX
	olyKGcDkkVY7dsGKp5wfXwEuJ8ObXjU6o0F3IaCEPJzVJ29j22R4eu0wkNDMATbi
	5FGj6Bqv0f5IZDJMlDijmDl6KBI4XNukDcKZFSA/U6mpEepEAmxfj55BOlNAgN1Y
	cJE0P5v8XAyJzq1ERU=
Received: from smtpclient.apple (unknown [121.225.135.236])
	by web3 (Coremail) with SMTP id ygQGZQAH1RMQiGlq9y9IAA--.37797S2;
	Wed, 29 Jul 2026 12:56:49 +0800 (CST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH nf] netfilter: conntrack: sctp: verify vtag before state
 changes
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
In-Reply-To: <amkCbQ1UDRKcZBez@chamomile>
Date: Wed, 29 Jul 2026 12:56:39 +0800
Cc: netfilter-devel@vger.kernel.org,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 coreteam@netfilter.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
 Ao Wang <wangao@seu.edu.cn>,
 Xuewei Feng <fengxw06@126.com>,
 Qi Li <qli01@tsinghua.edu.cn>,
 Ke Xu <xuke@tsinghua.edu.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <AD2FFF7F-7EC3-4205-BB44-508B31BC2620@mails.tsinghua.edu.cn>
References: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>
 <amkCbQ1UDRKcZBez@chamomile>
To: Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-CM-TRANSID:ygQGZQAH1RMQiGlq9y9IAA--.37797S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1rCF4DJF4kAw1DKw4Uurg_yoW5JFWUpa
	yFkwnFkFy8tr4Sy3s7Cw1UXayUCr4rCw17ZryrZF1Fk398ZFySg39rtFyqg397CFn3C342
	qa12vrZ8AFs8CFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcx
	kEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8
	Ww4UJr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6I
	AqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xS
	Y4AK67AK6r45MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUlfO7UUUUU=
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAgUDAWppLKGzpAABsd

Hi Pablo,

Thank you for the review.

> On Jul 29, 2026, at 03:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> Hi,
> 
> On Tue, Jul 28, 2026 at 03:35:06PM +0800, Yizhou Zhao wrote:
>> The packet-wide vtag check in nf_conntrack_sctp_packet() is skipped when
>> the bundle map contains any chunk type with special vtag handling.  The
>> per-chunk path re-checks INIT, ABORT, SHUTDOWN_COMPLETE, and
>> COOKIE_ECHO, but other state-changing chunks still fall through to
>> sctp_new_state() without validating sh->vtag.
>> 
>> This lets a wrong-vtag packet bundle HEARTBEAT with COOKIE_ACK, ERROR,
>> SHUTDOWN, or SHUTDOWN_ACK and still advance conntrack state.  That can
>> desynchronize conntrack from the real SCTP association and cause denial
>> of service for SCTP traffic behind a stateful firewall.
> 
> Are you assuming a specific policy in place? The connection tracking
> does not police packets, it just provides tracking.

You are right, I overstated the impact.  Conntrack only tracks packet
state, and whether a packet is dropped depends on a firewall rule that
uses that state.

> 
> Can you provide a more specific scenario?

The issue I reproduced is that a wrong-vtag [SHUTDOWN, HEARTBEAT] bundle
changes SCTP conntrack state from ESTABLISHED to SHUTDOWN_SENT, while the
SCTP endpoints discard the packet because of the invalid vtag.  This can
therefore desynchronize conntrack from the association.

For example, a stateful policy that drops INVALID, accepts
ESTABLISHED/RELATED, and accepts new SCTP only for INIT will see the
conntrack timeout change from 210 seconds to 3 seconds.  If the entry
expires while the real association remains established, a later DATA
packet is invalid and that policy drops it.  This requires an attacker
that can inject a matching SCTP 4-tuple into the firewall path, and it does
not require knowing the correct vtag.

> 
> We are seeing several reports related to the connection tracking from
> your university lately.
> 
>> Check sh->vtag before processing those chunks when conntrack already
>> knows the expected direction vtag.  This keeps the existing
>> HEARTBEAT/HEARTBEAT_ACK learning and connection-reuse behavior for the
>> `vtag == 0` cases.
> 
> Proposed patches to hardening the connection tracking state machine
> should be targeted at nf-next.

I agree this is better treated as SCTP conntrack state-machine hardening.
If you agree, I will respin the patch for nf-next without Fixes or stable Cc.

Regards,
Yizhou

