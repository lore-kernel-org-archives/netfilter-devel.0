Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0525361DA7
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166936; cv=none; b=cG0IXOa1FXogjQ/ZjJv3nTeNhA4dTWyp0A5QYyWuEPdqmKPVxjQWS0UAXcPY3yXsR1FrfpJCS5c31YtQfwb5zz3dwsKYBScr+TZkPV7zo0lj0r9bfwz1K6fj3cdhcgHX3/G5GJ3KOztlnybtcwAd522LKP45DU+oqDm2iWikRNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166936; c=relaxed/simple;
	bh=x7Apl9ihKaoaWZi5tsiyj9XdsN5NTj65ZbJChWnAXUw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rVRZcEIWzl+CbeZ4QVMT7QW00Djh5KOa2lSjKeBBHocQ7w3X12QceZ7vMBXtSE7f3Wrez+gG7eC3KAaebl1aK+z9wPjOGlXCtSJMP7KNdrXlTDDrdnpwzOS4hExB0VoaPPpUz/Dmw9l3oAL1S2reMxExoCqwQxoY44aiWaJwov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uklwd6d0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a60OyogU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uklwd6d0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a60OyogU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790166933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDQWN+qvZeX1gaIgZOYdsKlCuMncX8rgK5IP5SLXF5I=;
	b=Uklwd6d0eRA+Eyy2vAggML6T0CSrcFOyGz/uLDNGkTBXEtKvXHVdxMzfrbcAJJ8MZsKS4o
	nbB5R+KH1+FMPRg61ri+N7lC6HmQ1KtlRDnY5WQSlRuguud2ZTNpS/mmBVrJSYlm+ehv84
	VqzDyxgzwJwRVtOkWI4iLvyS0EFne7w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-RtoWhSB6PcOozIxLbTkp4w-1; Wed, 23 Sep 2026 08:35:31 -0400
X-MC-Unique: RtoWhSB6PcOozIxLbTkp4w-1
X-Mimecast-MFC-AGG-ID: RtoWhSB6PcOozIxLbTkp4w_1790166930
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6b5c5f44so12544105e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 05:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790166930; x=1790771730; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UDQWN+qvZeX1gaIgZOYdsKlCuMncX8rgK5IP5SLXF5I=;
        b=a60OyogUZ+HcW76z3sOpzu0sYxAgSCaskaeDeHAHgy3uDs6dg3MVYweUmRazLxr3rR
         ky25sj+3BYPckeFqZ9/ZZAv+9ODycMinEgwZb6RqHSNr2d50qhNyYAOmje8D4d5e6LrC
         XuU6GKQkOPeiN7oSjzbhmnI/IPU1710iM0z+X6+0pTw6gT5HIQonOsxQM8KXSG/8+354
         V6kpUuxqqeazPwnWB9C3OuRTFGCscX+sDk0vtTg6UdjNkgVN3ucskiq9xdNUDZHd162i
         hR19Gxv3BEd/vld7hxOsrMoW5mQlRZVo5whjeLwaclQf+DYVVCiy4YqU9fpKCczVboiL
         LhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790166930; x=1790771730;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UDQWN+qvZeX1gaIgZOYdsKlCuMncX8rgK5IP5SLXF5I=;
        b=dorDWLiyNzxtMVPhgdTmcd1dmF5IiS3QLYmBD0ac8EeJVk9o0/oXrhCm/2IBM8WOD9
         ZgIJCI+jDO7YGqH6Jd3NHGx6EKR3OnNYPqY9a2C+eZRAFGmIYJr1tDH/S2GvRJZgsGuq
         QuDk059Y6MQoEisVv/Zdb1Hn/tYyTMXtkGEc+eaZMrwink8614Q4q4RPdBBDLLM3FRd2
         BMFpap+fGIJHPKxdU0OpM/MW0PhgpwI3CRur88mmMJ4aLEt7xOloe8XYzbvxWiRJzGu4
         b9eufBwkgYAHc+wqAr/svvi4WhwhnowRlQuqKa33Ep89ovePb2PtiFLojmIGd9/of/xP
         k1wA==
