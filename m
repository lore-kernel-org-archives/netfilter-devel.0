Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6111DDE9;
	Thu, 11 Apr 2024 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830401; cv=none; b=WjC6OCPixfKRzmu0B4kKa6C+rI1RnruLKvjHLEXr4UwqDbPG1uX9HQiGXwa97Aag1a3uQJReRxQIl5uQgcQVFJ6Gn83vP1fLHyhKIV0KVJyP2R8q6aX5UgMjp8jlj7kdtlC4HJUg8VpqkX89+CuxoJ3IHD/qPVu2J62IatBNS+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830401; c=relaxed/simple;
	bh=qh9ariit9ohYCJG4JOSwfVQlUeKW1q7q8JcLdwOMkIU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=ZXgypPQwIim+5gEDnjRGRR4AwXnxw6ZMg/f4JAOJQ6JZfHmvtnWYP+PKrAGkWGn8qGo5Hw6s67tzSXBerddgB5WeVARuVC386JUU1AjoNgszWqdOuD/u52A4vP8cWf9Kz0lSWuFIGUEAFbDo9ZV2w703Zpn43I2tE3LU2DdYWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMaDXjL2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMaDXjL2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-417c5aa361cso6919235e9.1;
        Thu, 11 Apr 2024 03:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712830397; x=1713435197; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2sU3rRH5BVBAh1x64QnT6cUy78LH1e54WKfL3SRJD7Q=;
        b=BMaDXjL2vKyLcoN/9Ohow1DmyZlthIkZkDu/7UEmBZOYX1GPO2NHcv/6QWo+9nx2Dr
         kTCBOpD/AI78ORJobdX9tSYxvj3vlp+WJ2CAk3taUQ9pjg1FGLPDJcw2CugJrUZA+cPQ
         /RkNYLs0dITh3uThCjAuQXjOzVwpREkMwTMrnXZTT+1SRK35bIDdWimbbvNEGaIXXzci
         UFK7Y8uCE4cWa0WsgEGjuT1YZMaKdi/rR3UnqoBqJ3LK6uIX175hXKdBeE6EetTv65Yz
         DPM33jDVknykUIoILYamo1njewxwPw+Mvr1RFurpN7kIk0aLXnnWsEvxtGw0wOFtBz1V
         wYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712830397; x=1713435197;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sU3rRH5BVBAh1x64QnT6cUy78LH1e54WKfL3SRJD7Q=;
        b=CqaGU3WSXlMj1j+sE4syuwojFeeYLz/iL/7/9nwENBlHCxmRXUm7SDwzKOzopor0+e
         EyU56tEjpGTYLQ3ULaBqGnN1TvRJNQhuzh0zK8+1yfkLJwYVbqzySMBb9yj/d9YEMzEi
         DuRMS463VfaU+YYREQIwwu++M/Q13OYjWIt6bOOrJIwGhU+onft48ERPKfaFhFnybLY0
         Zsxu1gscz5jK6AeaExMI28qtPQA8nAyfKuQkOHaNkdpXhOCeuXH04qA4NgqURBnKRA2i
         cp3CLUPKIDNy10udeTuCKEFlX8ZVulQq8aujIlNN430QeIUpQd+UxK/2CXfX/f7Uz4UH
         OK8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbwN1Ly241VIpQetR41pYdSnllhTk98tLUTedaSmWLz+TQ6uVtMvtZTOWhkiy23cECsXvOUmYUHG3Ut4YuKxDZzUBi8a+GRjhx6MN76rs4
X-Gm-Message-State: AOJu0YyyeVcQ6HyZTpUG7GxpyU8dAg01UF2rgDunZiKtmew/ajGmm/3A
	6ew7eqja/PbjKBTBdBJXLHqmWqK7/XLBkOjl06FO4RV7vTrylZFz
X-Google-Smtp-Source: AGHT+IEm1BzYISqHDYJg6ON8yjk+jj6q4uIe/Rs1HQMCgRYXjPJ3Ei7T/6nvUaQNXbbFYFM5MXAfAw==
X-Received: by 2002:a05:600c:46ce:b0:416:a4e8:715b with SMTP id q14-20020a05600c46ce00b00416a4e8715bmr4163414wmo.35.1712830397420;
        Thu, 11 Apr 2024 03:13:17 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:9995:9b8b:815b:e336])
        by smtp.gmail.com with ESMTPSA id gw7-20020a05600c850700b004146e58cc35sm5123500wmb.46.2024.04.11.03.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 03:13:16 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org,  Jakub Kicinski <kuba@kernel.org>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Paolo
 Abeni <pabeni@redhat.com>,  Jiri Pirko <jiri@resnulli.us>,  Jacob Keller
 <jacob.e.keller@intel.com>,  Jozsef Kadlecsik <kadlec@netfilter.org>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org,
  donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 2/3] netfilter: nfnetlink: Handle ACK flags
 for batch messages
