Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FE4184F
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 04:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749528349; cv=none; b=KLfyz1TS+Sd+HYIuTceUIsuSy3VnngwJ23HgD9UmzA41QNV9vfLxhgFuzOpWC1Mh6Q6n8G1BqUaj2xQwT2+O7N1asxTZO0ztXNOkLhWNM8nY9N6zi29cjZQ6J4a+euABq1WejIJtJ+yG68lbe8+BKv+b2n8WdtPHLOnb6+OaG24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749528349; c=relaxed/simple;
	bh=Xz8K6l4Pu2EPC5lUZt4DZVl9+ZU96oEVvlIFSmPOGm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hf8uG7hrZwAjZz05u+T4gbx/pkRuQ27EoUxJV0dM2WAKxAcibrbugQHbGX64Oks1Y922EoDy2WGYVp4zqJ6LM/JLUjZKjIHIpFMzosSpnS6tXkYPIvF9sR9OTprG2SSwYOs4P9BheKS8EDSUZSTgcf5FyCz+022FG18VigD4maE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1fkDYt2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1fkDYt2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749528346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YATybFTSWf8UqRijYEI/PntR2EcwOmsrBeey7r9kmWk=;
	b=Q1fkDYt2qaIxVDs4Q1e7bXoJras+gUWM9CzAC0RI1gvsCqPB4lz733veE98+0FSqJTGEqx
	8x6exzq1GYm5k2G1ZUhSC77ztXGFAuXewq2x1Z0yOwU8ou5OF9Rvg8Up4RvqGPXYNQanaj
	+4U0OfBwbBwErFf/rM5g9JjoMBGIkvo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-Pwp-LSMnO-SpjJilZ8Xx1Q-1; Tue, 10 Jun 2025 00:05:43 -0400
X-MC-Unique: Pwp-LSMnO-SpjJilZ8Xx1Q-1
X-Mimecast-MFC-AGG-ID: Pwp-LSMnO-SpjJilZ8Xx1Q_1749528342
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-313360ce7fcso4213226a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jun 2025 21:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749528341; x=1750133141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YATybFTSWf8UqRijYEI/PntR2EcwOmsrBeey7r9kmWk=;
        b=K9o+Q2Q29kPER3WHPf1L6ECkfJCfxRk/uSJGkj4KQooqg7IELxYdzlcpEZDh+VIDes
         529i2C/X2y2udJwdKPDUVASEVGGcSSiJSfUi4A0Pz+2bxvptzKNfIST2hPNEIlDUnWGV
         m6RINi+Pm3h9TCyf8mxE9A9QAFcXFBSVfAfX5EnItIxa5lnMtGKdVCfODo/PMFIwLlUw
         BqNPVuTaU0zyM6HxAzAyLSEsGRxgMqHl4ss2ggClLiA+f3Plmo7lry73PvW/xZKEbWvF
         n1JgFxJdQrAGyB41VUcdB/c7xHpZ6hNkikjgtmtD7QhrlbanHnKIdiuSzBP7SZwFaoNo
         QliQ==
X-Gm-Message-State: AOJu0YzJ+PyThBFWOIZ44w5IEC0sqfQJD0swcUYMVNw11dIKqiDKgbdq
	/HJG2TThkgKV6g049I7M359GCMaEy5oFUAXHOdSG8cN1IK8V3Y/afCsCVCse2hC8GR8H75IaTK0
	LOXtk2d70mNcIsHa9QoxsL0Qfj6SoD3ZYZnotkMY70MicBGLzeY4VXsK9TAfQymmUkeuCDdBIyo
	T2c0bsk4dNo5QzKba8PgpYqcbkEZLT97TTpO/FEBcSFP75Ow0JTynx588=
X-Gm-Gg: ASbGnctYAs9hP/pxObb5NOPAEjL4PtQGbd9zZNCx8/QeD2Cpx81wt0zL5etLPZGikkm
	YG7JOV9jrnTlh3IA8ISaowVjID8oGlI79RPZ4ev3KuvxTrgAbz0qcQbA/lmwXDy71Z5r5e/gdL3
	5hgZ7I
X-Received: by 2002:a17:90b:1809:b0:313:3f33:6b95 with SMTP id 98e67ed59e1d1-31347409cfdmr24608319a91.16.1749528341411;
        Mon, 09 Jun 2025 21:05:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOSyDGDyQKnn+sX7GS/djVQQTee6VScfrJ+s4Sj7z1s/TRatL0ScIk5aVAUStU/ck15fmuYlLY/0YrnCnAmvU=
X-Received: by 2002:a17:90b:1809:b0:313:3f33:6b95 with SMTP id
 98e67ed59e1d1-31347409cfdmr24608289a91.16.1749528341054; Mon, 09 Jun 2025
 21:05:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605103339.719169-1-yiche@redhat.com> <20250609081428.9219-1-yiche@redhat.com>
 <aEdTln3VvlQNgPXT@strlen.de>
In-Reply-To: <aEdTln3VvlQNgPXT@strlen.de>
From: Yi Chen <yiche@redhat.com>
Date: Tue, 10 Jun 2025 12:05:13 +0800
X-Gm-Features: AX0GCFt7Q3bLAA6Jf9cEP3RHvuxSsTFOENvtQmo3kzoDcJy1f8hc3NoE3zdbrI8
Message-ID: <CAJsUoE2oBU-0BvbaKdaHtjUO4+cXaczNMz13iTsPAgJy6wC4CQ@mail.gmail.com>
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Indeed, both passive and active mode need to preload the nf_nat_ftp module.
The patched script passed on my side too.
Thanks for fixing mistakes in the script!

