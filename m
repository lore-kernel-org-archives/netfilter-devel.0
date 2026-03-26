Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED636302767;
	Thu, 26 Mar 2026 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556686; cv=none; b=Cek6izwS6lBsvEmuoCDQ0fi8WHhWLZ2ao9qJv1uH43I/ukG0EkDmNrsDR+oWiEl/yBCL4PkSh7hVEyRG8B0/WLRJ/Cb/V8lAiJw0mkjBKhWROypqcroPpp4P3l1RREbZ1lnwywnJBYPFFQIRSNeE8MObhYw56vXfCh49ZG1cJAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556686; c=relaxed/simple;
	bh=O+eQtnykFGZ+oYaduwPSMrisJe13TNmQ49CZbFJ/wss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpZQccWpu6prI+sEB9xMbMftGgs9otN2cBNXHpiX9m/IL8cxupIDm6H4t1ql1vSnZT/xHa+SKib+a1bMF9533jltHmOs1ViQ/2bHsOJOa61sDEOqqH9xu8yBRlACyFj9qwHp/JYOjdLA12mScPwPA8R1WnV5z2RZBrFF5a8QsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AC9Oamas; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AC9Oamas"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B35A560178;
	Thu, 26 Mar 2026 21:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774556682;
	bh=IvRGQcEqo/PpTVkWnearcKcpp+WavMh93M2MWmh9Mv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AC9OamashbVnf4FgGKC2gGA9R3cTKMsxtIN9GNzzVUjXkSkHsxStmS1/o2kpO25dy
	 EDhVuh+UafZfJvVWF8qPcF6M32TgxUTJ9ZsX4NqdDD0gGhbbxes5R830Zmn1LXIgY7
	 /2uVcO2Hi9dt13XGb3bfPo1wNCWvTxddIRFA43h3uarKVCvfikKQ+Bo3fGVDuuQoJJ
	 d/U9eaoRjGXx6ANtv7U5Yj4sQpUJSYN4oNapkAziS4fYlE+ypwR7IDms5GVN/5NVjk
	 QAZGIA2Rh/ryD4MhSnZRE2n/PJ1mPoxzTqmk8SwXs53VdJMVWRNnbTgIiOM2LyzBAr
	 5lkUtIFAR/xVA==
Date: Thu, 26 Mar 2026 21:24:39 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: david.laight.linux@gmail.com
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <acWWBxmPd_BNqUHF@chamomile>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260326201819.3900-1-david.laight.linux@gmail.com>

Hi David,

On Thu, Mar 26, 2026 at 08:18:19PM +0000, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> The trace lines are indented using PRINT("%*.s", xx, " ").
> Userspace will treat this as "%*.0s" and will output no characters
> when 'xx' is zero, the kernel treats it as "%*s" and will output
> a single ' ' - which is probably what is intended.
> 
> Change all the formats to "%*s" removing the default precision.
> This gives a single space indent when level is zero.

Do you have a setup using this helper? Or you just found this via
visual inspection?

> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 7b1497ed97d2..287402428975 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
>  static int decode_nul(struct bitstr *bs, const struct field_t *f,
>                        char *base, int level)
>  {
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	return H323_ERROR_NONE;
>  }
> @@ -284,7 +284,7 @@ static int decode_nul(struct bitstr *bs, const struct field_t *f,
>  static int decode_bool(struct bitstr *bs, const struct field_t *f,
>                         char *base, int level)
>  {
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	INC_BIT(bs);
>  	if (nf_h323_error_boundary(bs, 0, 0))
> @@ -297,7 +297,7 @@ static int decode_oid(struct bitstr *bs, const struct field_t *f,
>  {
>  	int len;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	BYTE_ALIGN(bs);
>  	if (nf_h323_error_boundary(bs, 1, 0))
> @@ -316,7 +316,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
>  {
>  	unsigned int len;
>  
> -	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
>  
>  	switch (f->sz) {
>  	case BYTE:		/* Range == 256 */
> @@ -363,7 +363,7 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
>  static int decode_enum(struct bitstr *bs, const struct field_t *f,
>                         char *base, int level)
>  {
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	if ((f->attr & EXT) && get_bit(bs)) {
>  		INC_BITS(bs, 7);
> @@ -381,7 +381,7 @@ static int decode_bitstr(struct bitstr *bs, const struct field_t *f,
>  {
>  	unsigned int len;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	BYTE_ALIGN(bs);
>  	switch (f->sz) {
> @@ -417,7 +417,7 @@ static int decode_numstr(struct bitstr *bs, const struct field_t *f,
>  {
>  	unsigned int len;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	/* 2 <= Range <= 255 */
>  	if (nf_h323_error_boundary(bs, 0, f->sz))
> @@ -437,7 +437,7 @@ static int decode_octstr(struct bitstr *bs, const struct field_t *f,
>  {
>  	unsigned int len;
>  
> -	PRINT("%*.s%s", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s", level * TAB_SIZE, " ", f->name);
>  
>  	switch (f->sz) {
>  	case FIXD:		/* Range == 1 */
> @@ -490,7 +490,7 @@ static int decode_bmpstr(struct bitstr *bs, const struct field_t *f,
>  {
>  	unsigned int len;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	switch (f->sz) {
>  	case BYTE:		/* Range == 256 */
> @@ -522,7 +522,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
>  	const struct field_t *son;
>  	unsigned char *beg = NULL;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	/* Decode? */
>  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> @@ -544,7 +544,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
>  	/* Decode the root components */
>  	for (i = opt = 0, son = f->fields; i < f->lb; i++, son++) {
>  		if (son->attr & STOP) {
> -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
>  			      son->name);
>  			return H323_ERROR_STOP;
>  		}
> @@ -562,7 +562,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
>  			if (nf_h323_error_boundary(bs, len, 0))
>  				return H323_ERROR_BOUND;
>  			if (!base || !(son->attr & DECODE)) {
> -				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
> +				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
>  				      " ", son->name);
>  				bs->cur += len;
>  				continue;
> @@ -615,7 +615,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
>  		}
>  
>  		if (son->attr & STOP) {
> -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
>  			      son->name);
>  			return H323_ERROR_STOP;
>  		}
> @@ -629,7 +629,7 @@ static int decode_seq(struct bitstr *bs, const struct field_t *f,
>  		if (nf_h323_error_boundary(bs, len, 0))
>  			return H323_ERROR_BOUND;
>  		if (!base || !(son->attr & DECODE)) {
> -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
>  			      son->name);
>  			bs->cur += len;
>  			continue;
> @@ -655,7 +655,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
>  	const struct field_t *son;
>  	unsigned char *beg = NULL;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	/* Decode? */
>  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> @@ -710,7 +710,7 @@ static int decode_seqof(struct bitstr *bs, const struct field_t *f,
>  			if (nf_h323_error_boundary(bs, len, 0))
>  				return H323_ERROR_BOUND;
>  			if (!base || !(son->attr & DECODE)) {
> -				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
> +				PRINT("%*s%s\n", (level + 1) * TAB_SIZE,
>  				      " ", son->name);
>  				bs->cur += len;
>  				continue;
> @@ -751,7 +751,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
>  	const struct field_t *son;
>  	unsigned char *beg = NULL;
>  
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	/* Decode? */
>  	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
> @@ -792,7 +792,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
>  	/* Transfer to son level */
>  	son = &f->fields[type];
>  	if (son->attr & STOP) {
> -		PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
> +		PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ", son->name);
>  		return H323_ERROR_STOP;
>  	}
>  
> @@ -804,7 +804,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
>  		if (nf_h323_error_boundary(bs, len, 0))
>  			return H323_ERROR_BOUND;
>  		if (!base || !(son->attr & DECODE)) {
> -			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
> +			PRINT("%*s%s\n", (level + 1) * TAB_SIZE, " ",
>  			      son->name);
>  			bs->cur += len;
>  			return H323_ERROR_NONE;
> -- 
> 2.39.5
> 