In-Reply-To: <ZhcdCUA2yJ56xdbj@calendula> (Pablo Neira Ayuso's message of
	"Thu, 11 Apr 2024 01:13:13 +0200")
Date: Thu, 11 Apr 2024 11:03:18 +0100
Message-ID: <m28r1ki5cp.fsf@gmail.com>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
	<20240410221108.37414-3-donald.hunter@gmail.com>
	<ZhcdCUA2yJ56xdbj@calendula>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Wed, Apr 10, 2024 at 11:11:07PM +0100, Donald Hunter wrote:
>> The NLM_F_ACK flag is not processed for nfnetlink batch messages.
>
> Let me clarify: It is not processed for the begin and end marker
> netlink message, but it is processed for command messages.

That's a good point - my apologies for not making it clear in my
description that it is only the batch begin and end messages where
NLM_F_ACK is ignored. All the command messages between the begin and end
messages do indeed give ack responses when requested. I will reword the
commit message to make this clear.

>> This is a problem for ynl which wants to receive an ack for every
>> message it sends. Add processing for ACK and provide responses when
>> requested.
>
> NLM_F_ACK is regarded for the specific command messages that are
> contained in the batch, that is:
>
> batch begin
> command
> command
> ...
> command
> batch end
>
> Thus, NLM_F_ACK can be set on for the command messages and it is not
> ignore in that case.
>
> May I ask why do you need this? Is it to make your userspace tool happy?

Yes, as I mentioned this is a problem for ynl and it would also be a
problem for any user space tool that is ynl spec driven, i.e. not
hard-coded with special cases for a given netlink family.

Previous conversation:

https://lore.kernel.org/netdev/20240329144639.0b42dc19@kernel.org/

>> I have checked that iproute2, pyroute2 and systemd are unaffected by
>> this change since none of them use NLM_F_ACK for batch begin/end.
>> I also ran a search on github and did not spot any usage that would
>> break.
>> 
>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>> ---
>>  net/netfilter/nfnetlink.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
>> index c9fbe0f707b5..37762941c288 100644
>> --- a/net/netfilter/nfnetlink.c
>> +++ b/net/netfilter/nfnetlink.c
>> @@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  
>>  	nfnl_unlock(subsys_id);
>>  
>> +	if (nlh->nlmsg_flags & NLM_F_ACK)
>> +		nfnl_err_add(&err_list, nlh, 0, &extack);
>> +
>>  	while (skb->len >= nlmsg_total_size(0)) {
>>  		int msglen, type;
>>  
>> @@ -463,6 +466,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  			goto done;
>>  		} else if (type == NFNL_MSG_BATCH_END) {
>>  			status |= NFNL_BATCH_DONE;
>> +			if (nlh->nlmsg_flags & NLM_F_ACK)
>> +				nfnl_err_add(&err_list, nlh, 0, &extack);
>
> if (status == NFNL_BATCH_DONE) should probably be a better place for
> this. I would like to have userspace that uses this, I don't have a
> usecase at this moment for this new code.

I looked at putting it there but when the code reaches the 'done'
processing, it is not obvious that nlh still refers to the correct
message header in the skb. It seemed more natural to process all acks
with nfnl_err_add() at the point where each message gets processed. I
can take another look at moving it there if you prefer.

The userspace that uses this is the ynl tool with the nftables spec and
--multi patch that is included in this patchset. I included an example
of how to use it in the cover letter:

https://lore.kernel.org/netdev/20240410221108.37414-1-donald.hunter@gmail.com/T/

Here's the example:

./tools/net/ynl/cli.py \
 --spec Documentation/netlink/specs/nftables.yaml \
 --multi batch-begin '{"res-id": 10}' \
 --multi newtable '{"name": "test", "nfgen-family": 1}' \
 --multi newchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
 --multi batch-end '{"res-id": 10}'

Thanks!
