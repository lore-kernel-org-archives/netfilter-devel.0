Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459BD559CA6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090795; cv=none; b=R60MP5OGN8mzVTGppOWPJytiV+lrVBFMYO88Ty207PFITIQ9CYTFMzSya1FWWpea0Nsme0TFcJCVDlCzvti27dXdJUi412rPEUcLrqs6sZaehr/esliOBMMrMh+2lkRiiUEYFqqDaqETpJooDfyU/jq25PVB1nLT+olfN2ZxduQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090795; c=relaxed/simple;
	bh=4tTfIyxQFrJO0eYjaziEFGFnUgNWltKT23dBmntSrLc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Lr8Nuc7rFbS5FctsZOALnFXviLmK0kIHvRwUOgBRV0c/1EFjhsFDMp8x56sDIGDc74wk9CPyKP1UJ6CdqQz+b79o3u+uXuurauNbIgvwepDJNbhm7P9oUl3r1gcmypXvz0J5yFtGkD5PLE2ZnfN7En1rLLP75JCceYLW+o0MgtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChHlunaD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dg5AaW+c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChHlunaD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dg5AaW+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790090793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8zY26QjQrdL1DZs1bTzu+yz0u+JYpgALxi7/8nmtuE=;
	b=ChHlunaDOjWyPFNJx4AwLZdCWm8sZBKMB4wIJiUs58nDT63OVtBC7u7b3Pnc2Huu/REIIv
	Az7AeXN1XweIO8rCRCdi3y6unXoRq0qC26e4iZKl0UIiZaKi21E0oasvFbMsKqkh4opanb
	wkefm88DQx7JM5zNWzeuJ89aVuw6kM4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-RY3mlO2MN3KH5FKCg6VH_A-1; Tue, 22 Sep 2026 11:26:31 -0400
X-MC-Unique: RY3mlO2MN3KH5FKCg6VH_A-1
X-Mimecast-MFC-AGG-ID: RY3mlO2MN3KH5FKCg6VH_A_1790090790
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cd83ca361so47994225e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790090790; x=1790695590; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/8zY26QjQrdL1DZs1bTzu+yz0u+JYpgALxi7/8nmtuE=;
        b=Dg5AaW+cXOG3UCb117mUsmYWky0JYfwjukmhT5YrjX0uSYZufp9ySioGC6uY/T2kFb
         DpFVJGLVdmi06uE8stG2Ld/0ga5sLnuqZCErQAXV2UMz4EX59Au2kG1kY+OURt02g3V5
         Dek6VhkxEUsIsQFMXMVZ+Ae1ee5PUoq23nqvDKc/0xaY3LVDtHV30QzfctbT+BiVVrJx
         ua9/l6ZshDdrYI5msQrOyhR9hR/v+vzBIW1rSKIO/yGC6kkzjMc7W59F9SnM3utVpkcD
         QV4j61mq0upYvBhGfDGjeclKE5nMQWMyytTTZCzlqSmX+sW7hFUhR5xnWWU5FtJGwWd4
         79nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090790; x=1790695590;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/8zY26QjQrdL1DZs1bTzu+yz0u+JYpgALxi7/8nmtuE=;
        b=SOAmOZIWNBQ7XR1+acdMC87X8CI1XTx5nRUAt7bDkLt+UEkulDVFPDJ+GWkyL04GXE
         YFOpm9ObdqoxGcw7x2ABzsZbj84ANHazFOozz9o3QUu1dp6Ce//SMg2JajyImzjDuxDO
         NchLFzKqFfhVPwqpHeXvP/EMO9lhZ/GO1/AUjD7lj76ePWtjZ5iJr9y6a9baxwm01OuR
         5Zl2V99kNmxT2LdWHvH4zBqm2e2QDuuK55sImNfnNkba5UNjbTtMDC0vnG6Gf3EqrqOR
         NdaA+j5Msdktepn4n10Q7n9ewjwnlrIMrz4P2SxXyaNmDQo0jGLrlMhX3W8C3diGVPbI
         S/RA==
