Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gXEAbsi7"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BE31AE
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 05:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700744876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rcLUnZiLUv4jXexjrcy+eYgNvrpmaq3+GkNtlMTDLf4=;
	b=gXEAbsi70izw1JZpbYjfRbDk0SQsdc/kHFlycQkpHxVkb2NtZE8rNW9WiHqFCSwtOyhQTz
	3tubg0kCM6BtEpPHr7bN7LjMQ4ggagJQyr5bpHXcZivdUdDgJwxHSQq9JkJNtFNpEogkd4
	ohaGipFQqHmf2oCEnGMhyZjrRVSdSIc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-3TI2iHezP1aDwIYHFhHmQA-1; Thu, 23 Nov 2023 08:07:52 -0500
X-MC-Unique: 3TI2iHezP1aDwIYHFhHmQA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32d933dde69so121028f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 05:07:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700744871; x=1701349671;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcLUnZiLUv4jXexjrcy+eYgNvrpmaq3+GkNtlMTDLf4=;
        b=hMQjWPruIjXhTnq7TYHKRnJJEv9x/6M8R2g+AqgCsfvibsuVafGuSu3HZuaxHIqyfq
         q204ow1e+yUjM0yMQoyC7WHmWrYS2EYVorBYssskE2s+yuKWPRchFUaYve/Y6bqMLmLY
         Vc2XO4bXA35HyNTg5n0FgCakoDBV0+P7e3x9tlHJNRqikFaqfy9ydrYTnjYHr8OdOp9n
         bImLUIq97yFdK6cA5DqmkRdgLtELSqdi1u4+HZwfQsEtcvWKYVfhWR6fcCAioK5xGpeO
         gctzvWF1g+YErJcGyA7kVhJyOTrGG+gcelKZJWDLCwkJBLn9Pw91qoG+efz6S5NargVq
         iN4w==
X-Gm-Message-State: AOJu0YyOYt9sVAZfX7IXsvu8CppZFYn77sAmRxdwxDWK/Uc+uBkVb9HZ
	kltR1ke9Qb9SiTd7gfMryqMO+dbTSXkSffU2+1fQ5j8UdxyAIwUlSba+p0QziAIgJ5G/fAIr4Td
	70hl2jkeN88YBrcaYmZ8nUmrrPEzm9BKboIKw
X-Received: by 2002:a5d:5b8d:0:b0:32d:c293:1ab4 with SMTP id df13-20020a5d5b8d000000b0032dc2931ab4mr3573777wrb.6.1700744871332;
        Thu, 23 Nov 2023 05:07:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEc4ofOEHz7qeW96LwlIGUd3M+MoysXpRelzoNdYdeuntsMHbmPRbMug9coV7SlnbFVEB68tQ==
X-Received: by 2002:a5d:5b8d:0:b0:32d:c293:1ab4 with SMTP id df13-20020a5d5b8d000000b0032dc2931ab4mr3573748wrb.6.1700744870510;
        Thu, 23 Nov 2023 05:07:50 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id w3-20020a5d5443000000b003140f47224csm1624551wrv.15.2023.11.23.05.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 05:07:50 -0800 (PST)
Message-ID: <17362139899b24a4433c6f1ec18106a064bd85f7.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests/shell: accept name of dump files in place
 of test names
From: Thomas Haller <thaller@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: NetFilter <netfilter-devel@vger.kernel.org>
Date: Thu, 23 Nov 2023 14:07:49 +0100
In-Reply-To: <ZV8uCk27rVe5ts9t@calendula>
References: <20231122182227.759051-1-thaller@redhat.com>
	 <ZV8uCk27rVe5ts9t@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2023-11-23 at 11:48 +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 22, 2023 at 07:22:25PM +0100, Thomas Haller wrote:
> > diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
> > index 3cde97b7ea17..c26142b7ff17 100755
> > --- a/tests/shell/run-tests.sh
> > +++ b/tests/shell/run-tests.sh
> > @@ -431,6 +431,19 @@ for t in "${TESTSOLD[@]}" ; do
> > =C2=A0	elif [ -d "$t" ] ; then
> > =C2=A0		TESTS+=3D( $(find_tests "$t") )
> > =C2=A0	else
> > +		if [ -f "$t" ] ; then
> > +			# If the test name looks like a dumps
> > file, autodetect
> > +			# the correct test name. It's not useful
> > to bother the
> > +			# user with a failure in this case.
> > +			rx=3D"^(.*/)?dumps/([^/]+)\\.(nodump|nft|jso
> > n-nft)$"
> > +			if [[ "$t" =3D~ $rx ]] ; then
> > +				t2=3D"${BASH_REMATCH[1]}${BASH_REMAT
> > CH[2]}"
> > +				if [ -f "$t2" -a -x "$t2" ] ; then
> > +					TESTS+=3D( "$t2" )
> > +					continue
> > +				fi
> > +			fi
> > +		fi
>=20
> I think it is not worth, users of this infrastructure is very small.
>=20
> So let's keep back this usability feature for tests/shell.

OK. Fine.

But while closing and dropping it, let me still make the use case
clear.


When I look at a patch in `git-log` and see for example the diff-stat:

 src/json.c                                                       |  25 +++=
++++++++++------------
 src/parser_json.c                                                |  91 +++=
++++++++++++++++++++++++++++++++++++++++++---------------------------------=
-------------
 tests/shell/testcases/chains/dumps/0021prio_0.json-nft           | Bin 615=
09 -> 61639 bytes
 tests/shell/testcases/chains/dumps/0042chain_variable_0.json-nft | Bin 952=
 -> 1046 bytes
 tests/shell/testcases/chains/dumps/0043chain_ingress_0.json-nft  | Bin 619=
 -> 632 bytes

I'd like to re-run those tests. I'd like to do that by copy-pasting the
file names at hand into the terminal.



Thomas

