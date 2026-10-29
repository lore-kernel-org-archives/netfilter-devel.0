Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793255317;
	b=ErZMignMiG9zUTxamCrNXALvZtfiaaN6Wnua3VvpfqFqokkvXKYeJJNMzPnFnoEUin2C
	 j8ejYi290rGpay7cIFRza0Jk1hoSn5Gcfo2w5Gwh/gaTJc2BuVFSo5A9FTxvbOwlVOTpr
	 VsxRLVn8Q8sRJ6hovrC26BqqZMxA00UuvjN6IZEwU4UglfpT3nh43oLLj9dcORIZklYku
	 6lgo+OG+6kYpTyjXZK7CYBehmX2YRgTHXP2n8pQDaFdU0WB+KuMmCjWKsXdSNiqF8ETyn
	 sy+K6pB0OQ7SN3a/XIC2YwtsiVFoctokTFfPXJkLHHQ2NSoitvvCt4GOYxrwM+1Hg9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793255317;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=1iJxU2srr5LwVZydpcZZOyNys/GEnKfXjQqJD4/acz4=;
	b=q6Q2may5GNpStdgu7oUOHVGLC2LOTAkzCwe/UeSW7m7HD4l9InoYAJq2yYRf/AwcXPSc
	 Fgtk87us1aMApf56SHIrJ2z+OyjHZ+ydM4UKYhng5agm2MBQT9jl1afO9faKdBhExUApW
	 +z9ehQ50Uo3qCLqKB1VNFiGGYCUAIh7qvOKPsa4qIHGq9tLlJT85fTedWIqLbS4W3jE/G
	 tVWw9Jq6c9GBBiLhSjH1czGOcgIGt7ZEXE32xq2L2nRS1RsFdB3W3aRewRcOvNHunXXMs
	 EUSyu82OA11aBrsc7UZ/FjaSUydkZolbkkBM/vWd7jFZPdIiXpmCddN5rZVr2DxpRCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dXGQZ8gE;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XExwyMTA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432C8606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 432C8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dXGQZ8gE;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=XExwyMTA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793255316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iJxU2srr5LwVZydpcZZOyNys/GEnKfXjQqJD4/acz4=;
	b=dXGQZ8gEyOQ5oh3QEezH5FCP2bIHc+ugtLtAan7KtKRVi4GrAdNesMpbYLg0xJ7Sco7hyN
	eXscDYWjLUAH5lbnXYY7RCRZqOSKHPVF4m7LCON460vnEwvp+TTNqkQxIJHTLQxMpr3anR
	V+faZnOCEZqbpJjoYyfyfUibw7lFWKs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-UqWqdzK6OXiun5HUiTJzrQ-1; Thu, 29 Oct 2026 02:28:34 -0400
X-MC-Unique: UqWqdzK6OXiun5HUiTJzrQ-1
X-Mimecast-MFC-AGG-ID: UqWqdzK6OXiun5HUiTJzrQ_1793255313
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5be60ccdae7so1259825e87.3
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 23:28:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793255313; cv=none;
        d=google.com; s=arc-20260327;
        b=JdU7yxCXtfvYEvpiwfh3gWIAaJqoIk29ruyR2yG2x1B1WchuYubzjIU5xgWPymAG/L
         7M6NdyeWh8z9jYR/y+E66kFfBYy0ZWfe+/ByQrkWzRavhMnMsu51qvKEZfCscFIMoYFM
         5OfenlKvbgwUYhGya5vUyUhcvnwj9iBh3/Z1N0Tno3VXtYhzOoALgyf4hrsFFARQtubC
         q5gH05qInP6IrFPVL+lxOGsRMUWEtGIyYmQtSZd1D1B5h41HVqRujqoRBgUVRTVtJge/
         ezGkr8azPI+4DSF3+jUfT3qLX8MeGSgzZUEgLXwrTBKDSCIoMqvHeOL13XWML5jfppxG
         YRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1iJxU2srr5LwVZydpcZZOyNys/GEnKfXjQqJD4/acz4=;
        fh=CCch0HqfxbRcl6hLgmQdzvaLfNHDFuCDahdabHlpUHg=;
        b=ILtF5iVeBLTfn+pLV6DbMzL3TBH4tSgz7DN9wV6GhyPUTfb24mMSGHAXg7K/8B5NHo
         Ee/Xqn4Owgc4uJYP3sVRtzRl0i5U1/NMy2kn/QktTOVlnh+sfvJvujXk8Q14gagMjygU
         FP2IcxH+WrIj99GHDpAMVPHerPtp59HKYjFtTFb7E0AIqQ4VWqsq3TeR+yZsp/QeRhuq
         n1oPOT/ZZLOwCWQ2+jxxHCYJUBOI/qvoFmLsx5ztJ/pENbswfT+22px/U9oMuHYFvnnb
         /20WNy4n+GVx7oc5aU9dffFkCD5Of27en9eIs4e2EjjXnb4V+Dalc0WNgTAYqjK4XzLM
         zjuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793255313; x=1793860113; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1iJxU2srr5LwVZydpcZZOyNys/GEnKfXjQqJD4/acz4=;
        b=XExwyMTA8DYbGGxcBAgigzAVW0ncFH8daEbWVof1HBicSweDQIU9RlX7anvY7lmysf
         m0XqJHSVZKGmAnYYXH4iR2dDd5VWahEwXyZr+VUM+Ou2Nogratli96r3ctrjc9z5FHZ0
         NHOXhaUs0n2MzhoySUyTY/s64ZpNAPg1v5rIIefRgTxgMk/efdoYlJGN7Qar9S4/fqaJ
         5wno6MaPs3c4ncrTtY/0er52+/EQsiseLH2ydHp+GzJ9Lt6OVSuLhaTjz7VntlrXXtdg
         +7YalFMtHTlECAURj7OwLv/Ht9+9YPk/rSEorxTWmpfO5OIF1ddX8PTUOpgq6I2ebCe7
         oznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793255313; x=1793860113;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1iJxU2srr5LwVZydpcZZOyNys/GEnKfXjQqJD4/acz4=;
        b=oLbk83KRALulBdtpCs1FP/iDCiV63ojihiAl+/PQE8Ta6YRvpMDO47xFtiPZ1Drpmc
         jSD0PPJ5W9t/L45W1ZiMIpx62PMZ1cHXNFx2WPtVJPOF8ZHsRvpZPOqgg2Xc45YZwuar
         5Tmc0YEnAkOLTLSO07WpCNNRX1Cz1aZTyhCh0qpBI80JNNL5ZP/Qeh4ph5VleEsSeP7V
         PIAmyX8GnEjRxhrijrueQSixWfp4NqUtjwLeAFTJsf9LqiylkJeIXJYdRl3cq1ljhvEy
         dUd0UMF5C76iLFBPHwTfsGEsNaUxWPlozNcqJu7otYBkIzCNpp74/jo3pYLHpG1+4fWO
         5kuA==
