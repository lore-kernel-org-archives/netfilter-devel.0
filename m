Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FB42AA6
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731508553; cv=none; b=H8NlWVe4plPAj4sSuBECnB8l0eNa4V0Z0LMT43X9lou3KhW52sJxatbWIzMKK1rQN5LjvmVbfRgQtZllA+lYjo/k4JjCmI2sMHtaq7rxkJYzhPWu/kdMK/yDtqf7hwtG0HhdYeVBTE9G227NiovRre8BsS1TksacWVzTvYL2urQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731508553; c=relaxed/simple;
	bh=5zb19Eq+JOWTnSMrLWSwl2F5TkNUeQe6ouqJlGQYuZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToM5PRm2WE0uMBtW7UicYUODgF+adHnG1X3gJu4X3cyol3SGvVMeNsM7e1D7tHrRhr1VXSBGNBoM8lRBgZd67iInfs47a4RqV7Zf2vhIjyoBYtjBD4OSVfLwTH0Zie9yQ4OV8PfJdJRWfC/tO7uyec4tImjeqPd7j/Cbi9OLu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cPblO+lr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cPblO+lr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jY5Xyo5iqmJ4WxAWcezCK32RAawm0ZnxrNSTlebxuqM=; b=cPblO+lrG5i6OFe3xaPXzwLk6A
	TJjiTDZLJUyfHrRYTvfjzI0iRcjGyxEe9dnzXuLXWjGHjESWV8TzELd3NkcKu3ahs2e3gHGXiajHg
	ByuqJ0oIL+ey8mtaKXxT6BMia3s7MbZgbc/jSAXkYw5NYu5jomyGANuQS7ywLRMNoTuLJdMKvCfDD
	fj+mmuwZqfOxGedwsgmgLiAoaYZY01sKik3renpCqWlmUB3B0U15vz6TM1TRK4OdRwjo8ynC484IA
	Q8CSkD9W1KQWwiQbzepO6LRdDq7Ot8e5F+g1TA293n35E5VBuNqKeks5kBSIwgRn1VOST5/0zLT9c
	pAJZr2cw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tBETE-000000008K7-1soS;
	Wed, 13 Nov 2024 15:35:48 +0100
Date: Wed, 13 Nov 2024 15:35:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZzS5ROp_FUeF9gkm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, eric@garver.life
References: <20241031220411.165942-1-pablo@netfilter.org>
 <ZzPAE3Gj6qoA8ZAk@orbyte.nwl.cc>
 <ZzSG8xWKI5Re0Xcy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzSG8xWKI5Re0Xcy@calendula>

On Wed, Nov 13, 2024 at 12:01:07PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Nov 12, 2024 at 09:52:35PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> > > Side note: While profiling, I can still see lots json objects, this
> > > results in memory consumption that is 5 times than native
> > > representation. Error reporting is also lagging behind, it should be
> > > possible to add a json_t pointer to struct location to relate
> > > expressions and json objects.
> > 
> > I can't quite reproduce this. When restoring a ruleset with ~12.7k
> > elements in individual standard syntax commands, valgrind prints:
> > 
> > | HEAP SUMMARY:
> > |     in use at exit: 59,802 bytes in 582 blocks
> > |   total heap usage: 954,970 allocs,
> > |                     954,388 frees,
> > |                  18,300,874 bytes allocated
> > 
> > Repeating the same in JSON syntax, I get:
> > 
> > | HEAP SUMMARY:
> > |     in use at exit: 61,592 bytes in 647 blocks
> > |   total heap usage: 1,200,164 allocs,
> > |                     1,199,517 frees,
> > |                    38,612,257 bytes allocated
> > 
> > So this is 38MB vs 18MB? At least far from the mentioned 5 times. Would
> > you mind sharing how you got to that number?
> > 
> > Please kindly find my reproducers attached for reference.
> 
> I am using valgrind --tool=massif to measure memory consumption in
> userspace.
> 
> I used these two files:
> 
> - set-init.json-nft, to create the table and set.
> - set-65535.nft-json, to create a small set with 64K elements.
> 
> then I run:
> 
> valgrind --tool=massif nft -f set-65535.nft-json
> 
> there is a tool:
> 
> ms_print massif.out.XYZ

Thanks! I see it now. Interestingly, I had tried feeding the ruleset on
stdin and that makes standard syntax use more memory, as well. With the
rulesets being read from a file, standard syntax indeed requires just
7MB while JSON uses 35MB.

> At "peak time" in heap memory consumption, I can see 60% is consumed
> in json objects.

The problem with jansson in that regard is that it parses the whole
thing recursively. In theory it would be possible to parse just the
outer object and continue parsing array elements by the time they are
accessed.

Interestingly, I managed to reduce memory consumption by 30% by
inserting a json_decref() call here:

| @@ -3496,6 +3498,7 @@ static struct cmd *json_parse_cmd_add_element(struct json_ctx *ctx,
|         h.set.name = xstrdup(h.set.name);
|  
|         expr = json_parse_set_expr(ctx, "elem", tmp);
| +       json_decref(tmp);
|         if (!expr) {
|                 json_error(ctx, "Invalid set.");
|                 handle_free(&h);

This does not fix a memleak, though: 'tmp' is assigned by a call to
json_unpack(... "s:o" ...) and thus does not have its reference
incremented. So AIUI, we're causing parts of the JSON object tree to be
freed and later accesses are problematic: e.g. --echo mode will abort
with "corrupted double-linked list" error.

> I am looking at the commands and expressions to reduce memory
> consumption there. The result of that work will also help json
> support.

Cheers, Phil
