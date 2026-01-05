Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD38632B;
	Mon,  5 Jan 2026 13:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767618255; cv=none; b=DjpvV+I9TPFMvIN297ou5R2ObdSuolImXph4yskTJdusIc+KnxXXYzf9wWJZDsg8dCoHZet3lWDXUGn0cwTn80QXBBAhXrJyt3P+fXVxDVAi2Qyvry/xlKdKea6FTk8Oe2/4pJm8HwHBjuAkdz9Mw+TGNYZ8hIoPFXY60JfQg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767618255; c=relaxed/simple;
	bh=Hchbw9WKDXgJCR0RJQZ0iueqga8miWKz3ZrW+rf/rC8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=PI/e2vD8MbZTznXvq+qf3JgUgKlTEsoKQB7e7T/Zi+ldhJo5njLuaBdCFICs7dENNsg5NdfTzbE2DIYKXUvRL0k8GBS8841uml7MGILplkTtor8HiXbeJ+3SO2yU42CuS9pj0pJr5PgBzEi7qy50S1CbRHEgSIoMokzT+owMwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=HZPyjUoO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aDumdI4o; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="HZPyjUoO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aDumdI4o"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D75D57A0114;
	Mon,  5 Jan 2026 08:04:11 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 05 Jan 2026 08:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1767618251;
	 x=1767704651; bh=uAohc9GpQJJzncomxaFLEdU5W4KBJI1SLnN+hmqJsmE=; b=
	HZPyjUoOkhAM/avFohXhnH2Fj+T14WjNDQ8UST1LAlOTQQms1BHZO0GxCSLvS3xs
	ONDFsh+jUecpV2IN0qgStaOIlp7hEgyajz1p2+DcPmm4fVSC/C5A7WNLAjBXnOeK
	vNtwnLLjKa+WJIfHuAzGdaf8bwToFEyQpt6S5pmWMkR5xTKHWwMJeg57QKWaVk2Q
	wnp+rS2a6GrD6fmjAUXsY/utjXTEGnk1AYZYYzTY9e7T4xjTfV/bIkKEggVppvXn
	qtCgejVML/9H2Gwq8yZWbhZ2WXNdbzzDGzWpbsk6NyttO4/hpjJ0zSqwkwDseyfm
	qKdb423FNgiHGIFuYWw1PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1767618251; x=
	1767704651; bh=uAohc9GpQJJzncomxaFLEdU5W4KBJI1SLnN+hmqJsmE=; b=a
	DumdI4o8r7C7V8GNk1rBNegx5V7Xg9kOX9OLXY2mVwnQ785EFNghRtl3KkvUy8ik
	FWxtQhXU4D4Du+da65fI0xM3atgwik+AtX2VvAPVFGh5ns9F3j/KyUsChsC8536H
	lW7JYgNDQ2vhxiKk2IZHxqGJbLuXGljs9FwL5UL2IxGdixoCMAD0fm7IqQ6zs8oA
	skYnRW5SObUkII28Pqr4WJ3SNaf+UUH/Rnrgh8wHLgt8fYL47ykiaOA/zZ1G7Cmr
	QMJPNhrh8dScJhYbs9+Dw1msLHQOLZB5e6mE6VnGa/stIVtRa7WcCfbZnxiB7A/e
	E6pUXcbEiiRo/CyxqJkqw==