X-Forwarded-Encrypted: i=1; AKwUvBzzta4FFxKKsEHyLAzH6JmTMjgCQTggpeX6WtLZPzrvvm+yml/RL8FuaCcrGD66C3dbokBnLcHDDpX24UBvtVg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLpF1d0xYVDyyxzbv/KiI5reJgWBP5d6qMloJ+cSfeL/JOX7bhs
	nKO7OWpgEGM0ki/3l2dr+v+luMuJAZ2upwlnVF7A7PkPg6PGMFeevmiTMzhHcjz3Wnid0vrjB8w
	gWd8UkQVfl3uLAp7Ctso7yoytERJipaK45+sbTcs6m2HpEukkZLLiHBNfNlFBMy4Y6usyPdYz38
	JbmimnJWK/yumV1nuxLnuzGrvBtB4DIk1VfLQI3026uZxy
X-Gm-Gg: AYBFou2UuF13ptkZTMMoOly9mAnbK4+mJEguV6MxDXtL5dg1Q3SvJ608VzTShzSrxHt
	jLxvNz5UTFGoD3eCfOtyqkGzYAzlhRLLgEs1U5/JaJxywjo/rb/AEaNU1fvWpBl76j6PwHP4qB9
	++e8D2r3ImTaIbxJ6SxZNfr8gz581Pej2tMD+ir1MRCusTWzYaC2dT6Bbj
X-Received: by 2002:a05:6512:1318:b0:5b8:f8f9:e080 with SMTP id 2adb3069b0e04-5bfcad432cdmr1771567e87.26.1793255312833;
        Wed, 28 Oct 2026 23:28:32 -0700 (PDT)
X-Received: by 2002:a05:6512:1318:b0:5b8:f8f9:e080 with SMTP id
 2adb3069b0e04-5bfcad432cdmr1771542e87.26.1793255312465; Wed, 28 Oct 2026
 23:28:32 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028191103.623156-1-ihuguet@riseup.net> <20261028191103.623156-3-ihuguet@riseup.net>
 <CAAVpQUC7hezdMEQkzAX4oqFdO_uzBmtRwn85_5_iWf4ExPqpTA@mail.gmail.com>
In-Reply-To: <CAAVpQUC7hezdMEQkzAX4oqFdO_uzBmtRwn85_5_iWf4ExPqpTA@mail.gmail.com>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Thu, 29 Oct 2026 07:28:21 +0100
X-Gm-Features: AclHuK-x6fsuiHpokXnJ3Qx6-V8BzmKKkHRK86q2oMBiEy9ie31bHyN-v0SCuv4
Message-ID: <CACT4oueJgvE=CKSY2T2jkpD0cjT4bwU+ME4bb=j-cno2q57Kxw@mail.gmail.com>
Subject: Re: [PATCH net v3 2/3] net/ipv6: don't route packets with unknown
 source address
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eduard Zingerman <eddyz87@gmail.com>, Eric Dumazet <edumazet@kernel.org>, Florian Westphal <fw@strlen.de>, 
	Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Neal Cardwell <ncardwell@google.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, bpf@vger.kernel.org, 
	Breno Leitao <leitao@debian.org>, coreteam@netfilter.org, 
	Emil Tsalapatis <emil@etsalapatis.com>, Fernando Fernandez Mancera <fmancera@suse.de>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Jiri Olsa <jolsa@kernel.org>, Joe Damato <joe@dama.to>, 
	John Fastabend <john.fastabend@gmail.com>, Junseo Lim <zirajs7@gmail.com>, 
	Kees Cook <kees@kernel.org>, Leon Hwang <leon.hwang@linux.dev>, 
	Li RongQing <lirongqing@baidu.com>, linux-kselftest@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>, 
	Qi Tang <tpluszz77@gmail.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Simon Horman <horms@kernel.org>, Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Willem de Bruijn <willemb@google.com>, Xuanqiang Luo <luoxuanqiang@kylinos.cn>, 
	Yonghong Song <yonghong.song@linux.dev>, Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 1:02=E2=80=AFAM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
> This changes longstanding user-visible behaviour,
> so the series should target net-next.

You're absolutely right and I already agreed on sending it to
net-next, but sent to net by mistake.

Please review here and I'll send v4 to net-next.


--=20
=C3=8D=C3=B1igo Huguet

