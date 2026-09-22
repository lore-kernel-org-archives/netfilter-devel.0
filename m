Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9055559CA0
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090814; cv=none; b=XkMG/ZzGKVf1ecDghPnNAd9Zi4CoQtiZZpu8Ru0d0SALEE3rTGNhorl1C7TNnGjUjch4tQCMAJoDMA/1sixzniBNPStuRDxwBny0qPNxyodeeeymoo4f+atxqP2mNcwucHABHe4UsJSZ0ZUttmqnYrFSA43S69yPArVZ+KrV+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090814; c=relaxed/simple;
	bh=Nfpo/PElH+hUuXM1DSN+liBKZMn7dhMb01zv1lmNiYo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NbTo3ZwSbIB5SBUnTmDBkQaNHT8m0m0dHt1cJIBYQ4/fe7bvg3+kPaQXTYIpT6KMMEJcC0DHHR+S9ZHqF6lEkfEyyTat12FUgZpoVrdG3UTPI0dBYriGOObtj5Lz9H+lplQn0MFE8+NlZLRp1ZGD1+7CqeJHZ4YuelZR5jCokbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQPbU4Cu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oXaaBbG7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQPbU4Cu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oXaaBbG7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790090810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8HgF1fYWmdweGa6Ay1VNB6tjKEcFrxVON/LrrH3c8qA=;
	b=fQPbU4CuXEUVCb5+Uhy3fhGtfPiZhaO9To4tabeqWOg7SumDloRmgwQYefZ8uFwh5Qk77p
	bRnsJJfY/New2RmO/6t3CDTqi08DC+43t0HNoof06ZE+XZ/J03ctYbaTPHq70VUYID9He1
	1u8pUtF/+zROy7NEg7IbqTzf6e2W17Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-fpQ3rZtmNBGHy9uyCj-p1Q-1; Tue, 22 Sep 2026 11:26:49 -0400
X-MC-Unique: fpQ3rZtmNBGHy9uyCj-p1Q-1
X-Mimecast-MFC-AGG-ID: fpQ3rZtmNBGHy9uyCj-p1Q_1790090808
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6683d48fso43268295e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790090808; x=1790695608; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8HgF1fYWmdweGa6Ay1VNB6tjKEcFrxVON/LrrH3c8qA=;
        b=oXaaBbG7WAP9r1MbYOMcGTNVKChT1lAE7nadpflx1TcbKnUgT5XTwW62XVrNHXHaAc
         AF6QoVlv+IKaXiGx7KQLEmCUlJU2XvLT6uialFii+WzEFLq5hHb2L8nx1Qzx6ZA0GdTg
         rLAiDIsHLCqtuQ3+nqP7sCi17oDsDSim7K9CIPVVOx5KQiPoLJYqR5t+VFCt+jYAG3DH
         auU+ELt/hMQJjraTCkBCJcqZ0Ug1iIyZR38BoIgVes0srr9YPJ02lXAE6spJthIzmPmt
         Pqzf/GT0SfuII4XAIj0FGsA7kG8J4LryHESJDYorkNk7zrzieRv44zlz4CHE4v+O8eP2
         e+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090808; x=1790695608;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8HgF1fYWmdweGa6Ay1VNB6tjKEcFrxVON/LrrH3c8qA=;
        b=UgtXKEwg3E4a56vopsxgJvMH5YAfeG9cGKJcozB/OBQLVjefLJy0sFEw9nr53cQPnE
         yD+Y3dISUnrEsJbgb6YvpE+Z32Ba6EgihzH4MqK1ZpDfQtkE70wPl48BcVVdZbPMYnMb
         ZRiSO3Dj29O6wiW5EPXTs5l6DKAUpCN0FyQYjtc5rW8+1U6nlTeZvX6stU8DfhXMWdR4
         jXPsKd6s7Is7jw6MNKpbOFga/q3hendg71XRj3d4u61oG155U1WnL/EMOa4ecfQlmhFD
         46tzmKCBpGLb8YoblYwq2+T6lcJSrjvTpm1xwWAoQ3GHjdW4oaVvvUB2AYsaGvAl6+xX
         ZKXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrKEXqIACZmIitTM3r4nP84/0q3Pusm4eao5sYizsIfq3tWSMIe3sutuAkey+DgFHMTbTSnUPeaBTrEUKWDfk=@vger.kernel.org
