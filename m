Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC2199385
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 00:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770855734; cv=none; b=PMAKEbJ5vvWxE7oC+PmaNK0HD4lgLprhQGUFVT4I9S9oTrdtQSFSypSQL2lMat2/SVd9tJTP2aNba3zyIQ1mlcn3gQDLeqIL0nzYVIjgv2isjJG4+d20HiHoGVVd3AoMBsfgDnSfVW2X9Wf9t8Lrp+78PSPdh/7Bd8+O8O9jQjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770855734; c=relaxed/simple;
	bh=PYWRddlwVY0jzc38vC+9kh20HxoCqpanxvOgSv/O4P0=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ehyuC27+6J75vsLp8QUaW/3/uFGoJy4ZxJ+H72PYHsqRvfKUysfFB8qdCcROJ3c4U63AsVqnggPFvABCfPBszMbc8MrqM5Zr5MoI8a6YFxyuaDq3ARqWcg8ndNW/CfoU2du5fFpK3hjl+J9skYXaKOZjhKP1v9d+J1lMf8lxp9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=q61u47Fj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q61u47Fj"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260212002209epoutp02b9e684e8c762681991c009800f4d4358~TV_dRkJUH1282912829epoutp022
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 00:22:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260212002209epoutp02b9e684e8c762681991c009800f4d4358~TV_dRkJUH1282912829epoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770855729;
	bh=PYWRddlwVY0jzc38vC+9kh20HxoCqpanxvOgSv/O4P0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=q61u47FjdJVkppHy0XlBcKiVrSms9Kk0j6F+RdLQeUJJFVhZolbvo7aPqMd4czPyE
	 H1x0bSOzhXUrq1968mKr0i08I400TN8o3WxJmI3ViTakbTFWlEbwJFnoGQKL3TWpMd
	 zuK34vCbmsJeMoSNV2aGPlcmq55Mty6kxi8Pdbo8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20260212002208epcas1p25730873b06b96f3c2d81f01a666eb365~TV_cuCA920998809988epcas1p2D;
	Thu, 12 Feb 2026 00:22:08 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.191]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fBGFr4vq4z3hhTF; Thu, 12 Feb
	2026 00:22:08 +0000 (GMT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [net-next,v3] ipv6: shorten reassembly timeout under
 fragment memory pressure
Reply-To: soukjin.bae@samsung.com
Sender: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
From: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
To: Eric Dumazet <edumazet@google.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "dsahern@kernel.org" <dsahern@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "horms@kernel.org" <horms@kernel.org>,
	"phil@nwl.cc" <phil@nwl.cc>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "fw@strlen.de" <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <CANn89i+mNojd9mUL_dt_=D+7nZ9xcV96CYJG_LYFmBZDOYUMFQ@mail.gmail.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260212002207epcms1p7a1c19ed12038cf74f8632e5a305bd7ec@epcms1p7>
Date: Thu, 12 Feb 2026 09:22:07 +0900
X-CMS-MailID: 20260212002207epcms1p7a1c19ed12038cf74f8632e5a305bd7ec
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260211030048epcms1p54c6ed78458f57def8e3163032498ca00
References: <CANn89i+mNojd9mUL_dt_=D+7nZ9xcV96CYJG_LYFmBZDOYUMFQ@mail.gmail.com>
	<20260211103243epcms1p2dd304fd11b28df04f4e680e8c90a7fc5@epcms1p2>
	<207b2879-e022-4b50-837b-d536f8fcabcd@suse.de>
	<CGME20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p7>

>On Wed, Feb 11, 2026 at 4:11=E2=80=AFPM=20Fernando=20Fernandez=20Mancera=
=0D=0A><fmancera=40suse.de>=20wrote:=0D=0A>>=0D=0A>>=20On=202/11/26=2011:32=
=20AM,=20=EB=B0=B0=EC=84=9D=EC=A7=84=20wrote:=0D=0A>>=20>=C2=A0=20=20Change=
s=20in=20v3:=0D=0A>>=20>=20-=20Fix=20build=20bot=20error=20and=20warnings=
=0D=0A>>=20>=20-=20baseline=20update=0D=0A>>=20>=0D=0A>>=20>=0D=0A>>=20>=0D=
=0A>>=20>=C2=A0=20From=20c7940e3dd728fdc58c8199bc031bf3f8f1e8a20f=20Mon=20S=
ep=2017=2000:00:00=202001=0D=0A>>=20>=20From:=20Soukjin=20Bae=20<soukjin.ba=
e=40samsung.com>=0D=0A>>=20>=20Date:=20Wed,=2011=20Feb=202026=2011:20:23=20=
+0900=0D=0A>>=20>=20Subject:=20=5BPATCH=5D=20ipv6:=20shorten=20reassembly=
=20timeout=20under=20fragment=20memory=0D=0A>>=20>=C2=A0=20=20pressure=0D=
=0A>>=20>=0D=0A>>=20>=20Under=20heavy=20IPv6=20fragmentation,=20incomplete=
=20fragment=20queues=20may=20persist=0D=0A>>=20>=20for=20the=20full=20reass=
embly=20timeout=20even=20when=20fragment=20memory=20is=20under=0D=0A>>=20>=
=20pressure.=0D=0A>>=20>=0D=0A>>=20>=20This=20can=20lead=20to=20prolonged=
=20retention=20of=20fragment=20queues=20that=20are=20unlikely=0D=0A>>=20>=
=20to=20complete,=20causing=20newly=20arriving=20fragmented=20packets=20to=
=20be=20dropped=20due=0D=0A>>=20>=20to=20memory=20exhaustion.=0D=0A>>=20>=
=0D=0A>>=20>=20Introduce=20an=20optional=20mechanism=20to=20shorten=20the=
=20IPv6=20reassembly=20timeout=0D=0A>>=20>=20when=20fragment=20memory=20usa=
ge=20exceeds=20the=20low=20threshold.=20Different=20timeout=0D=0A>>=20>=20v=
alues=20are=20applied=20depending=20on=20the=20upper-layer=20protocol=20to=
=20balance=0D=0A>>=20>=20eviction=20speed=20and=20completion=20probability.=
=0D=0A>>=20>=0D=0A>>=20>=20Signed-off-by:=20Soukjin=20Bae=20<soukjin.bae=40=
samsung.com>=0D=0A>>=0D=0A>>=20Hello,=0D=0A>>=0D=0A>>=20isn't=20this=20what=
=20net.ipv6.ip6frag_time=20does?=20In=20addition,=20the=20situation=0D=0A>>=
=20you=20described=20could=20be=20overcome=20by=20increasing=20the=20memory=
=20thresholds=20at=0D=0A>>=20net.ipv6.ip6frag_low_thresh=20and=20net.ipv6.i=
p6frag_high_thresh.=0D=0A>>=0D=0A>>=20Please,=20let=20me=20know=20if=20I=20=
am=20missing=20something.=0D=0A>=0D=0A>Also=20:=0D=0A>=0D=0A>1)=20net-next=
=20is=20closed.=0D=0A>Please=20read=20Documentation/process/maintainer-netd=
ev.rst=0D=0A>=0D=0A>2)=20We=20do=20not=20send=203=20versions=20of=20a=20pat=
ch=20in=20the=20same=20day.=0D=0A>Please=20read=20Documentation/process/mai=
ntainer-netdev.rst=0D=0A>=0D=0A>3)=20What=20about=20IPv4=20?=0D=0A>=0D=0A>4=
)=20Only=20the=20first=20fragment=20contains=20the=20'protocol=20of=20the=
=20whole=0D=0A>datagram',=20and=20fragments=20can=20be=20received=20in=20an=
y=20order.=0D=0A>=0D=0A>5)=20We=20do=20not=20add=20a=20MAINTAINER=20entry=
=20for=20such=20a=20patch,=20sorry.=0D=0A=0D=0A=0D=0AHello,=0D=0A=0D=0A=0D=
=0ARegarding=20about=20net.ipv6.ip6frag_time=20and=20low/high_thresh:=0D=0A=
=0D=0AThe=20issue=20we=20are=20addressing=20currently=20occurs=20due=20to=
=20a=20large=20volume=20of=20mDNS=0D=0Atraffic=20from=20WiFi=20APs.=20As=20=
a=20temporary=20measure,=20we=20increased=20the=20high_thresh=0D=0Avalue=20=
to=20accommodate=20the=20traffic.=0D=0A=0D=0AHowever,=20UDP=20traffic=20suc=
h=20as=20mDNS=20cannot=20recover=20once=20a=20fragment=20stream=20is=0D=0Al=
ost,=20leading=20to=20wasted=20memory.=20Therefore,=20this=20patch=20is=20i=
ntended=20to=20make=0D=0Amore=20efficient=20use=20of=20the=20currently=20al=
located=20fragment=20memory=20by=20shortening=0D=0Athe=20reassembly=20timeo=
ut=20under=20memory=20pressure.=0D=0A=0D=0AAlso,=20we=20tend=20to=20avoid=
=20changing=20the=20global=20value=20of=20ip6frag_time=20to=0D=0Apreserve=
=20existing=20behavior.=20This=20is=20why=20I=20added=20new=20config=20too.=
=0D=0A=0D=0A=0D=0ARegarding=20others:=0D=0A=0D=0A1,=202)=20net-next=20is=20=
closed=20and=20multiple=20patch=20=0D=0AI=20apologize=20for=20the=20oversig=
ht=20regarding=20the=20net-next=20status=20and=20the=20frequent=0D=0Asubmis=
sions.=20I=20was=20tried=20to=20fix=20CI=20build=20failures.=20I=20will=20f=
ollow=20the=0D=0Adocumented=20guidance=20going=20forward.=0D=0A=0D=0A3)=20W=
hat=20about=20IPv4?=0D=0AThe=20issue=20was=20primarily=20observed=20in=20IP=
v6-dominant=20IMS=20environments,=20which=0D=0Awas=20the=20initial=20focus.=
=20However,=20I=20agree=20that=20the=20same=20memory=20management=20logic=
=0D=0Ais=20beneficial=20for=20IPv4.=20I=20will=20include=20IPv4=20support=
=20in=20the=20next=20version=20to=0D=0Aprovide=20a=20unified=20solution.=0D=
=0A=0D=0A4)=20Only=20the=20first=20fragment=20contains=20the=20'protocol=20=
of=20the=20whole=20datagram'.=0D=0AYou=20are=20correct.=20I=20will=20update=
=20the=20logic=20to=20store=20the=20L4=20protocol=20information=0D=0Aonce=
=20the=20first=20fragment=20is=20received,=20and=20only=20then=20apply=20th=
e=20adjusted=20timeout.=0D=0AIf=20the=20first=20fragment=20is=20lost,=20the=
=20adjusted=20timer=20will=20not=20be=20triggered,=20but=0D=0Athis=20is=20a=
cceptable=20as=20a=20partial=20case.=0D=0A=0D=0A5)=20MAINTAINERS=20entry=0D=
=0AUnderstood.=20I=20will=20remove=20the=20MAINTAINERS=20entry.=20I=20was=
=20added=20to=20address=20a=0D=0Acheckpatch.pl=20warning=20and=20CI=20build=
=20failure.=0D=0A
