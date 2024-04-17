Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE7413C3E0;
	Wed, 17 Apr 2024 12:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358346; cv=none; b=FpdFsFKGle5T4NtdOQzyQX25gJVrlJJrqK9xYfAN4v88GAaUNn3xt51Ad2RkyyjN6AwTu9UzHVpKTfjn3Ey/QLPz3g7SgUnpWpRHTiMWpBbrZjHnsZU5KR5w+ao80meHQ7g3vtovxOBQLjnfeFmHGTSFhCLjsBZNgqHAPCLlbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358346; c=relaxed/simple;
	bh=CIARPDEkT/PufSOItygF2ekkvf8imZEL0KodjJl1URA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=mBNziXO4T4Cbph8u5SCt9fwoKXLX2bIB6M1G4c7SR6yvZbuC2thpmnsPyLiBqPdcSxEMPuuuRs4Nr3v2pQVf+zoJLjAvDRu6G3E5Q5MrZepyxLMTKi5ACs+PK77huiJT45HCJhPScVSwuslAIReCZKu/3q+qTLyyW/3kHnxwDoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKg0Z6rj; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKg0Z6rj"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c728a8035eso814517b6e.3;
        Wed, 17 Apr 2024 05:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713358344; x=1713963144; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j3si0qdlP2HDJbxoRHAt9hQ+nmNbH7ViSvHZJ8Pe6JQ=;
        b=gKg0Z6rjDobL+9TkMjWmV4b37tbiTXKeWVaYa93aQeuIZhIUMbUc/yJqVCDBYoRAAe
         tEpK6nZGb5A28hkkYv6F0QENV4q6PgvN5rxzjVmR0cDqNkXLERrrFvJJnQm5fyYvk7BP
         eyPllfqD06z3+Lrj7Aa+IgSZCniFHYlkPrqv03BE/UD61+GN68NG3oh1cDUcz/In1u+E
         V+dHhy9hifPb88auZCi87+T67m7NHK1iZ1vwW6KqOV+KrYTaQx3xcM5bF6r0oiwYw4Ga
         g+0AY01Jr5CHRv0nFxzF/fqAdnosU/IvmLPsgISDOVJCodMc4oHpOJEEhsRE61OnHvAv
         24sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358344; x=1713963144;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3si0qdlP2HDJbxoRHAt9hQ+nmNbH7ViSvHZJ8Pe6JQ=;
        b=YVFl/zu1YDUkh0P7lSYBTEW+lBwPZkcPGL15XSi/VWqu9QvQJownVRed3yqA6CkvNk
         kfk08VhWTiO+FFUiN9cNOoRqv9oNYu2tyDAetaLP5TJ3GfR9RegtgrYr08RBi7U7gqqo
         9UvrFJ4ggJjMNzG4YlC0cY8y+rEnxvYM48ZNerRfPvcNkJz1twmN5qRyE64J2zsUgu4U
         oU9AvFGuf9L/unkpNs4U4tbLlTy2Kw4Hv7qC0GRC0V8tvomtqA4xCOEMZosN5nu2ZLxW
         TmWgrkMHmTIz1W2KSAzoxVe+XHG10Jpgnjdtj+OdUEuarnPhR4bbH2j+HrrhS96T0ljC
         RLzA==
X-Forwarded-Encrypted: i=1; AJvYcCUW0SBpyzjqmnv8oj7YDo2WM7U1DYxQfO7XSsihedca3xmU/YnoOLuaR3EZGe0KZOVMzm5aeOuJDs+HGSaF/WZYDeLm7lz+Q+EaghdKhx1G
X-Gm-Message-State: AOJu0Yz0UEEUmpHlLl4uFp9gCtel04ayT8r2/CUZCQCy816UXx1PImpA
	wRPJGFF1lZPMQqhGK60U+MpnEJfRLsNWWgoBPbvMaFqi9MyJR3rS
X-Google-Smtp-Source: AGHT+IFq1grycNHAciyXEGxEi189dN73bnyT7hlhaj0gexK9XiDyZEIdiSF3GVmV8vbE6XyA6P7AHw==
X-Received: by 2002:a05:6808:2803:b0:3c5:f302:e7d8 with SMTP id et3-20020a056808280300b003c5f302e7d8mr17096034oib.48.1713358343894;
        Wed, 17 Apr 2024 05:52:23 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id t12-20020a05620a004c00b0078d43da0be3sm8356710qkt.5.2024.04.17.05.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:23 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Jiri
 Pirko <jiri@resnulli.us>,  Jacob Keller <jacob.e.keller@intel.com>,  Pablo
 Neira Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik
 <kadlec@netfilter.org>,  netfilter-devel@vger.kernel.org,
  coreteam@netfilter.org,  donald.hunter@redhat.com
Subject: Re: [PATCH net-next v3 3/4] tools/net/ynl: Handle acks that use
 req_value
In-Reply-To: <20240416191016.5072e144@kernel.org> (Jakub Kicinski's message of
	"Tue, 16 Apr 2024 19:10:16 -0700")
Date: Wed, 17 Apr 2024 13:51:38 +0100
Message-ID: <m2mspsgnj9.fsf@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
	<20240416193215.8259-4-donald.hunter@gmail.com>
	<20240416191016.5072e144@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 16 Apr 2024 20:32:14 +0100 Donald Hunter wrote:
>> The nfnetlink family uses the directional op model but errors get
>> reported using the request value instead of the reply value.
>
> What's an error in this case ? "Normal" errors come via NLMSG_ERROR

Thanks for pointing out what should have been obvious. Looking at it
again today, I realise I missed the root cause which was a bug in the
extack decoding for directional ops. When I fix that issue, this patch
can be dropped.

>> diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
>> index 6d08ab9e213f..04085bc6365e 100644
>> --- a/tools/net/ynl/lib/nlspec.py
>> +++ b/tools/net/ynl/lib/nlspec.py
>> @@ -567,6 +567,18 @@ class SpecFamily(SpecElement):
>>            return op
>>        return None
>>  
>> +    def get_op_by_value(self, value):
>> +        """
>> +        For a given operation value, look up operation spec. Search
>> +        by response value first then fall back to request value. This
>> +        is required for handling failure cases.
>
> Looks like we're only going to need it in NetlinkProtocol, so that's
> fine. But let's somehow call out that this is a bit of a hack, so that
> people don't feel like this is the more correct way of finding the op
> than direct access to rsp_by_value[].