X-Forwarded-Encrypted: i=1; AKwUvBwxyQunH2ee8QZHsvxi3dAyqOwgfAXikkKXf9WbUOmI9CsEGlX2ls1e4RvB9hnvefdHpzFpBeqaSUavbeaagzo=@vger.kernel.org
X-Gm-Message-State: AFuF++kNU8fWeKRcT0Fbwfyc6jcCCNrQhXoNHZIKgqQ181MmGpimjXXX
	m+ByOFFWHnqbxyhZ6AWYMuT1MVT/Sx4kcgA+7NF0srRR47LyVkEN4IJkjrNnK4qGr6TlrSdI6nm
	TRYqmJObjbXGVZkm1NkolA98McmVPoSzxhIJEsaQDtMTzQpP2JHdHEsQaikv3v7rKaHTAgA==
X-Gm-Gg: AYBFou3cZsVWQCQuaGq4VyNm3MMiVDsg1PwLbWPXoJK+IUt2tBrtG8nJ9Mo6Ehnqi0O
	L9L0Dt8EpoMGnBl64AhiUzauAaLli1F2F6PkISbQlk9mE1wOaw/6ggE9zqDj6SEcV95/IX19Ktz
	qHCQzKTktzY8dXXnXVfmLTAehJxESuLHhi2/+GWxJbjIMEWPg/wR8NkBwqd1UlanE1gF4GUOlpa
	caGU+aWaG3SwQVTq92I3bEacPsBnyiZ/aViYsrV+AlJlTOjE31ThZZNC9XG0cJ5Tyi3QsHXBKb2
	E8Q+iXnfoXUb7JUW4oPoW9Nhacxr3QHSfd1IB2o1ClC4KXrho2tpwsXMzZ1th//EYVqzF+PXJN0
	fhixhPU0UgTSG8gwCb3F9JbpysS0B1Hil4k1+ho4=
X-Received: by 2002:a05:600d:16:b0:49f:c1a1:5222 with SMTP id 5b1f17b1804b1-49fcbb0de51mr143309995e9.33.1790090790087;
        Tue, 22 Sep 2026 08:26:30 -0700 (PDT)
X-Received: by 2002:a05:600d:16:b0:49f:c1a1:5222 with SMTP id 5b1f17b1804b1-49fcbb0de51mr143309765e9.33.1790090789634;
        Tue, 22 Sep 2026 08:26:29 -0700 (PDT)
Received: from aconole-thinkpadt14gen4.rmtusnh.csb ([216.212.25.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde00473dsm3653365e9.0.2026.09.22.08.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:26:29 -0700 (PDT)
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
Subject: Re: [PATCH net 1/6] net: openvswitch: conntrack: avoid modifying
 shared unconfirmed ct entry
In-Reply-To: <20260921145655.3167436-2-i.maximets@ovn.org> (Ilya Maximets's
	message of "Mon, 21 Sep 2026 16:55:43 +0200")
References: <20260921145655.3167436-1-i.maximets@ovn.org>
	<20260921145655.3167436-2-i.maximets@ovn.org>
Date: Tue, 22 Sep 2026 11:26:25 -0400
Message-ID: <f7tecelb93y.fsf@aconole-thinkpadt14gen4.rmtusnh.csb>
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
> end up committing both but with different sets of extensions.
>
> The series of events:
>
>  1. The first clone wants to commit and runs the helpers wiring up
>     the extension pointer into the expectation list.
>  2. Then it looses the confirmation keeping the entry unconfirmed.
>  3. Second clone now wants to commit labels and adds the new extension
>     for that breaking the pointer in the expectation list causing
>     UAF on the destruction path later.
>
> While this is possible to trigger, there should be no practical
> network pipeline where committing both clones without modifications
> into the same zone is needed.  So, let's just reset the entry in case
> for some reason we got an skb with a shared one during commit.  This
> doesn't affect any known use cases, but avoids any potential problems
> with sharing and modification of the unconfirmed ct entry.
>
> The fixes tag points to the introduction of helpers, since that's the
> main UAF trigger for the sharing.
>
> Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

