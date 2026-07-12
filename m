Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2311A6807
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 13:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783863604; cv=pass; b=iqBTnPflC1Mi7A/SG3GqXuAemKl5HvRuhgHBBakVEh5CfJN4lzAqwcAFrqxCtdho5FslSpe0G5W+ZHbBfOvYc//4gvwbGhD00xWC3/3x4jzXdircxZBQf5zkLCRc+NNnZtaT0DeyxpY4s0K1jwVpgSE6L6PtwWy0t6zUnOAv7Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783863604; c=relaxed/simple;
	bh=KiSHQqCAvU+FFma9KJlu+zZ4leYdIrQxQSFqeUYmfo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OFM9MYgsDqMbMeZzyWCr4+07wUmBCGbHMI6CufWFd7gxKDAsn4UoWkbPDoITW5s6qtwVHOJkoKGSNLrnr35MvcYZEVN5xDCJH/+8BpYCVIWi1iERKRA/qktYcp/dxdyN84RfabdgH8Ld5M1cf2CzBkJF+94ACrV32jNzOf66ziE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M2a4cxVl; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M2a4cxVl"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66771ded50aso4155680d50.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 06:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783863602; cv=none;
        d=google.com; s=arc-20260327;
        b=MU4RsPzgWobhp5vMgZECKe8KQwB8ivzGCcatH1SVuVew2UBXyuqxZFaotQ0ypowHJJ
         OPRrnvfXbc81BZck3wV/Rs8Kkp24JzBR6lWEjL9p0L9yhmdOpmD2zA+blRvDGrPhqW5y
         qKuSZBL7uBFFrTv6689nvRKiZFqzxlV01ddnDuDc+JRcvhJJW5nzuIpEYdMi5qGibhPc
         FFVVyTwvSkoP8mt4NeFyPtVYFp8gsZDJqAOUGs7OE7q8u6gzyFZI0MxAKe7rlu2KSRWP
         gDOCUFd6x+UA/2+Bg4MbKk7OD6FiimjsQnRuso8odPWin3c2hwBZMDPkCP6fOubHwBcQ
         Qa1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WrXp+T3iBm2YtNcYYvSsEHBgGq8Dyo4cUJ/1TZi54ek=;
        fh=sWunJObW40wC9mQ4a7QrK/qy7kji+583Qr+lrn42S9U=;
        b=ItZYcMlvoM1UIQKMf3sIcqtY+iJ1BLOFoRBSRH3AgHWmF9TSm5LThabVEUb8HMbFPO
         UlQnJPkwXCcEgF1ZxUD9/fozcPH9d9lvkuoIlkXEJ/ftobiKuIn02qqrN/gS64lh9e4e
         304zAU26VETx3vZMO7hJM78zK7BdlsI7mqrpIgAEMNi1x6y2qaAm1bKcS5eWmefCJZzS
         iu64R4F0QIZvVTqLQg7eOWlt861a/tgiSbbN5RwC21kr0m2h30bU1novSoJWKAUxXwc0
         hKGXb9fsK+vO88GA8SgbF0StbdK6qgPdniJVINgo3+vTs+i0bPs1ixIlwmZ2iDyK7Vsk
         CYSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783863602; x=1784468402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WrXp+T3iBm2YtNcYYvSsEHBgGq8Dyo4cUJ/1TZi54ek=;
        b=M2a4cxVl2u0aEbI3dQwOaitEwcxjJIWr7QdHWYaroqIxjR4bpINWqreqIw8gLpRQJX
         GhzikZq3NVF52wluAOgAYqm1LltpKl63w8c7OrkmdekiE4AlF5XCtK3vDT3Xg4q95zh2
         k3b697TS8tpO6D777ndaBb/VgEeundxIX7dtUe1BoZ5P4wl1UxXXDIL21P1kDBNWun0e
         8tSl2PvONHLoVijXvheKRrLNTqRsk2eqxNsebaN1TPZUuNAJzsgVOJPF1PBPP+5+vMZa
         peHPr81qN5WerdP73DDnGqRf1876usOwwt9e3gRN0sZHJzs+iyF0F8K3yGNukSLIxvoS
         uvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783863602; x=1784468402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WrXp+T3iBm2YtNcYYvSsEHBgGq8Dyo4cUJ/1TZi54ek=;
        b=MdwguP1qoVqOCO0S4rnV4Yua0Zak/l7bLWG7xRpagMVqXNHMkdOoxDs9gYi9tza9a9
         5mw4fzi207AKZ2GHnoNurMMlEB2JJcT8H4ymUvVNsZpAfIYeBkzjAOtvsuREo39Hsgkw
         Ycd807hczstDq3kVTGBCAQ6mtFW1K2sYpEkrgeCYRdnpBbJFeFL9Pv/Rz7n0exfXhX0D
         VF/hIC3evXX4Zn3lrSOd9bnum4lG/wYrTBU2sM5uui415lRq8+EDHxHLN35qIgp6q0LT
         x/RdP1sNyxzGPHMCyCIlzScd2W6tMWC6SsIVXDxW9r4+WHw3kwmXjjlek4VsntF1LlfW
         SiZg==