X-ME-Sender: <xms:yrZbaY5Z5LlTSiEBNP8eiQiaQvN6zVi5XpPbBp_u5sg4AYErpXUgPw>
    <xme:yrZbaUuJJt26VL2OxgzHSnjMc4-ec0rFS-yOlSLy2CUZyuUd009kdS5C0MtDpViM6
    crvwn8SMiBAM3Liel0hCSVzrgQUAqDMWwhX4U1S04ThuhQy-K9AHRs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeljeefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpedvhfdvkeeuudevfffftefgvdevfedvleehvddvgeejvdefhedtgeegveehfeeljeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhope
    gvughumhgriigvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohephhhorhhmsheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehthhhomhgrshdrfigvihhsshhstghhuhhhsehlihhnuhhtrhhonhhigidruggv
    pdhrtghpthhtoheprghnughrvgifsehluhhnnhdrtghhpdhrtghpthhtoheptghorhgvth
    gvrghmsehnvghtfhhilhhtvghrrdhorhhgpdhrtghpthhtohepkhgrughlvggtsehnvght
    fhhilhhtvghrrdhorhhgpdhrtghpthhtohepphgrsghlohesnhgvthhfihhlthgvrhdroh
    hrgh
X-ME-Proxy: <xmx:yrZbad9aJfyi4r09VKtrtKBlKZyyMvRTz3MFujmWfe-Qv0yjNlI0iQ>
    <xmx:yrZbaSJ-ykZQtG3YYBnsRzjvljaUyQ050voMUUZTVjSSiDZQvnkJzQ>
    <xmx:yrZbaaywxTV4hipjDVDraGJGq5YtImxElQuFA2IHxnq-eOZi3IyDvw>
    <xmx:yrZbad2QCN9sQySCLAPxCSO-UVJ5nAFWrK-cl-GKPWEh5hSZFulMsg>
    <xmx:y7ZbacMyESx44V_qWIYpXuU0XfX1GHBL07yygH4AqjJKnLmR4EnCCtiz>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5602F700069; Mon,  5 Jan 2026 08:04:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AZiuWalixslg
Date: Mon, 05 Jan 2026 14:02:17 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Andrew Lunn" <andrew@lunn.ch>, "Pablo Neira Ayuso" <pablo@netfilter.org>,
 "Jozsef Kadlecsik" <kadlec@netfilter.org>, "Florian Westphal" <fw@strlen.de>,
 "Phil Sutter" <phil@nwl.cc>
Cc: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Message-Id: <d3554d2d-1344-45f3-a976-188d45415419@app.fastmail.com>
In-Reply-To: <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
Subject: Re: [PATCH RFC net-next 3/3] netfilter: uapi: Use UAPI definition of INT_MAX
 and INT_MIN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026, at 09:26, Thomas Wei=C3=9Fschuh wrote:
> Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
> dependency on a libc, which UAPI headers should not do.
>
> Use the equivalent UAPI constants.
>
> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

I agree with the idea of the patch series, but I think this
introduces a different problem:

>  #include <linux/in.h>
> +#include <linux/limits.h>

linux/limits.h is not always clean against limits.h. In glibc,
you can include both in any order, but in musl, you cannot:

gcc -xc /dev/null -nostdinc -I /usr/include/aarch64-linux-musl -include =
limits.h -include linux/limits.h  -o - -Wall  -c=20
In file included from <command-line>:
/usr/include/aarch64-linux-musl/linux/limits.h:7: warning: "NGROUPS_MAX"=
 redefined
    7 | #define NGROUPS_MAX    65536    /* supplemental group IDs are av=
ailable */
      |=20
In file included from <command-line>:
/usr/include/aarch64-linux-musl/limits.h:48: note: this is the location =
of the previous definition
   48 | #define NGROUPS_MAX 32

I can think of two alternative approaches here:

- put the __KERNEL_INT_MIN into a different header -- either a new one
  or maybe uapi/linux/types.h
- use the compiler's built-in __INT_MIN__ instead of INT_MIN in
  UAPI headers.

On the other hand, there are a few other uapi headers
that already include linux/limits.h:

include/uapi/linux/auto_fs.h:#include <linux/limits.h>
include/uapi/linux/fs.h:#include <linux/limits.h>
include/uapi/linux/netfilter/xt_bpf.h:#include <linux/limits.h>
include/uapi/linux/netfilter/xt_cgroup.h:#include <linux/limits.h>
include/uapi/linux/netfilter/xt_hashlimit.h:#include <linux/limits.h>

     Arnd
