Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C08186E43
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 06:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726208695; cv=none; b=nXv4a/H9BF8BmU5YUE+XIO3aOCwCDWD0Utlq/cM4FW3Yc2/IMDgkDlvJn0x3RKk1pWyV3hX6oYoAmQudXHcO89DIYo2Jz3khSKxPU1DbAYZd3Sf87KAvpTRemAXq3909Co5u2ql08OyTnoSQcPxWsN27WXVklqyi7Tf1GV+Aaag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726208695; c=relaxed/simple;
	bh=gnlHCc351BwEecsAyGp3R3kaPycfJokfc57b98/uJx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmZeITNuh0u9rvqB+vb4b33prk3UBUzOgXC18UU2ra3Kqx1afOq9s6YlInkdB7UMwFu4qEEuk0T7gSoWiA/DIQP/1PnjXvFcRvBLQGjdsEo7Yig6FOstgxCFQ9Nyex9pnqqiD8BMoNwMfuyEV81N8nn5kb+na07PAOSJg7gha3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lN0f1n5J; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lN0f1n5J"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a08dbc6019so486945ab.2
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 23:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726208693; x=1726813493; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zorGJwoFd+g1xqUQZPUvypNKY1z27KplUOB/C8WgbpM=;
        b=lN0f1n5JVSm4ESbGvFmph8o0TQm5oQcmtndC9BQtnqx9t35joSXkyGVkiYffmWQ1xR
         ZWd97z64K7IvtwhkYrlsWcdz7X4qs+XiPUIBq/INjwNcdp2Hv8+yyWKN4kxJ6dl5eCoA
         LNk2qbVYYm682/uSfNUcOIpY44qunW7kTRC4F4EUahSbQkT+UGozG0mrtMBkK3+xXI3U
         nN4k5kmCI6LzOnFnKhG1kFigF9eSvMxkEyShaLg29U9IUeTkNf7alP9U24zfGJnM8Cg4
         OMVyMza0h0HLwA2GSfNM8wn4FYDwfwTVQKUBPIIQP4jD4PKwjM8zeonjJLwiTb7Q1fx3
         y37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726208693; x=1726813493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zorGJwoFd+g1xqUQZPUvypNKY1z27KplUOB/C8WgbpM=;
        b=fq8Jts+BepGRUbBqFNcduMuizA74xNU4fWz9r5uwJIY3UtRLyuGI+kW147IC2ibiqS
         3si8Urco5MeLmKpWLAUbqB2RnfJNKy8Xct3vKLIoHXsWFf7NybamwETwjdbyIWIEBns8
         MiMbKqYQETU6303y+6UQv5ZUhutYTXLTJ4cjstVdgYAx351jEeVYMAkQ5+UgOKRT06MS
         5JdWeca6jGXgS2z1ay7xGqcX9TWuOcyE0DErjIiiUc0ZfDLzSUfhhtHSb0yJz5+S+Ab4
         DNp+Lf8aqB8kya8fi9UJJVpnjJTFF6h+vu9+FF66E3TywM5KNs6AQkSBZ2UvRkpWWUgo
         P4GA==
X-Gm-Message-State: AOJu0YwG9A+TIQNOjGAR/gBet4Ixa3KO0S7berSGY7hhHf9g3FlJ7OyC
	Iw0/JGtDVJociuQZn0o5ILOn1P93LqBF+1cfbKcIa1Tx+M6j1wf8AwU6Q84VaoLe028abA3GYpp
	50nEbKxRMUv6OMIq0/5RKPGyXr4VyaQ==
X-Google-Smtp-Source: AGHT+IESPa7ZM8O4FzQm8T5Cb7eIRI4FobHiBRqWZVaivIip2nhdt7/i8kmuKysnM2H9O+gJmwr42MShm/YiF6+RC5Y=
X-Received: by 2002:a05:6e02:1486:b0:39b:393e:28ca with SMTP id
 e9e14a558f8ab-3a084911960mr56857175ab.12.1726208693436; Thu, 12 Sep 2024
 23:24:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org>
In-Reply-To: <20240912185832.11962-1-pablo@netfilter.org>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Fri, 13 Sep 2024 08:24:17 +0200
Message-ID: <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> conntracks") adjusts NAT again in case that packet loses race to confirm
> the conntrack entry.
>
> The reinject path triggers a route lookup again for the output hook, but
> not for the postrouting hook where queue to userspace is also possible.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I tried but I am not managing to make a selftest that runs reliable.
> I can reproduce it manually and validate that this works.
>
> ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> userspace queue processing which helps trigger the race more easily,
> socat needs to send several packets in the same UDP flow.
>
> @Antonio: Could you try this patch meanwhile there is a testcase for
> this.

Let me test it and report back

>  net/netfilter/nfnetlink_queue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index e0716da256bf..aeb354271e85 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -276,7 +276,8 @@ static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry
>  #ifdef CONFIG_INET
>         const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
>
> -       if (entry->state.hook == NF_INET_LOCAL_OUT) {
> +       if (entry->state.hook == NF_INET_LOCAL_OUT ||
> +           entry->state.hook == NF_INET_POST_ROUTING) {
>                 const struct iphdr *iph = ip_hdr(skb);
>
>                 if (!(iph->tos == rt_info->tos &&
> --
> 2.30.2
>
