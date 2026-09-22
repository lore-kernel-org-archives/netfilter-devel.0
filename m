Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A5755C1C3
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090844; cv=none; b=A9jE0DyqDtPVz8Ui8QZG+jjtjLNLSp+fSRDh0PflTFhzwN7WV2qgc1HpxF/s1p/NcCBbvqP/w3n5knoAAVCwRGetxXQZ+gydqN7Ok6pOOXIXh7cycCkuFLpk0uFSEQTgaQjeAZe05mubGPrmfiB43bmCt5dTYpGlA+CPCwJSkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090844; c=relaxed/simple;
	bh=0AumlRwlWfNJNnKw4BdPtTBb/Y9n3FIbSvp1JQRP+Ws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=czVmQyCjkHxtQVRNg/k3Bnc/F/0Hu1QOS5tE5fngStSiJfZ9vWyNLB6g4eGUO57aiJk5BVkrA6yhSquGioR5QlWUhz8fZGRB/iiz5XBcCm3QcwaqeK2DJ1JXFz+kxFBZ0c625rMVe1fFtIIPXah9eQWX7b0cYR7ffVAsPBFc4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Chux5DDb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TsA4e4TA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Chux5DDb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TsA4e4TA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790090840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiMRQI9uNvgikrTB+A1HHyTYpeJRXwwSNICkcWjdkhM=;
	b=Chux5DDbWvTIn1i6QKO9GqrwlvE8Twrw3KvjtmbNYCmf3+WQS2qjMSe22yzaTwV51PYm+r
	mNWzKvLiAoh9dgQr0m+OtJuzB/TUsPs2JyJnZBTQbTxZCtqTeGWZ3f/Vtl5CGFt3cbX/8D
	zpXb0snoUqbVAxc4E1NrJt+6cA6zmcA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-M95Yl7eqMVqjNb8ScbQhpQ-1; Tue, 22 Sep 2026 11:27:19 -0400
X-MC-Unique: M95Yl7eqMVqjNb8ScbQhpQ-1
X-Mimecast-MFC-AGG-ID: M95Yl7eqMVqjNb8ScbQhpQ_1790090838
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e745d5dabso45636685e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790090838; x=1790695638; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PiMRQI9uNvgikrTB+A1HHyTYpeJRXwwSNICkcWjdkhM=;
        b=TsA4e4TAbMfzwf64rTF3v0cacn/b7zgMB2lTGMdXusbenBgvY7XFcb8LFRknXl4320
         4cUdSum9AePsiJrhlTz+qcK141s+GcwyKvi+hVEuDvDak0hO6MRK+feuUfZ9qa/eWOPh
         R+BuxSrBIsuDPk9iJfqyaTrEfjp6sNmWnhepJ17nbS/E1WATAfZi2cwxp6flwZXnRb2g
         1F+tHfMIkVllcepOzo/Nk7Kn4MuR21edjVF8wTWzlCUAq/sWoe8elJH/pmF0HqbtPHir
         mRnYb8iBkxLMsVr863rChTS7W9M5qa4uJSvP9oeHXBzYU3m62al6938BFFQJJoskZ2SB
         hGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090838; x=1790695638;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PiMRQI9uNvgikrTB+A1HHyTYpeJRXwwSNICkcWjdkhM=;
        b=walXPSBfNThec1NtCNNZF/TGJMqes4SHFb6s1wCNZpoPFwW8k8wO6DHrY0P9Qg1cU8
         iOLj5wmTLiD5fAOWR+7UIggdZLK0KQykGXcVMAeyy0MzVLGbZ2S7pLBVnZlPsWMDYThG
         FkVgbNJ1l1EGZaM9rZ8kQPfuc1i4e/vaw4xCBk6EYEpYxwxfzcdlrJiD3sHzgcLlnwsM
         RW7ReeAFgGnEQCUQ9nrzucKiVd2U9CRimAdGH9xi5x7PXPke+64KWTs4fIB+LgZz46C8
         TXXh6VTtoNuTCK/BOGKlmk/dA/VBrg5lDq5HMTYMIpCePcvxWVyCVQ6AMMS8JEifj2WR
         XKkA==