X-Gm-Message-State: AOJu0YxxZ18aW6uuU5tbihW/IeGOZDiUj8C0pEDL0iV4wi6DOMH8Ae4J
	MF5ZiSkQmSu2+o7sTuC+5qGBJZtYVAG9PjpnyCEunoi1/RlMdBZazEFLVlcS9XhuqZXVnTg1ldI
	mk18CR9sJpOkvWJ3g0HJQvyUQQJDaMRV9TPmMVi1DgQ==
X-Gm-Gg: AfdE7cluyMW97hpP6UN1/RjJGBPcUaSYH2S8AHiywv534LpZhWSm5GvelcMTXnUqZiv
	5b0zSfeBxdyQQebPk+pGAdK06lDfV+ygIilWbKnMYko56NU2yUXfOkQqENNmx16o6D8Fy7vPOUT
	9z2sibLBpw4smXJlX85HMyhCJMQQ1rE8NPPgolMoUkrPxKh/dWy4h+3m46+Pj7oMHDnhhHlxND2
	bQjei9XzL08r7z5cF75KF8Ub+Cso7hShjFXimMkInnptbpZQOYyqTx7vVAb0QuqCxFmwwUMHTs=
X-Received: by 2002:a53:a583:0:b0:667:c395:7d6a with SMTP id
 956f58d0204a3-667d7f246a4mr3274411d50.106.1783863601526; Sun, 12 Jul 2026
 06:40:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260710075409.1360085-1-pablo@netfilter.org> <CANczwAEqpv+zALby0crkzO5tX63efo-0JrVHVJUWbNgtxsKqSA@mail.gmail.com>
 <alKvX-Q_v6ez4fV3@chamomile>
In-Reply-To: <alKvX-Q_v6ez4fV3@chamomile>
From: Ahmed Zaki <anzaki@gmail.com>
Date: Sun, 12 Jul 2026 07:39:25 -0600
X-Gm-Features: AVVi8CfgfK_djWNe_tTJuCtzPA1eqGQtmp_a5YN7HhwVj_GmoDLLe2AOFLpFCmU
Message-ID: <CANczwAFH_GFK+uTTcpOoogQ8LuY6MRRwe0Q76=rP=F-9bY953g@mail.gmail.com>
Subject: Re: [PATCH nf,v2] netfilter: flowtable: tear down flow entries with
 stale dst from GC
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 11, 2026 at 3:02=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
.
.
.

> > I am testing this patch and keep getting some splats. I am testing
> > with a MTK7621 hw which
> > to my understanding, marks the tuple's xmit_type DIRECT (not neigh or X=
FRM).
> >
> > In nft_dev_forward_path(), out.h_source is set and this overrides the
> > dst_cache (same union)
> > this seems to be causing the splat when the dst_cache is dereferenced.
> > (btw, not like his patch,
> > in the latest HEAD, nf_flow_dst_check() guards tuple->dst_****  by
> > checks on xmit_type)
>
> We have move dst_cache out of the union quite recently so... (see below)
>
> > So, to support DIRECT types, we can:
> > 1 - go back to my v1 patch (no dependency on dst_cache)
> > 2 - same patch but use dst_check() only for NEIGH/XFRM
> > 3 - or maybe we can have the dst_cache out of the union and available
> > for all xmit_types.
> >
> > I have some time to work on this, let me know if I can help.
>
> ... probably you are missing this series? They got merged quite
> recently, I am not sure what tree you are using as reference:

yeah, I was looking at nf-next. These seem to be in nf only as of now.

>
> fa7395c02d95 netfilter: flowtable: support IPIP tunnel with direct xmit
> 6c5dcab95f4c netfilter: flowtable: IPIP tunnel hardware offload is not ye=
t support
> c328b90c17fc netfilter: flowtable: use dst in this direction when pushing=
 IPIP header
>
> There is also this patch which is needed:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260709114025=
.1294044-1-pablo@netfilter.org/
>
> which has been included in the last PR this Friday.

I have some limitations so I can only test with 6.6 or 6.12. I will
try to trim down these patches to
"move dst_cache out of union and use the gc to check all entries" and
will let you know if I see
any more problems.

The one thing I believe is still missing is to remove the if condition
in flow_offload_fill_route()
when setting  "flow_tuple->dst_cache/dst_cookie":

- if (route->tuple[!dir].in.num_tuns) {

We now need "flow_tuple->dst_cache/dst_cookie" for all DIRECT xmit
even with no tunnels
(quick look on nft_dev_path_info() shows "num_tuns" set for
"path->type =3D=3D DEV_PATH_TUN" only).

Thank you.
