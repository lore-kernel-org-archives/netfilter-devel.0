Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F12E405;
	Fri, 19 Apr 2024 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713525812; cv=none; b=NY6mw/yFZbulPMDAln9V9YQz0nllpgqlm1RL5Kjj/p47SkM5BHaBMa0do/CriEnZjQkzHgodvnJWnwm2qasC0Pnfbf+dw+RjNcdBSpg0IqmLCLZxOZD1gz2XtVyHzTCHYYBOfnaRzmGypayrBi3cD41QuBjlt17EpmQDg6ZQ7Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713525812; c=relaxed/simple;
	bh=0kkw8bkTTz7qpeiQW0WRFjug7VupQ7REApR8PXhPSz0=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=HIpaALIDOAuki0vF9Ua6ULJuQyjxrnnk/tzLsQcZS5esLdcfUEjNJRdJJtFlAEJC0lsUMVNFcUGBQqpgnt+LAY0jXmUbVmv+WqHTVGp8libeFwVrSFbrl6OaWYNw1yCDs+/k6Hi7q8/hBtiM+oyD7tPqIA5N+TK/gyZm5GKaHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VSJuqqsu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSJuqqsu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-418c0d83d18so14080595e9.0;
        Fri, 19 Apr 2024 04:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713525808; x=1714130608; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=snFlYp4KgV+yLc6IElZhwwDwX1ADO6EDxPHFaCHHkjA=;
        b=VSJuqqsury0QZ+CZHKDlLhtyoHReSl3sva6xdOaagNDY+ANJF4i5UCpRs/uVn6T8wD
         yopOPdzE+juPR0gj9snYKX0jxTZFMo/wsbrdCFpeh5sRFQ67Mvog+EBTVmz2b918ZFjb
         oHDBC88Wf9vtGl4OdHrz09MJPovBMYtyN/Oji6WCS7GnUohfPPqMqpq5YVPGxcT5Nt/A
         3K2H11frUxji5Hq/x02aiX5nOG5oAerQClmadVK1Rva/1THbI6mvt5ZL1ZMAagZCz9kG
         MGYRz7tR6hL9evvKGRoMWhqoJGPOOyyOTL5FNbtoclkpyUPGU6BiITt/lsb9PcZ/XMfX
         8qEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713525808; x=1714130608;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snFlYp4KgV+yLc6IElZhwwDwX1ADO6EDxPHFaCHHkjA=;
        b=uNQzbQWuzceTvlqF6JIjexzC3wykAA795nbBIrVuUIJ6Bpmzj+Bg1SdabSYPqg5Brv
         XN2YxGyDGr45DXmOTLV007DiRvFnL8oLgeaxvGUHqAEzBFmmWqK0eNudq9Mqakr1rBxY
         /LEvx76RTF7WA3VpAX78g02iP45Oi5xKGjTKyh+VNdmJTUIIMFPe9+VNfbFSE770EE+P
         uvIo8Qbk6sjAh1kwUIdmyj8QkTwoVTO5lFvYLJ4DuKyIob7yfy6tLbu0N4QDHbGQpsxr
         BbBB5OoQm1TgMT0FeQV43hBCPPM7tmmI7t2LQn7FRj9c4SxngLyoSuNDeYYK5GvN2zqy
         +kYw==
X-Forwarded-Encrypted: i=1; AJvYcCXWBEb/JCLu1gCwj58x33AOCpq5Km5T1zre4BjVePcqrTY8hfuj93+ZTtvfpIqRUAa6PWzaUmuI1J3Ae3dJM4KSngbeiEf5eZuaatofrOdu
X-Gm-Message-State: AOJu0YypsLowREFLxhWtT5K/7G/rfkHekNURKKV9lSWCGRFJ87Wsl3hH
	5Waxua/94iyNM/ydVlKY8ADzTKtfEIcdZ730Zw9MmnETpIuoTPGk
X-Google-Smtp-Source: AGHT+IFeYf5HXUSQA81O5QO2J7a9UD4lVm/Kn9ZNwdXApO682UXvzybci9IW3JRCl4BhviaOmSIOZg==
X-Received: by 2002:a05:600c:350b:b0:418:d4e6:30cf with SMTP id h11-20020a05600c350b00b00418d4e630cfmr1164254wmq.14.1713525808302;
        Fri, 19 Apr 2024 04:23:28 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:d172:310a:8388:5ffb])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c154700b004190d7126c0sm1654348wmg.38.2024.04.19.04.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 04:23:27 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org,  Jakub Kicinski <kuba@kernel.org>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Paolo
 Abeni <pabeni@redhat.com>,  Jiri Pirko <jiri@resnulli.us>,  Jacob Keller
 <jacob.e.keller@intel.com>,  Jozsef Kadlecsik <kadlec@netfilter.org>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org,
  donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
In-Reply-To: <ZiFKvyvojcIqMQ3R@calendula> (Pablo Neira Ayuso's message of
	"Thu, 18 Apr 2024 18:30:55 +0200")
