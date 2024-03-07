Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F66639
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709821930; cv=none; b=LTWr1zSPOI0/Wkm3rgE4QrrdYNswF9m80muo1nlQtJO3Km09/554JBnQZXRx2kAr19R1CvifttuAOzKwOewHxhO1You8+KmXYqxSjTVM/hSNz2HE3Wl+feT2Emug+pExQtwjJb2H9DdyA6OwKgdeahFxSIu+7mVrygBuSw+d6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709821930; c=relaxed/simple;
	bh=7Qg+H08ksvm3D9mWlFbr1GKB0CzmOaD7Vn3oTsx2opc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6ChzD6fZMVwbQ+nageg0HJo0QdKwovAHBVz+wyWCvEiduKTrX9laRJYHYKx/7MpYYBuUMVx8X29NX7GG9hhINipf0UUOSeHrdZ66xOWRQblS/6YdXN9wB+9Ur3Uk62KEmcyYdT00v1E0Ayc5o70+fAf1PhMKqgXujFDSudSYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EJUlqqXq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EJUlqqXq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mEO4CGfmBYhFuO6DkhARBlzX2wX9sej4ZQy/KbqLTUk=; b=EJUlqqXq7myzUK4VR+uJ5BsaYI
	l88WEHeJwOg6PQbykMfI3TUdoNi+XkGRfDN3QzmMKFA1hPcsOQOkpW0R1+aJlvJF9iTI+MfPqVUCO
	8j+7AMbzD1Lp6HukNG2QE5z/0tLw0MHun84jZXJqs7uwLD9oCZtWp06JB65etMwWS1jKql/a/vXXb
	z5wIeUggArPBxJ+jTLFu9kgaafoCeGeFim35fFyecOHII6o4snHSXYRptA3R/V6D4wJwChKntPt5/
	HgYpYf5LYpjY66EsJP6Hmz6KUtb+2Bn1D9TdBiZAmHJc8vNYPfUgUbdN9wUk8iZztMLREPsZ8OHV9
	rJQxEAew==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riEmt-000000006Gd-3KV1;
	Thu, 07 Mar 2024 15:31:59 +0100
Date: Thu, 7 Mar 2024 15:31:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/5] parser_json: move list_add into json_parse_cmd
Message-ID: <ZenP32bq9xtJglJQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240307122640.29507-1-fw@strlen.de>
 <20240307122640.29507-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307122640.29507-3-fw@strlen.de>

Hi Florian,

On Thu, Mar 07, 2024 at 01:26:32PM +0100, Florian Westphal wrote:
> The existing parser cannot handle certain inputs.  Example:
> 
>   "map": {
>    "family": "ip",
>    "name": "testmap",
>    "table": "test",
>    "type": "ipv4_addr",
>    "handle": 2,
>    "map": "verdict",
>    "elem": [ [ "*", {
>         "jump": {
>            "target": "testchain"
> [..]
>     },
>     {
>       "chain": {
>         "family": "ip",
>         "table": "test",
>         "name": "testchain",
>         ...
> 
> Problem is that the json input parser does cmd_add at the earliest opportunity.
> 
> For a simple input file defining a table, set, set element and chain, we get
> following transaction:
>  * add table
>  * add set
>  * add setelem
>  * add chain
> 
> This is rejected by the kernel, because the set element references a chain
> that does (not yet) exist.
> 
> Normal input parser only allocates a CMD_ADD request for the table.
> 
> Rest of the transactional commands are created much later, via nft_cmd_expand(),
> which walks "struct table" and then creates the needed CMD_ADD for the objects
> owned by that table.

JSON parser simply does not support nested syntax, like, for instance:

| table test {
| 	map testmap {
| 		type ipv4_addr : verdict
| 		elements = {
| 			"*" : jump testchain
| 		}
| 	}
| 	chain testchain {
| 	}
| }

Your example above is equivalent to the following in standard syntax:

| add table t
| add map t m { type ipv4_addr : verdict; elements = { 10.0.0.1 : jump mychain }; }
| add chain t mychain

It is rejected by nft as well:

| /tmp/input.nft:2:54-61: Error: Could not process rule: No such file or directory
| add map t m { type ipv4_addr : verdict; elements = { 10.0.0.1 : jump mychain }; }
|                                                      ^^^^^^^^

(Note the wrong marker position, an unrelated bug it seems.)

If I swap the 'add map' and 'add chain' commands in input, it is
accepted.

Cheers, Phil