X-Gm-Message-State: AFuF++np3uD9Rtb2LQMAeLF4YEVfv2eridMw1iYMT0ZjTSe3H3YHz7hi
	KJz5YaNuSmHk+hlPJ41xxDyyZnl0B0CbcgEpXe6f6Dk76AMnThI7SvugERt7E/vGYovhJy8cR2J
	HhroQQLIfhl/qDu7qhfTS05nchqfHtz/0IZ5f8ppltN2InSyt4FfWwbfFozBZnm3bnOAVVnP5Ar
	9hYMsx
X-Gm-Gg: AYBFou0sZMc0C5ZoGfaaDmKokRKW9EIuC+fCU4kjzMUjUmYxYbVO8P86wpVmvmPYZrk
	CGAISObWNMVPEtLIpwwm0Q2WFghnlvNKME0UkNdShchO5mj4OZJl7JNpe71GEq6jUTASPk18cG/
	sn1IbS5wJWPRGaWFPLm7ggarUdC84+K4nAzCkDS0B6QqRMdGZjNvuNjqzbaNoxBc0er7gxmeRD6
	3Ksuk5ofD+mbxRjqJKDLCfrQPjqZgAKoy9y0xbjGZOaAK8rIfHsiEHtADB4tNoXPPryvUmmzGNw
	TptsxvAaPm85/M+ARGiNxOz/8ml2WwVH8Gm5/vlXMmXZRx0mcoo2RjXHBPoJ2zrOEjBU0Ey4bl0
	94rjahYiEsFEUMV/negblTrCdSKRk
X-Received: by 2002:a05:600c:310e:b0:49c:f4ff:e872 with SMTP id 5b1f17b1804b1-49fc5681249mr210658235e9.5.1790090808266;
        Tue, 22 Sep 2026 08:26:48 -0700 (PDT)
X-Received: by 2002:a05:600c:310e:b0:49c:f4ff:e872 with SMTP id 5b1f17b1804b1-49fc5681249mr210657815e9.5.1790090807714;
        Tue, 22 Sep 2026 08:26:47 -0700 (PDT)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.25.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde071f85sm875605e9.4.2026.09.22.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:26:47 -0700 (PDT)
From: Aaron Conole <aconole@redhat.com>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org,  Pablo Neira Ayuso <pablo@netfilter.org>,
  Florian Westphal <fw@strlen.de>,  Phil Sutter <phil@nwl.cc>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub
 Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Simon
 Horman <horms@kernel.org>,  Eelco Chaudron <echaudro@redhat.com>,  Jamal
 Hadi Salim <jhs@mojatatu.com>,  Jiri Pirko <jiri@resnulli.us>,  Xin Long
 <lucien.xin@gmail.com>,  Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>,  netfilter-devel@vger.kernel.org,
  coreteam@netfilter.org,  linux-kernel@vger.kernel.org,
  dev@openvswitch.org,  stable@vger.kernel.org
Subject: Re: [PATCH net 2/6] net: openvswitch: conntrack: remove
 'add_helper' dead code
In-Reply-To: <20260921145655.3167436-3-i.maximets@ovn.org> (Ilya Maximets's
	message of "Mon, 21 Sep 2026 16:55:44 +0200")
References: <20260921145655.3167436-1-i.maximets@ovn.org>
	<20260921145655.3167436-3-i.maximets@ovn.org>
Date: Tue, 22 Sep 2026 11:26:43 -0400
Message-ID: <f7tcxu5b93g.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ilya Maximets <i.maximets@ovn.org> writes:

> This variable can only become 'true' when the connection is not
> confirmed, but it is only checked when it is confirmed.  So, it can be
> treated as being always false and just removed.
>
> Fixes: 3c1860543fcc ("openvswitch: add nf_ct_is_confirmed check before
> assigning the helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
> @@ -821,13 +818,10 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  		}
>  
>  		/* Call the helper only if:
> -		 * - nf_conntrack_in() was executed above ("!cached") or a
> -		 *   helper was just attached ("add_helper") for a confirmed
> -		 *   connection, or
> +		 * - nf_conntrack_in() was executed above ("!cached"), or
>  		 * - When committing an unconfirmed connection.
>  		 */
> -		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
> -					      info->commit)) {
> +		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {

This is already a good reason to apply - the existing construct wasn't
particularly friendly.  And the follow up in 3/6 is perfect.

>  			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
>  
>  			err = verdict_to_errno(err);

Reviewed-by: Aaron Conole <aconole@redhat.com>