On Tue, Jun 10, 2025 at 5:35=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yi Chen <yiche@redhat.com> wrote:
> > This test verifies functionality of the FTP helper,
> > for both passive, active FTP modes,
> > and the functionality of the nf_nat_ftp module.
>
> Thanks, I had to apply this delta to make this work for me, can
> you check that it still passes on your end?
>
> I guess nf_nat_ftp module is already loaded on
> your system, its needed for all tests as the FTP server
> is on a different address than what the client connectects to.
>
> The important changes are:
>  - load nf_nat_ftp early
>  - use ${PCAP} for last tcpdump too, local dir isn't writeable
>    in my virtme-ng setup.
>
> Rest is debugging aid/cosmetic.  The curl feature check gets extended
> to skip in case curl exists but was built with no ftp support.
>
> I removed -s flag from curl, this also removes the error messages,
> if any, which makes it harder to debug.  Its fine to have more
> information available in case something goes wrong.
>
> I now get:
>   I: [OK]         1/1 tests/shell/testcases/packetpath/nat_ftp
>
> No need to resend unless you want to make further enhancements.
>
> diff --git a/tests/shell/features/curl.sh b/tests/shell/features/curl.sh
> --- a/tests/shell/features/curl.sh
> +++ b/tests/shell/features/curl.sh
> @@ -1,4 +1,4 @@
>  #!/bin/sh
>
> -# check whether curl is installed
> -curl -h >/dev/null 2>&1
> +# check whether curl is installed and supports ftp
> +curl --version | grep "^Protocols: "| grep -q " ftp"
> diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testc=
ases/packetpath/nat_ftp
> --- a/tests/shell/testcases/packetpath/nat_ftp
> +++ b/tests/shell/testcases/packetpath/nat_ftp
> @@ -22,7 +22,10 @@ assert_pass()
>                 echo "FAIL: ${@}"
>                 ip netns exec $R nft list ruleset
>                 tcpdump -nnr ${PCAP}
> -               ip netns exec $R cat /proc/net/nf_conntrack
> +               test -r /proc/net/nf_conntrack && ip netns exec $R cat /p=
roc/net/nf_conntrack
> +               ip netns exec $R conntrack -S
> +               ip netns exec $R conntrack -L
> +               ip netns exec $S ss -nitepal
>                 exit 1
>         else
>                 echo "PASS: ${@}"
> @@ -43,6 +46,9 @@ PCAP=3D"$WORKDIR/tcpdump.pcap"
>  mkdir -p $WORKDIR
>  assert_pass "mkdir $WORKDIR"
>
> +modprobe nf_nat_ftp
> +assert_pass "modprobe nf_nat_ftp. Needed for DNAT of data connection and=
 active mode PORT change with SNAT"
> +
>  ip_sr=3D2001:db8:ffff:22::1
>  ip_cr=3D2001:db8:ffff:21::2
>  ip_rs=3D2001:db8:ffff:22::fffe
> @@ -86,7 +92,7 @@ reload_ruleset()
>                 chain PRE-dnat {
>                         type nat hook prerouting priority dstnat; policy =
accept;
>                         # Dnat the control connection, data connection wi=
ll be automaticly NATed.
> -                       ip6 daddr ${ip_rc} ip6 nexthdr tcp tcp dport 2121=
 counter dnat ip6 to [${ip_sr}]:21
> +                       ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dp=
ort 2121 counter dnat ip6 to [${ip_sr}]:21
>                 }
>
>                 chain PRE-aftnat {
> @@ -103,7 +109,7 @@ reload_ruleset()
>
>                 chain forward {
>                         type filter hook forward priority filter; policy =
drop;
> -                       ip6 daddr ${ip_sr} tcp dport 21 ct state new coun=
ter accept
> +                       ip6 daddr ${ip_sr} counter tcp dport 21 ct state =
new counter accept
>                         ip6 nexthdr tcp ct state established counter acce=
pt
>                         ip6 nexthdr tcp ct state related     counter log =
accept
>                 }
> @@ -142,7 +148,7 @@ reload_ruleset
>  ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/=
null &
>  pid=3D$!
>  sleep 1
> -ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121/$(bas=
ename $INFILE) -o $OUTFILE
> +ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${i=
p_rc}]:2121/$(basename $INFILE) -o $OUTFILE
>  assert_pass "curl ftp passive mode "
>
>  cmp "$INFILE" "$OUTFILE"
> @@ -155,19 +161,17 @@ assert_pass "assert FTP traffic NATed"
>
>  # test active mode
>  reload_ruleset
> -modprobe nf_nat_ftp
> -assert_pass "modprobe nf_nat_ftp. Active mode need it to modify the clie=
nt ip in PORT command under SNAT"
>
> -ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2>=
 /dev/null &
> +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/=
null &
>  pid=3D$!
> -ip netns exec $C curl -s -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/=
$(basename $INFILE) -o $OUTFILE
> +ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp:/=
/[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
>  assert_pass "curl ftp active mode "
>
>  cmp "$INFILE" "$OUTFILE"
>  assert_pass "FTP Active mode: in and output files remain the same when F=
TP traffic passes through NAT."
>
>  kill $pid; sync
> -tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q F=
TP
> +tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
>  assert_pass "assert FTP traffic NATed"
>
>  # trap calls cleanup
>

