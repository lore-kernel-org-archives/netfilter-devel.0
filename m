Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B85337F8CA
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790522650; cv=pass; b=sBjf9ZlyrbIsI7kCPcehov6UYC7Pie547VM/tgEEi6B/Ckgzo7nAwgATxd1GkNtNX+M3ojqqEpZlH8PwX/8Aw+xOOmm6q3SR/FiBKWwOFsO+XuUgLHIYk/3DnIsFbJFqL/czUm815+rYoivZ51dGIAuIMNpcYTF5eZAgYLseIdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790522650; c=relaxed/simple;
	bh=IqYOXuenTrd/G7JC31ZlM5cYuEr0pOS90JESQYxp+5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWns8NDeS70Tg6l0eufLD9lBetubwq+24A7qRf2PraQ2BVy0R/ndu8QXALs1eZDf0OFaEBEo7g+dtpTFmzGG6I8JadUAZZl6SaFP5aHD3xvF2IcvaZ7kl9NFHi0A4BiAzAUFNf/kdndPoOhfdH9tXoHhII0JtQ9SOzoaHKzDjhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=bvDNLnlw; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="bvDNLnlw"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a20f06cce6so25880511fa.1
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 08:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790522647; cv=none;
        d=google.com; s=arc-20260327;
        b=PJd/zjckLbkiWE78jdhi1H3+glsZ6IycBATM6pDlFKNYsUeV+h88mUnIA/6+tMRaqm
         Uda3FvLOxqnZfpQs3Y7omd4Ztw+aIxjmd2k7wU27ToGxgeT6U/7+exYPPeQtNA2c16Qu
         i6p55bRh7strHnY4MGof+OmO1sPrGo1ym5TAscet77SKHHY0jR9cUYXOlk9YyefDq1fS
         HZDjVroRnE706c9FXuxHWP6At8p/IGnTQ/+MRhxjk1YPKPBjpqX/c59LvDLn9JMNGRsj
         MhkkMdXLLePqxQNh3lbOqq+LVsMOVuVw0QzZxee5nrCvbRcgpMd2918syO2ow3Eja0sq
         CgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lYYzgThSGrD/5n0iLNuP+nmqXn5Ij30rBL7XkqdHCKk=;
        fh=5IerBvNkXVt6S3qY0BfOGTAZD/Bt5iEm4wUqbhJOb8c=;
        b=fvQ1wxMnZ6ER0gfyu33rW4EUzAiyA9O9XOUSjhSDPucGAhsaQDDbpOi1atdX2EhSl0
         hMQH/xL1YAitrtjpg33jGpumrSZVY5TN6jmm3yDubqdb7dAy7JgoZZH5qO+Fd1FQkkxG
         /816BLAYOy9RdocMrCOZv3dyROhzSYmgxOmUA4LUv4mAFAHZA7c/9HwkXXREL7E+hSHR
         tr6jA+orfEdlTzBfDr/mUrU0NNH4zcEt8G5z7zSwFBSSHB4dvUDeVbbEVboIlUPrmQhO
         1SDIZCNq5PfpDp9XcBbAKT9dTt+vsgr1wwhdrHkUTv0m02+cWOvVxJjWR/Olqh5QFatw
         lldg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790522647; x=1791127447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lYYzgThSGrD/5n0iLNuP+nmqXn5Ij30rBL7XkqdHCKk=;
        b=bvDNLnlw3JWJDcmPd1MdT2k8B/AD8S1/hBjBPSJfveFXjXweDtRMb6xHaSLFcvHEjt
         6hceiOSwN3ndIPKPTRB/32pmlI4+YDqNN+sDOcKC1rQGCzDtFsPOr9HQhltk2PXDoCuH
         B/VJXKsTUvALDvnAI1c1VlIlUOZGY47Lteh4Qh5aLu1vvbkOWw6Godf5Fp65Hnq/16/6
         0sZ34cy7So17e4pmIjOnFVt0YWZFID3UogeyuNN9qeWCLFNziTUhsrQDC8aE70EOf7sO
         u9IoXKkjPfhv/GtIJO52vYBzc6W+gjv17Lc3Jx6EXZ52ymTPadq6FT6DqDkGKn9xuI7i
         XnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790522647; x=1791127447;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lYYzgThSGrD/5n0iLNuP+nmqXn5Ij30rBL7XkqdHCKk=;
        b=tS3mOXWmdb3OMXFh7bVlPbBe1yi5LEdPQ8w3tEZHTBS1bSbVTqlZDmV47xZa0/NNAt
         PK818cvcobMRpQ5MpGukaV4meOwbS3Fh6RZGPL2gjfebd3S4tRP//FBSIVPSRxoxuqkz
         Ww9b4CGcOSUJJjmNu8SMxOcTp/e/LXvSYBbQkuhDTGZRtCmWZtDy7sAnyWW4tD9cztYe
         XNbsbiCrH6QxUBYbyNQDZw99YGcwEPOhvSEoaDMytdKQOVGyR6wPxIqfVuF8DTsJ0GLC
         T0Cue9iFcBvvkVJSu6tu2JutF3kVqqZmQ8U74rggCob/KC0vnT1vNbcHubJ8EOy7z3gr
         5SBw==