X-Forwarded-Encrypted: i=1; AKwUvBxwfTWUvlvWYdELbIGifL0PIPu2+XWjxUnam3kYx7DU5M0XcWNnbyGazV1Xzl8lCZWqMpXaV9+F8xhLMWjHIj0=@vger.kernel.org
X-Gm-Message-State: AFuF++kH3z+WcTyGX8DLNKF1aKZAE/ereYsdomFw3gQ4huYq6cuaahJ5
	QnPlga84Ut4A4CFgLp5SgRnRoEd15jyD//e2XLZ8Q/K76hD3C/t2nwA2taT4NPDHWnSC3d5iOk/
	j4FxX6vbnZl8EYmsmGEbeapxk2UQ0rFkfLG4VWh/T/Z1LvfZHQ9Jz3lJxZQMiTUgCZJjmCA==
X-Gm-Gg: AYBFou2JmFZzgvWrmHCGuxSJjrWECbGA/H9W9H5SK4lFDprvEArEzXQT+DChqy2DK8r
	dC3zmEF3e6B747N34F7S4YF8qaGnIjW3iZZUWutVie3o4tbFoB5x9n7sToDzTyjHo3OcqFoM18O
	9CH8tXfx8bKwaV0rcZ5BmXiQus7NzeluJlOpvZm8hImjRLapXCTxF/NXjGKjzKfKfnwYcw+pgqu
	rjYRfFiJM/hQgcpE44F8SKqehJJkGWP/XjVxuF66pL/kn5YWY7RvE0T1kJd22SBb29HiodVDvQl
	0raw3Ae7jjVRd/C2OHC9urUu812LEFxEAERh94BaggQ4ylCfwl0QWsm1sNGNoQ0ilmanOnlC353
	2Uo9sfByUe+YCarC66YVCCaLHlUyQ
X-Received: by 2002:a05:600d:6413:10b0:49f:dcc8:c735 with SMTP id 5b1f17b1804b1-49fdcc8c74dmr17237065e9.18.1790090838163;
        Tue, 22 Sep 2026 08:27:18 -0700 (PDT)
X-Received: by 2002:a05:600d:6413:10b0:49f:dcc8:c735 with SMTP id 5b1f17b1804b1-49fdcc8c74dmr17236665e9.18.1790090837791;
        Tue, 22 Sep 2026 08:27:17 -0700 (PDT)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.25.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde064a64sm972975e9.1.2026.09.22.08.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:27:17 -0700 (PDT)
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
  dev@openvswitch.org,  stable@vger.kernel.org,  Axel Mierczuk
 <axel.mierczuk@1password.com>
Subject: Re: [PATCH net 4/6] net/sched: act_ct: avoid modifying shared
 unconfirmed ct entry
In-Reply-To: <20260921145655.3167436-5-i.maximets@ovn.org> (Ilya Maximets's
	message of "Mon, 21 Sep 2026 16:55:46 +0200")
References: <20260921145655.3167436-1-i.maximets@ovn.org>
	<20260921145655.3167436-5-i.maximets@ovn.org>
Date: Tue, 22 Sep 2026 11:27:13 -0400
Message-ID: <f7ta4p9b92m.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ilya Maximets <i.maximets@ovn.org> writes:

> In a case where skb with an unconfirmed ct entry gets cloned, we may
> end up processing both again but with different sets of extensions.
>
> The series of events:
>
>  1. The first clone wants to commit and runs the helpers wiring up
>     the extension pointer into the expectation list.
>  2. Then it looses the confirmation keeping the entry unconfirmed.
>  3. Second clone now wants to commit labels or run NAT and adds the
>     new extension for that breaking the pointer in the expectation
>     list causing UAF on the destruction path later.
>
> While this is possible to trigger, there should be no practical
> network pipeline where we need to process both clones without
> modifications in the same zone.  So, let's just reset the entry in
> case for some reason we got an skb with a shared one.  This doesn't
> affect any known use cases, but avoids any potential problems with
> sharing and modification of the unconfirmed ct entry.
>
> Unlike openvswitch module, act_ct allows for NAT without commit.
> Changing that would be a uAPI break.  So, act_ct needs to reset on NAT
> regardless of the commit flag to avoid reallocation of the extension
> space.  This, however, doesn't really change the picture for sensible
> networking cases as there should be no need to run the same packet
> twice (before and after the clone) through conntrack without packet
> header or zone changes and without commit.
>
> The fixes tag points to the introduction of helpers, since that's the
> main UAF trigger for the sharing.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