Date: Fri, 19 Apr 2024 12:20:25 +0100
Message-ID: <m2a5lpha4m.fsf@gmail.com>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
	<20240418104737.77914-5-donald.hunter@gmail.com>
	<ZiFKvyvojcIqMQ3R@calendula>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Hi Donald,
>
> Apologies for a bit late jumping back on this, it took me a while.
>
> On Thu, Apr 18, 2024 at 11:47:37AM +0100, Donald Hunter wrote:
>> The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
>> messages. This is a problem for ynl which wants to receive an ack for
>> every message it sends, not just the commands in between the begin/end
>> messages.
>
> Just a side note: Turning on NLM_F_ACK for every message fills up the
> receiver buffer very quickly, leading to ENOBUFS. Netlink, in general,
> supports batching (with non-atomic semantics), I did not look at ynl
> in detail, if it does send() + recv() for each message for other
> subsystem then fine, but if it uses batching to amortize the cost of
> the syscall then this explicit ACK could be an issue with very large
> batches.

ynl is batching the messages for send() and will accept batches from
recv() but nfnetlink is sending each ack separately. It is using
netlink_ack() which uses a new skb for each message, for example:

sudo strace -e sendto,recvfrom ./tools/net/ynl/cli.py \
     --spec Documentation/netlink/specs/nftables.yaml \
     --multi batch-begin '{"res-id": 10}' \
     --multi newtable '{"name": "test", "nfgen-family": 1}' \
     --multi newchain '{"name": "chain", "table": "test", "nfgen-family": 1}' \
     --multi batch-end '{"res-id": 10}'
sendto(3, [[{nlmsg_len=20, nlmsg_type=0x10 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28254, nlmsg_pid=0}, "\x00\x00\x00\x0a"], [{nlmsg_len=32, nlmsg_type=0xa00 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28255, nlmsg_pid=0}, "\x01\x00\x00\x00\x09\x00\x01\x00\x74\x65\x73\x74\x00\x00\x00\x00"], [{nlmsg_len=44, nlmsg_type=0xa03 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28256, nlmsg_pid=0}, "\x01\x00\x00\x00\x0a\x00\x03\x00\x63\x68\x61\x69\x6e\x00\x00\x00\x09\x00\x01\x00\x74\x65\x73\x74\x00\x00\x00\x00"], [{nlmsg_len=20, nlmsg_type=0x11 /* NLMSG_??? */, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28257, nlmsg_pid=0}, "\x00\x00\x00\x0a"]], 116, 0, NULL, 0) = 116
recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28254, nlmsg_pid=997}, {error=0, msg={nlmsg_len=20, nlmsg_type=NFNL_MSG_BATCH_BEGIN, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28254, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28255, nlmsg_pid=997}, {error=0, msg={nlmsg_len=32, nlmsg_type=NFNL_SUBSYS_NFTABLES<<8|NFT_MSG_NEWTABLE, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28255, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28256, nlmsg_pid=997}, {error=0, msg={nlmsg_len=44, nlmsg_type=NFNL_SUBSYS_NFTABLES<<8|NFT_MSG_NEWCHAIN, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28256, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36
recvfrom(3, [{nlmsg_len=36, nlmsg_type=NLMSG_ERROR, nlmsg_flags=NLM_F_CAPPED, nlmsg_seq=28257, nlmsg_pid=997}, {error=0, msg={nlmsg_len=20, nlmsg_type=NFNL_MSG_BATCH_END, nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK, nlmsg_seq=28257, nlmsg_pid=0}}], 131072, 0, NULL, NULL) = 36

> Out of curiosity: Why does the tool need an explicit ack for each
> command? As mentioned above, this consumes a lot netlink bandwidth.

For the ynl python library, I guess it was a design choice to request an
ack for each command.

Since the Netlink API allows a user to request acks, it seems necessary
to be consistent about providing them. Otherwise we'd need to extend the
netlink message specs to say which messages are ack capable and which
are not.

>> Add processing for ACKs for begin/end messages and provide responses
>> when requested.
>> 
>> I have checked that iproute2, pyroute2 and systemd are unaffected by
>> this change since none of them use NLM_F_ACK for batch begin/end.
>
> nitpick: Quick grep shows me iproute2 does not use the nfnetlink
> subsystem? If I am correct, maybe remove this.

Yeah, my mistake. I did check iproute2 but didn't mean to add it to the
list. For nft, NFNL_MSG_BATCH_* usage is contained in libnftnl from what
I can see. I'll update the patch.

> Thanks!
>
> One more comment below.

Did you miss adding a comment?

>
>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>> ---
>>  net/netfilter/nfnetlink.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
>> index c9fbe0f707b5..4abf660c7baf 100644
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
>> @@ -573,6 +576,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  		} else if (err) {
>>  			ss->abort(net, oskb, NFNL_ABORT_NONE);
>>  			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
>> +		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
>> +			nfnl_err_add(&err_list, nlh, 0, &extack);
>>  		}
>>  	} else {
>>  		enum nfnl_abort_action abort_action;
>> -- 
>> 2.44.0
>> 
