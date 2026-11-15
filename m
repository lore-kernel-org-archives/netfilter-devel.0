Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.201
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794736397;
	b=Eo4shvZagWQ2KGc7GVBOsUivaBpKwqVmeyfQu/CRn9XienNK64EeL6G4RKdz5eB9QpWF
	 NThzD5IVxXpplZbRF96LdQBpSpDiLryfJRojjCA6qkMuZC9mbUAorxftnJU1HVPFfHOyi
	 DpUMgnTrMK/QnW8Gqe49yXNiXtDoIgER7wd7uqQhcByXgF7+IAm52n24CtonqUTnyZ0nn
	 bz8SX3dxvZ5dps7hRBTF9zToSgHQhleLJUsCNM69v+VugcUmmaQ5XY/lLONcjLcKJ+TvU
	 28EmQ01tK8NbuLJ8/hM0rT4xM0OAreFdMrO4igFnNNaje8ym/rJjmq/aE9u4GbKPqPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794736397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=efXNhlHEowKt9dg8T6Ua+qGUQ2u3K/ispp+N3lzQGXo=;
	b=rE2sM/f3m5cdBpRI3Xswemkn5VR3I6taqf3u3pkFj6O7+BqrrWKIVAoXiXOCXEOCOjyz
	 QEtpuIDkgduwPQLtCkSIvTwQpbcUi6FRDMde8b5nI1GKpETO8hHOb61JrkWAJgUdkwkPy
	 MkQqeLUBOT6Uuc+oCYNYxVpYFota6JhVpGy9me1yP+rnBEV5+GLTj87dHWhUZM2R/oIS/
	 rMxMaZeZOB/MZdNMyCKfW8ZlwBc2antXecBSjkLTCaHrjkcNQM9yoe+AKtay3RnSw1iMJ
	 bMHGE1Q0YyhWG3dylyDmChWDBhrbgtexz9jlH/zqguFJZd/KYnWSv6Y+X1ixymvx1kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i1C1cgFP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.201