X-Forwarded-Encrypted: i=1; AKwUvBy1NLZzgjW0zsy4pMFx+1WHjlMnFUo2SNxDcCu6PwgkfxxgE+fQg99/bYMepdrRCmVRoGZ+IzpWdM6JgVR1tC8=@vger.kernel.org
X-Gm-Message-State: AFuF++mcP/MsVMF+WqupAfaII0Uw4EluYl0zA3JDNIrPaLdlJTWyLzvO
	A0cF89aQ4sYksAvzIRQH8LaVAOgxzWP4hs2V/hpTrKt4eGU+yHRl5rAJKP1dXXAQlfFZLHzq5MH
	/aDTVfmzXrhV5hVk45JQfBH2jn2lGGdodm1zSIMtzB/V3Qk9lOxDd8KYVxPH2XhYaeUt5Tg==
X-Gm-Gg: AYBFou06t5WHyuteBOIPs4UkrvvndX+UnjqNdvzrp2uK6ozp5g7NsWp08r9aQsSKQv1
	UgO+hJKo8T75KDngus/o4h9ifaR9ac8vM6gZ7EHqQ9IogE6FOmiIf9Rtd/QWVt7Z7zc1/dgugAA
	YZCw3x7AuilFp58OOGhep6aRW8+zgg6qZxOY+2Vc3YU/nal31+vBpFxzZD2GvIJ/7XFKaduF2nG
	VzHq8Ba5A4afRnYgLx8f8NF4ri2HaYySpX8uNkF/mE+C53v6w5h9OJDlxB5wH0Jr23eq8G+SRGa
	p2rZpxRQQ3/6nlemVh5zY6a8B8/sNbMqyeToosd4WXLrPGEDM3HprhADHxPVmdN/YM2tdKmnb+s
	XqWTi8M2UbNMR55VDBRQhqjABNIcEq9de6J0sx68=
X-Received: by 2002:a05:600d:1:b0:49f:e3d4:4c1f with SMTP id 5b1f17b1804b1-49fe3d44c52mr16737105e9.8.1790166930501;
        Wed, 23 Sep 2026 05:35:30 -0700 (PDT)
X-Received: by 2002:a05:600d:1:b0:49f:e3d4:4c1f with SMTP id 5b1f17b1804b1-49fe3d44c52mr16736585e9.8.1790166930125;
        Wed, 23 Sep 2026 05:35:30 -0700 (PDT)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.25.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1ccb90sm75125185e9.6.2026.09.23.05.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:35:29 -0700 (PDT)
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
Subject: Re: [PATCH net 6/6] net/sched: act_ct: fix helper UAF due to
 extensions realloc
In-Reply-To: <20260921145655.3167436-7-i.maximets@ovn.org> (Ilya Maximets's
	message of "Mon, 21 Sep 2026 16:55:48 +0200")
References: <20260921145655.3167436-1-i.maximets@ovn.org>
	<20260921145655.3167436-7-i.maximets@ovn.org>
Date: Wed, 23 Sep 2026 08:35:26 -0400
Message-ID: <f7ta4p89mcx.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ilya Maximets <i.maximets@ovn.org> writes:

> While calling the helpers, a raw pointer to the extensions area is
> wired into expectations list:
>
>   -> nf_ct_helper()
>    -> helper->help()
>     -> nf_ct_expect_related_report()
>      -> nf_ct_expect_insert()
>       -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)
>
> In case the connection is not confirmed yet, more extensions can be
> added afterwards with *_ext_add() calls reallocating the extension
> space and leaving the now invalid pointer in the expectations list
> that is later accessed while removing the expectation.
>
> Make sure that helpers are called at the end after all the other
> extensions are already added.
>
> Note that the helper rejection now leaves the mark and labels set,
> but that's not different from how the NAT was handled before or how
> the mark and the labels were handled on confirmation failure.  And
> there are no atomicity guarantees provided by the API anyway.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