X-Forwarded-Encrypted: i=1; AKwUvBw4zMTQt34C6bEFMNLRpbTWD7pUzT6e95e4mUfVMT7HWLVRCP9RuSYcHjF91YahjfogMhCQdY9rHcOZ4KKFW8A=@vger.kernel.org
X-Gm-Message-State: AFq9FYLrMmOCJnX9BUZznFOE42K08HVWnWAdP2hZ7czB1LOJd7I4sWix
	7Eq25Qy/QdKXHaS7GoLcA9Hfd2mcghFAXEChVz/1092dyxMM8u7bvIqkSiaaN50UmFLSVwGY+/X
	/zbADwVL64FrpxMQRqREd10zlJ26DLM6H1xneqpeaQlE=
X-Gm-Gg: AYBFou02aM0Rx/6h1yCFyWWuitbrYbTIMGBXKjGwwckqFaxfIN2qxAUE3MG46VMPWcx
	Qv1PTAwcMtO5yu6YxR+8zvoEgTopezrKK6WZqceuXXHisirED7jLIZem9IcGt0bwLVdsKtdUdF3
	C5+/0el9wy6mEV58KLWCmqvieeBPvYlBxHPZqOA/hl8jLO7P0ngk1Vu+G1hF/S/EsB086noiXJK
	bJh7Zt4jpV2vq65Q0BgVlqv+VS/pgmWluMIyHmxIwAQlu4A3yGxAOyWcyciOufFqLJz3peAzfq7
	1KCCdFUKlvGKbs9zE3mpszDVZBSZb08j4D0wfp07bsy8hzd8nac7+ON7w5V8IGCaMcF9Kd1/c2N
	gi4LD6agAYg==
X-Received: by 2002:a05:651c:1585:b0:3a3:61ec:43c7 with SMTP id
 38308e7fff4ca-3a63c2fbf19mr25857111fa.24.1790522646186; Sun, 27 Sep 2026
 08:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790266803.git.zihanx@nebusec.ai> <ce3d490f-4be4-7eaa-0993-c1e4d1fd863c@ssi.bg>
In-Reply-To: <ce3d490f-4be4-7eaa-0993-c1e4d1fd863c@ssi.bg>
From: zihan xi <zihanx@nebusec.ai>
Date: Sun, 27 Sep 2026 23:23:52 +0800
X-Gm-Features: AclHuK_dLGbaKOOdt-gDveLynvCg56unCBYk_KeFbEJfV6pwu-pvHxZdAFl9y-U
Message-ID: <CAANe3eTgtXLVzrXuXQykh67XaUzGj-kWKzB1Sp0fwT0kZ_74Pg@mail.gmail.com>
Subject: Re: [PATCH nf v5 0/3] ipvs: avoid stack overflow from recursive
 connection expiration
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, horms@verge.net.au, pablo@netfilter.org, 
	fw@strlen.de, phil@nwl.cc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 10:07=E2=80=AFPM Julian Anastasov <ja@ssi.bg> wrote=
:
>
>
>         Hello,
>
> On Fri, 25 Sep 2026, Zihan Xi wrote:
>
> > Hi Linux kernel maintainers,
> >
> > We found and validated an issue in
> > net/netfilter/ipvs/ip_vs_ftp.c and net/netfilter/ipvs/ip_vs_conn.c. The
> > bug is reachable by a non-root user via a user namespace and a network
> > namespace.
> > We've tested it, and it should not affect any other functionality.
> >
> > This series contains 3 patches:
> >
> >   1/3 Fix the timer callback race during IPVS connection deletion.
> >   2/3 Replace recursive controller expiration with an iterative cleanup
> >       path.
> >   3/3 Reject zero and configured FTP control ports as data ports.
> >
> > We will provide detailed information about the bug
> > in this email, along with PoCs to trigger it.
>
>         There are some valid concerns in the Sashiko review
> that we should solve with v6, so we are dropping v5.
>
> pw-bot: changes-requested
>
> > Best regards,
> > Zihan Xi
> >
> > Julian Anastasov (1):
> >   ipvs: wait the running timer cb on conn deletion
> >
> > Zihan Xi (2):
> >   ipvs: avoid stack overflow from recursive connection expiration
> >   ipvs: reject FTP control ports as data ports
> >
> >  net/netfilter/ipvs/ip_vs_conn.c | 117 ++++++++++++++++++--------------
> >  net/netfilter/ipvs/ip_vs_ftp.c  |  18 +++++
> >  2 files changed, 85 insertions(+), 50 deletions(-)
> >
> > --
> > 2.43.0
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>

Hi Julian,

Thanks for the review and for preparing the timer-callback fix. Understood
that v5 is dropped and the series will be resent as v6.

I=E2=80=99ll revise my iterative-expiration and FTP-port patches to address=
 the
relevant review points. Once your v6 patch is available, I=E2=80=99ll rebas=
e the
series on it and recheck the combined changes, particularly the controller
lifetime handling. I=E2=80=99ll also clarify the active-mode condition and =
how the
FTP path can extend the controlled-connection chain.

Regards,
Zihan
