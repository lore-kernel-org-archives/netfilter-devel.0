Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410A6A7
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 06:32:28 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
	id 8F19058729D9D; Thu, 14 Dec 2023 15:32:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 8CE0360E0CC21;
	Thu, 14 Dec 2023 15:32:26 +0100 (CET)
Date: Thu, 14 Dec 2023 15:32:26 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Jeremy Sowden <jeremy@azazel.net>
cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables 7/7] build: suppress man-page listing in silent
 rules
In-Reply-To: <20231214125927.925993-8-jeremy@azazel.net>
Message-ID: <20oqpp22-0p61-rs3r-65rp-r8s595on98o2@vanv.qr>
References: <20231214125927.925993-1-jeremy@azazel.net> <20231214125927.925993-8-jeremy@azazel.net>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Thursday 2023-12-14 13:59, Jeremy Sowden wrote:

>Add an `AM_V_PRINTF` variable to control whether `printf` is called.
>
>Normally `AM_V_*` variables work by prepending
>
>  @echo blah;
>
>to a whole rule to replace the usual output with something briefer.
>Since, in this case, the aim is to suppress `printf` commands _within_ a
>rule, `AM_V_PRINTF` works be prepending `:` to the `printf` command.

>@@ -228,19 +232,19 @@ man_run    = \
> 	for ext in $(sort ${1}); do \
> 		f="${srcdir}/libxt_$$ext.man"; \
> 		if [ -f "$$f" ]; then \
>-			printf "\t+ $$f" >&2; \
>+			${AM_V_PRINTF} printf "\t+ $$f" >&2; \

I believe I was the author of this "for" block.

The intent of V=0 is to hide long build commands and show only the
output name. That works for most people most of the time. It did not
for me in this very build step. ${1}, i.e. the sections, are
dependent on configure options like --disable-ipv4/--disable-ipv6, so
I felt it made sense not only to print the output name (as V=0 does)
but also the source names—but still not the verbose build command.

With that original goal in mind, silencing echo/printf inside this
recipe, for the usecase of V=0, is incorrect.

[Patches 1 to 6 are fine by me.]
