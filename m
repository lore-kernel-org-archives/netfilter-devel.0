Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DF11F8F14
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2025 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736341173; cv=none; b=u7BVVolMTPGvjhPCzMqwmdNEVYWjfHwQM9RRfBGYFAAue3/6AI8AvPZCB9h6n6+ktQkRwSiqlWnL1y0506y5mez4eaun2XPmclCNjDDmQ0AciPiBCcDV53EvPe5rIaOKK/RXqOpvGB8CFK7/Mjn6Sdo9D+KwkIbvdrUkoY94ai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736341173; c=relaxed/simple;
	bh=hC46p6MQMT91J9MPJ+4nJ30gu8cjDEoQUJm58zEdckQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h66MXPEqh6pVi2i8sDgVNsMIKhDv83Zp5csanXEZofXjoSgZlvoJE/rHoPGhi+m8FJQ2wLV1o31yIMUqs+Xwwm8BtfgaDjsEAGM3kd3v894bTY56O5TsvixqboKH6ojq5hfuiLjSuKfuJVkgLVKFshWYJWI+7waltBX4v+ah3lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 8 Jan 2025 13:59:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] rule: make cmd_free(NULL) valid
Message-ID: <Z352njkGrwTBgJia@calendula>
References: <20250108113022.12499-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250108113022.12499-1-fw@strlen.de>

On Wed, Jan 08, 2025 at 12:30:15PM +0100, Florian Westphal wrote:
> bison uses cmd_free($$) as destructor, but base_cmd can
> set it to NULL, e.g.
> 
>   |       ELEMENT         set_spec        set_block_expr
>   {
>     if (nft_cmd_collapse_elems(CMD_ADD, state->cmds, &$2, $3)) {
>        handle_free(&$2);
>        expr_free($3);
>        $$ = NULL;   // cmd set to NULL
>        break;
>     }
>     $$ = cmd_alloc(CMD_ADD, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
> 
> expr_free(NULL) is legal, cmd_free() causes crash.  So just allow
> this to avoid cluttering parser_bison.y with "if ($$)".
> 
> Also add the afl-generated bogon input to the test files.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  src/rule.c                                    |  3 +++
>  .../bogons/nft-f/cmd_is_null_on_free          | 20 +++++++++++++++++++
>  2 files changed, 23 insertions(+)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free
> 
> diff --git a/src/rule.c b/src/rule.c
> index 151ed531969c..cc43cd18b7c7 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1372,6 +1372,9 @@ void monitor_free(struct monitor *m)
>  
>  void cmd_free(struct cmd *cmd)
>  {
> +	if (cmd == NULL)
> +		return;
> +
>  	handle_free(&cmd->handle);
>  	if (cmd->data != NULL) {
>  		switch (cmd->obj) {
> diff --git a/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free b/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free
> new file mode 100644
> index 000000000000..6a42aa90cd53
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free
> @@ -0,0 +1,20 @@
> +nt      rootepep test- {
> +* : 1:3 }
> +        element root tesip {
> +* : 1:3 }
> +        elent   rootsel s1 {
> +        typ�    elements < { "Linux" }
> +        }
> +tatlet e t {
> +        thataepep test- {
> +* : 1:3 }
> +        element root tesip {
> +* : 1:3 }�      table Cridgents < t {
> +list            set y p
> +        type i , {
> +        sel s1 {
> +        typ�    elements < { "Linux" }
> +        }
> +tatlet e t {
> +        thatable Cridgents < t {
> +lis
> -- 
> 2.45.2
> 
> 
