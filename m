Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594933506D
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761660401; cv=none; b=BMwIbpUv4WlhM5O725CYXfTDdqGAvuW7usWV+dvdCRGj+yq8IouUGsLLuk9M8ECuuQbbZoJz2EOzM3q1w5VBYphazTthCyrLhJJvMUDIGNhJmpL3vnuvH9gLi2QE3F9heKUrHn3zfQlFT1NRqj27BC4GNKfeLG+P5UIXbf354xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761660401; c=relaxed/simple;
	bh=sK1dkj24E2LvR4CP4fxy6up+PxJjiBCYHC/WYb9KaKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dEDyEXxdxVcbcFED1lOVomFjkmMdjNpEdKfKbZiiARGdt0sxWJP26yL1CKo/IggbK7Q/Y9/mCgYyPLDsda3KIzBjTd5C8NMJt6SRQi1b5v9aFkpXuDkv2iDiwYRxIvRCfdfuJ22W+N/Jc0hyA2OOm9tjLgfL38rKfgxjWWzMQDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=NZGSSu2G; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="NZGSSu2G"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d6014810fso60032557b3.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 07:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761660398; x=1762265198; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+LjgFkx4pDFZc7RYvVUPZ4+JTH6n0r8grvQPJ3+EG4=;
        b=NZGSSu2GVswQGuNS4yXjy83zpGZ67f0hy7IIJwcraGcN3marCmW3a72OrSVWQVIGP5
         7QNSFZwbxPKS6hxGH91njMX5ejln+0LUogX/G9QcnWf8jTjUKZiIB1BpdXhdOL+LCAOn
         UC0DE2ZHw/8mFhR3FGMvQbyUVgafrXPvZLZcvH9guZFzw6nKgzdaOMTIBbZyrO01hKww
         VZn5FXc4SF44V7O7odFVDTTswM5jhdwpX3VlX8LHbVx1FV+x541XTG+JttFc5D0NYYRK
         YKPkOLsrN6vS+R9MqxIAwbrh5+vjK3e9Ble3383iFuVymQw94r4VuHM0CL4FN51H7VKC
         XucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761660398; x=1762265198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+LjgFkx4pDFZc7RYvVUPZ4+JTH6n0r8grvQPJ3+EG4=;
        b=qFDp2eP22+gCdMw/LrLjL6UObm20sJwt67rG2qsovEgCQaoHkDR8pyC52CtWJ+lVRY
         Ikr7t4jjSuTKQTfnvQj6Ozbtr0u4BU2X7ngTYimhRPvZR58cVLaaN4i7UKdc+ufvtigK
         arUYs0pvYHQKxow3R643Jbzk8paun6Cr21ppWoYQ8R4NN6CW79OGuw7PJby1vTtoEVO7
         LvgsLpewBl7gELu5ZidIoI7zFG90IFqUGAUqpfTWamyCwFPnJ9oLhJIiR4iFCQq/gI6q
         dWBVQkJKTPKJBdY9PTpW+aPawRkKvcjmkztVElVCSgh+oaTqipCHhuPOTgk3f+M/AZSZ
         GIsw==
X-Gm-Message-State: AOJu0YySq2rBiukvFyIT6Bi2eE/VSjruAxYUz56nfTqXtaWlsicSLPCU
	gfQojd82ssWwQs3Vuf4h0iODifrAWDRU0kVDGvLbDPxlzchvaL7dIVSxd+v1rA6KWbpBcj3jYUY
	ipJu8bYMFLZy1Dpp5vkUfU+W2mxLbbGzr3s9EzM23K15JwrqMEWZ+P2o=
X-Gm-Gg: ASbGncuf77DZvETmE5i5VUDyo+D2pPRumPdduibgKlAl3R1F44o7Hep5QzKTP04V6nK
	OZccu0gp7k3sdFGbvo88USUItApXp5pOHFu6qKOq0cCXpDbETvT01z6ngoyMtM2TPcrvQfFnUZ6
	KvvsAD496XqApMX7sTNK5+qr8JVXZMlhoUCeKSwNz6AHBJqLgTvIQ58cgN3tNWWPSh0OIOmS4l1
	PjWqbYVBkZJ9KTdrureh+3TGQC4VzS0/pV6eSatNykrDb3apQhyHrf51A==
X-Google-Smtp-Source: AGHT+IGKxJPv5AY4sphSGbsBcP3qbh5hHh6iXcxB2jpvq3RRlo7qpjRlk52wmhYbTm3rbHP+yoKN4HJgAuX21EAuYzE=
X-Received: by 2002:a05:690e:151a:b0:636:d286:4829 with SMTP id
 956f58d0204a3-63f6b9d2b17mr2938005d50.4.1761660398035; Tue, 28 Oct 2025
 07:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027113907.451391-1-a.melnychenko@vyos.io> <aP_By5SYOFlM9LmZ@strlen.de>
In-Reply-To: <aP_By5SYOFlM9LmZ@strlen.de>
From: Andrii Melnychenko <a.melnychenko@vyos.io>
Date: Tue, 28 Oct 2025 15:06:26 +0100
X-Gm-Features: AWmQ_bnZRhRZDBAhQeEVIVLdcatj_thi2kKHi8nwn1QvvAeC7JoU81IpqE8BO_c
Message-ID: <CANhDHd_fLKccgO8Prw=r8D_S8nGNeUaXfOqBPn=jj7ww3W7jYg@mail.gmail.com>
Subject: Re: [PATCH 1/1] tests: shell: Updated nat_ftp tests
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone,


