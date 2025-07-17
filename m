Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F8F2153C1
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=24.116.100.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752778020; cv=none; b=CJOQy/vtwMhASOY6Dd0IIZNNWxyBzjfskU3nAypgKql6K7RM6JF40j2NaSyqsjkuicDyWUh7U3DfWZQ6/oFvkr7OnMinI51vJaAI8N3emGeGeEJ977xyc20P/2b2m2EMg36La2yHOJ3v/uPLwaLYNOtEF4M1I5DLyEsTL0Sv8Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752778020; c=relaxed/simple;
	bh=MwphnKc5/jb08MJjOQaIls7HLy6IiWJd1pGXILrte0Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hXwbIdTJ1S8y2w6kIw2QE9IoVsDQvIv4P04Whpc1hNSu9+eqNMxUi/0OMErmegbS7T35Y8KsfJNHPv4ywqBwtTMbVvpYPcezgGjVBB6EkLiSU9o+j52TOyRCkxceBY05tTRrqUgEWmiV5kzDV55AiBidrh2fKqej6YJY5PPfak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com; spf=pass smtp.mailfrom=redfish-solutions.com; arc=none smtp.client-ip=24.116.100.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redfish-solutions.com
Received: from smtpclient.apple (Macmini2-116.redfish-solutions.com [192.168.8.9])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.18.1/8.18.1) with ESMTPSA id 56HIjrYu380524
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jul 2025 12:45:53 -0600
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v2 1/1] asn: fix missing quiet checks in xt_asn_build
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
In-Reply-To: <20250706172452.92730-1-philipp@redfish-solutions.com>
Date: Thu, 17 Jul 2025 12:45:42 -0600
Cc: Jan Engelhardt <jengelh@inai.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E632328D-A4EE-4AFC-8388-B1EF3C1A8F35@redfish-solutions.com>
References: <20250706172452.92730-1-philipp@redfish-solutions.com>
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Scanned-By: MIMEDefang 3.6 on 192.168.8.3

Hi. This is a trivial one line patch.  Can I please get it reviewed and =
merged or rejected with a reason?  Thanks


> On Jul 6, 2025, at 11:24=E2=80=AFAM, Philip Prindeville =
<philipp@redfish-solutions.com> wrote:
>=20
> From: Philip Prindeville <philipp@redfish-solutions.com>
>=20
> Conceivably someone might want to run a refresh of the ASN database
> from within a script, particularly an unattended script such as a cron
> job. Do not generate summary output in that case.
>=20
> Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
> ---
> asn/xt_asn_build | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/asn/xt_asn_build b/asn/xt_asn_build
> index =
63019ca689c56d5c9c686838fc4cc758047887e5..81c4965e572bbc7857a4832e0b806691=
04fe209f 100755
> --- a/asn/xt_asn_build
> +++ b/asn/xt_asn_build
> @@ -12,6 +12,7 @@ use Socket qw(AF_INET AF_INET6 inet_pton);
> use warnings;
> use Text::CSV_XS; # or trade for Text::CSV
> use strict;
> +$| =3D 1;
>=20
> my $csv =3D Text::CSV_XS->new({
> allow_whitespace =3D> 1,
> @@ -189,7 +190,7 @@ sub writeASN
> printf "%5u IPv%s ranges for %s\n",
> scalar(@ranges),
> ($family =3D=3D AF_INET ? '4' : '6'),
> - $asn_number;
> + $asn_number unless ($quiet);
>=20
> my $file =3D "$target_dir/".$asn_number.".iv".($family =3D=3D AF_INET =
? '4' : '6');
> if (!open($fh, '>', $file)) {
> --=20
> 2.43.0
>=20