Received: from mail-qk2-f9.google.com (mail-qk2-f9.google.com [74.125.230.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751BC606A31F
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 09:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 751BC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i1C1cgFP
Received: by mail-qk2-f9.google.com with SMTP id d75a77b69052e-55bf20a703eso10148571cf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 01:53:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794736396; cv=none;
        d=google.com; s=arc-20260327;
        b=hXKs0OiJeUNDLatPprVShFpjxY9N3APEFw+pmzf0xQxWOiadvwcInYQlIOENkDWquY
         1o99MCQ3+20FLjzbm8FIHHO0wVpKuJy+kYXhopbWTlnCuFMZpw7byEGKjj0i+FCqlJCR
         ezDRR4uK7goyq6cX3++MC37cNCW7DWe0ATDOog1yP8QMO1eXxKDWmBzNBYF5jbz7Bdwr
         nQ3U1GYeiBm7hEVPOB3RryJhT9qxhu8Izo2TRVcOVSglv5HWhxbkKa3EHqjjjHyPAnp1
         tXojfb8+/FACWxAgYNbVXEVReSuYh5fNvTC7LlJCaqA4Un6gnEUdyEGR9RgNmAo3kJW9
         nNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=efXNhlHEowKt9dg8T6Ua+qGUQ2u3K/ispp+N3lzQGXo=;
        fh=YRQR98mkBux6QelEMtGzYC3pbnUDKyph8sXtGzXvgDo=;
        b=N3LbZ+e8mkM3Ai7R9jGZ/lYLhHdhh7LJ0rSrab8oPE9ayl36ZEnfZDbMdivc/UR1Sp
         pqd9tCAw/ujDthn+6qDB7ZDB+tPBbBhJAZmQA6+gjXP2tGobhXfoPav4zGRSKbuRWI+m
         aja+NAi9fYxzEQH0KkAO7a2B1Ms8D9hMA7rdptDPf6M9txke5veXUWkeeBPZqZdg2M//
         D75zxcPVkQ3HqiygH+stOZMfZh41dkm7xFn50tVdKpsZ0or4HfQZ3NyZSkInlygzIpFl
         H6BxBPpen8FOhKpBj2kzCzsPdw23ffQ670dO3biq4jW9NVkIKwk8lzE47/+tdeuDNwn8
         p8LQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794736396; x=1795341196; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=efXNhlHEowKt9dg8T6Ua+qGUQ2u3K/ispp+N3lzQGXo=;
        b=i1C1cgFPGygjTdLz9ZP2JfTQtB7N08hB1v8oeV9xn6V0VyIRXQYfJQxH0u/4K8edtV
         2I8iWnAmIOPWMnM5JESk/rFu1Fw6kfcjBFYhiF+ezdb8CxOzJxi4kpDDJebYEEI2CdtM
         qiUIqvIeH4jgB+6RGa4i+XAT/yP0WmlsIrmQYCtHOAlNnscuhUbTrY1fAv/eCXvb15hl
         9U0EqlRFjKVX2euUJNKZzPpfRcLBi+r5oHD/QCwQ9dBw4rHg/fr03n1DVeuEcYMwoShX
         lJAplcbQ8mRNpDk5fpcu5DWl/uxQV69SUwxR9ASL7IgQzDH3S6RswgTb7Bc1+h+mFY/o
         irIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794736396; x=1795341196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=efXNhlHEowKt9dg8T6Ua+qGUQ2u3K/ispp+N3lzQGXo=;
        b=U/KliiSBqowX+cyU0aeUREQ5JXwKVQReZzQ+Gn9sQOSYY55NUxkN6yjYnzr+jk4PbY
         zUeD6qiD/SFOFyyZCYzOtKpYLOkcOQTZaVMqJaBjPJ4fHFsQXioGlmjT3uIksKkdS8ky
         KgYbI6rHfpIk4J3M6eJtMcD76/dfL+Pmpzyqw5Nt2mmEek8zZbvIZb+FFbRTRJrYtTFv
         fOvYvBquNsT3cleG/DmqIG/NZbOEqActFJBcvmz+LGcL+ZsT3iB5xdPl6SsraqPkxQy3
         TkI/s3s7p2zmialZGwIfDEMlE2KjCIZs6DZ0fW8RwiMHH68qi6s/rgpcVp23kYZWpFOj
         EFTg==
X-Gm-Message-State: APuU4Z+9gPopEihewkDoiDZY2pS+xWKensn8YyKMW2sTahG5TP/wL/JV
	4A8CXmbw6lpnGNaHoFlJEx14NRqw2D0NvDrF7ziq0W8J5JxYiFazTs1jAtCUIbs47cEOvIVnuLo
	9sKIrisMkmOrjDPLjVXZKB7STG9nspN/q/HFgUlQm7A==
X-Gm-Gg: AYBFou3FV3UJGgXJfpAGzI62/tzsRWvGyKfDHRsDmYxraHBUrG6ZBQizgJCT8v5pFXf
	P42r9bhWJGU4z/cDPfZrLbiCcvgnRfWWnjwU+MxO3rJ0LU2KL/zZauEL1LN3ex5lF523QqvJNrs
	iGHUD4NpZUZxE/y5jCYAZ/g8Zi5dEXfOscmqD3CLyqIcM2//cWzi6CkPyHCwvc73u9N7+5LnHnN
	pCFS3bJyM8pIb5EWLBoIato9gZTHo697dcYOD1skMAiWQmhrXEr6mv4adzOS0+2WSP6At/jIkAG
	oU0SbS85aKmwAA4QXtTImzy6DGSMbhk/mnnHOazFmPT8auxSaT6Jdrxq2TQ2Js66E1KQbzmoXuh
	lyZZHn1sjinGHM7oXU1C2C+Q03yElH1/7SgePxhjIOU3BZo6a5Cb8yEli2duOgofpk2+8OEVv8S
	OLYJZVfZ8/geNWHMcjIYHar/g2snwb4KpYnQW/+qj6KFzxuPs5cQ==
X-Received: by 2002:a05:622a:e44d:20b0:55b:b0a2:248b with SMTP id
 d75a77b69052e-55bb0a235a2mr61661011cf.34.1794736396437; Sun, 15 Nov 2026
 01:53:16 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>
 <20261106143022.412406-1-thisisforspotifyvikash@gmail.com> <CABkQbGJYRCts2h+U-7NxrY1+k6_Wo_bStnt8heJHL18b7yg_wg@mail.gmail.com>
In-Reply-To: <CABkQbGJYRCts2h+U-7NxrY1+k6_Wo_bStnt8heJHL18b7yg_wg@mail.gmail.com>
From: ss vikash <thisisforspotifyvikash@gmail.com>
Date: Sun, 15 Nov 2026 09:53:05 +0000
X-Gm-Features: AclHuK8WYya6WSyHbStkzU53YV3t6pJrBwVKMJroJJg-Mf0c4sh-6ZdMjfqaS74
Message-ID: <CABkQbGK2QV4riT9Q9mXBtHgxDJfLLeXN-YPR2hb7fewTWJcu_g@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: conntrack: document sparse hash table eviction
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, linux-doc@vger.kernel.org, 
	corbet@lwn.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Just following up on the v2 patch submitted on November 6, which
incorporates your suggested wording.

Would you have any further comments, or is there anything else needed
from my side?


On Sun, Nov 15, 2026 at 9:48=E2=80=AFAM ss vikash
<thisisforspotifyvikash@gmail.com> wrote:
>
> Hi Pablo,
>
> Just following up on the v2 patch submitted on November 6, which incorpor=
ates your suggested wording.
>
> Would you have any further comments, or is there anything else needed fro=
m my side?
>
>
>
> On Fri, Nov 6, 2026 at 2:30=E2=80=AFPM Vikash SS <thisisforspotifyvikash@=
gmail.com> wrote:
>>
>> When nf_conntrack_max is significantly smaller than
>> nf_conntrack_buckets, the hash table can become sparsely populated.
>>
>> The early_drop() path examines at most 8 consecutive hash buckets
>> when searching for eviction candidates. Under table exhaustion,
>> this bounded search may fail to find an eligible entry even when
>> evictable connections exist elsewhere in the table.
>>
>> Document this limitation to clarify the implications of configuring
>> nf_conntrack_max significantly below nf_conntrack_buckets.
>>
>> Signed-off-by: Vikash SS <thisisforspotifyvikash@gmail.com>
>> ---
>>  Changes in v2:
>>  - Reword documentation to provide configuration guidance,
>>    as suggested by Pablo Neira Ayuso.
>>
>>  Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Document=
ation/networking/nf_conntrack-sysctl.rst
>> index 4426cce2a..c7e9016ac 100644
>> --- a/Documentation/networking/nf_conntrack-sysctl.rst
>> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
>> @@ -99,6 +99,10 @@ nf_conntrack_max - INTEGER
>>          the reversed address). This means that with default settings a =
maxed-out
>>          table will have a average hash chain length of 2, not 1.
>>
>> +        Make sure nf_conntrack_max is equal to or larger than
>> +        nf_conntrack_buckets, otherwise early drop may fail to evict
>> +        entries when it gets full.
>> +
>>  nf_conntrack_tcp_be_liberal - BOOLEAN
>>         - 0 - disabled (default)
>>         - not 0 - enabled
>> --
>> 2.34.1
>>