On Mon, Oct 27, 2025 at 8:02=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> > Added DNAT and SNAT only tests.
> > There was an issue with DNAT that was not covered by tests.
> > DNAT misses setting up the `seqadj`, which leads to FTP failures.
> > The fix for DNAT has already been proposed to the kernel.
>
> Thanks, could you please send a v2 that splits the refactoring
> from the new test case (i.e. two changes)?

Ok, I can change it to a series of patches:
 * first one that would present a function to set up a ruleset with
DNAT/SNAT variations
 * second - with new test cases.

>
> > Acked-by: Florian Westphal <fw@strlen.de>
>
> This should not be here unless you would be re-sending a v2
> of a patch that is almost 100% the same as the one I acked before.
>
> And I don't recall acking this change, so please don't add this
> yourself.

Well, we have a discussion during the patches for the kernel, so I've
decided to mention you here.
https://lkml.org/lkml/2025/10/24/924
Hesitated between "Asked-by" and "Suggested-by", but I'll remove it in v2.

>
> > +     # flush and add FTP helper
> > +     read -r -d '' str <<-EOF
> >       flush ruleset
> >       table ip6 ftp_helper_nat_test {
> >               ct helper ftp-standard {
> >                       type "ftp" protocol tcp;
> >               }
> > +     EOF
> > +     ruleset+=3D$str$'\n'
>
> I'd suggest to just use multiple nft -f invocations
> instead of this.
>
> > +     # add DNAT
> > +     if [[ $add_dnat -ne 0 ]]; then
> > +             read -r -d '' str <<-EOF
> >               chain PRE-dnat {
> >                       type nat hook prerouting priority dstnat; policy =
accept;
> >                       # Dnat the control connection, data connection wi=
ll be automaticly NATed.
> >                       ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dp=
ort 2121 counter dnat ip6 to [${ip_sr}]:21
> >               }
> > +             EOF
> > +             ruleset+=3D$str$'\n'
> > +     fi
>
> Just move this from reload_ruleset to a helper function.
>
> > @@ -111,18 +125,51 @@ reload_ruleset()
> >                       ip6 nexthdr tcp ct state established counter acce=
pt
> >                       ip6 nexthdr tcp ct state related     counter log =
accept
> >               }
> > +     EOF
> > +     ruleset+=3D$str$'\n'
> >
> > +     # add SNAT
> > +     if [[ $add_snat -ne 0 ]]; then
> > +             read -r -d '' str <<-EOF
>
> Same here, just omit this.
>
> > +reload_ruleset()
> > +{
> > +     reload_ruleset_base 1 1
> > +}
>
> Then this would be something like:
>
> reload_ruleset_dnat()
> {
>         reload_ruleset
>         load_dnat
> }
>
> reload_ruleset_snat()
> {
>         reload_ruleset
>         load_snat
> }
>
> reload_ruleset_allnat
> {
>         reload_ruleset
>         load_snat
>         load_dnat
> }
>
> (or similar naming).  I find that easier to follow, esp. because this
> allows a refactor patch before adding the _snat/_dnat tests.

Oh yeah, it's a good idea.

>
> The reload_ruleset -> reload_ruleset_base rename is also ok if you
> prefer that.
>
> > +
> >  dd if=3D/dev/urandom of=3D"$INFILE" bs=3D4096 count=3D1 2>/dev/null
> >  chmod 755 $INFILE
> > +
> > +mkdir -p /var/run/vsftpd/empty/
> > +cp $INFILE /var/run/vsftpd/empty/
>
> I don't understand this change, how is that related?
>

Not really related, I'll remove it.

> > +reload_ruleset_dnat_only
> > +
> > +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /de=
v/null &
> > +pid=3D$!
> > +sleep 0.5
> > +ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp=
://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
> > +assert_pass "curl ftp active mode "
>
> Not a requirement, but there is a lot of repitition
> of this sequence now, albeit with small changes.
>
> Perhaps this should be in a reuseable function first
> before adding the new test cases to this script.
>

It could be a tricky one - for example, an SNAT-only case requires
connecting directly to the FTP server.
A DNAT-only case would require checking the client's IP in the PCAP file.
So the "test function" may look like this:
```
test_case( ip_and_port, client_ip_to_check)
{
...
ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5
ftp://${ip_and_port}/$(basename $INFILE) -o $OUTFILE
...
tcpdump -nnr ${PCAP} src ${client_ip_to_check} and dst ${ip_sr} 2>&1
|grep -q FTP
}
```
If something like this ok, then I can do it:

> > +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /de=
v/null &
> > +pid=3D$!
> > +sleep 0.5
> > +ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp=
://[${ip_sr}]:21/$(basename $INFILE) -o $OUTFILE
> > +assert_pass "curl ftp active mode "
> > +
> > +cmp "$INFILE" "$OUTFILE"
> > +assert_pass "FTP Active mode: in and output files remain the same when=
 FTP traffic passes through NAT."
> > +
> > +kill $pid; sync
>
> I don't understand this 'sync' (I know its already there is source).
> It seems its not needed?

I'm not sure, maybe the idea is to make sure that the data is
"flushed" to the PCAP file?
I can remove it.

--=20

Andrii Melnychenko

Phone +1 844 980 2188

Email a.melnychenko@vyos.io

Website vyos.io

linkedin.com/company/vyos

vyosofficial

x.com/vyos_dev

reddit.com/r/vyos/

youtube.com/@VyOSPlatform

Subscribe to Our Blog Keep up with VyOS
