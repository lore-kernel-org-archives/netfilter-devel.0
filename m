Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FF7271467
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998713; cv=none; b=mK+LiPgyOWh8p/FRMhzhvJaeH4DC5adfRmiUwcqluVSxK2TMTpAl7aXriBFiwxvhLUAFqzmwGOpa0PuBomaUe8wGMux/BGFWW/053dguAksj7CA9L6Xn+nQLjBRj2wHxFoESURiLtE+Zb6Sz4ZGc+LK6WbD1GYMbnJgWKMKTw5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998713; c=relaxed/simple;
	bh=EI2DHnrzFs/nXNC+B6HOGFTgXav4Jr1MR5jslKVqWL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhkE4jxDRM3KuRPh6r3++goTmSyuU7DzzP2E09dIlEJNG4QJ81PNwwBRcBCixUHDRqd0GIvCo5Dh0NIxkVYneKhycsXvi0YWCnNXj3G26LE+3XGRsTiFmIus+QcK+M30Kv1/6deemD0lrqfkOabECvO0W1NrRzpgfbqZW7BIRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 55C7C6109E; Tue, 21 Oct 2025 00:18:29 +0200 (CEST)
Date: Tue, 21 Oct 2025 00:18:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v3 4/6] doc: add more documentation on bitmasks and sets
Message-ID: <aPa1NdDe-snoN1AG@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
 <20251019014000.49891-5-mail@christoph.anton.mitterer.name>
 <aPX7qH9nCZ5VfxEJ@strlen.de>
 <cb2b48e9a9d4d8c13b53297e5cc4482e0057deec.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb2b48e9a9d4d8c13b53297e5cc4482e0057deec.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> On Mon, 2025-10-20 at 11:06 +0200, Florian Westphal wrote:
> > Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote: 
> > > +Equality of a value with a set is given if the value matches
> > > exactly one value
> > > +in the set.
> > 
> > That contradicts whats right above, which describes range handling.
> 
> Uhm... what exactly do you mean?
>
> But that's anyway missing the stuff about how interval values are
> matched, which I only sent as stand alone patch in some mail before.

Yes, I meant wrt. intervals, there is no need for the value to be in
the set, match can also happen via range.

> > > +It shall be noted that for bitmask values this means, that
> > > +*'expression' 'bit'[,'bit']...* (which yields true if *any* of the
> > > bits are set)
> > > +is not the same as *'expression' {'bit'[,'bit']...}* (which yields
> > > true if
> > > +exactly one of the bits are set).
> > > +It may however be (effectively) the same, in cases like
> > > +`ct state established,related` and `ct state
> > > {established,related}`, where these
> > > +states are mutually exclusive.
> > 
> > Would you object if I apply this patch but onlt rhe first part?
> 
> You mean: not the changes to nft.txt?

Yes, only those in doc/data-types.txt, namely this:

diff --git a/doc/data-types.txt b/doc/data-types.txt
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -26,6 +26,30 @@ integer
 
 The bitmask type (*bitmask*) is used for bitmasks.
 
+In expressions the bits of a bitmask may be specified as *'bit'[,'bit']...* with
+'bit' being the value of the bit or a pre-defined symbolic constant, if any (for
+example *ct state*’s bit 0x1 has the symbolic constant `new`).
+
+Equality of a value with such bitmask is given, if the value has any of the
+bitmask’s bits set (and optionally others).
+
+The syntax *'expression' 'value' / 'mask'* is identical to
+*'expression' and 'mask' == 'value'*.
+For example `tcp flags syn,ack / syn,ack,fin,rst` is the same as
+`tcp flags and (syn|ack|fin|rst) == syn|ack`.
+
+Note that *'expression' 'bit'[,'bit']...* is not the same as *'expression'
+{'bit'[,'bit']...}*.
+The latter form is a lookup in an anonymous set and will match only if the set
+contains a matching value.
+Example: *tcp flags syn,ack* matches packets that have the SYN, the ACK, or both
+SYN and ACK flags set.  Other flags, such as PSH, are ignored.
+*tcp flags { syn, ack }* matches packets that have only the SYN or only the ACK
+flag set, all other flag bits must be unset.
+
+As usual, the the *nft describe* command may be used to get details on a data
+type, which for bitmasks shows the symbolic names and values of the bits.

This contains minor edits only, I don't see anything wrong with the
above and I think that this is a worthwhile addition to the
documentation.

> What I think should be kept being added to the SETS documentation in
> nft.txt is:
> > Equality of a value with a set is given if the value matches exactly
> > one value
> > in the set (which for intervals means that it’s contained in any of
> > them).
> 
> Cause that's currently nowhere really documented, AFAICS.

Oh, yes, makes sense to mention that.

> The following:
> > It shall be noted that for bitmask values this means, that
> > *'expression' 'bit'[,'bit']...* (which yields true if *any* of the
> > bits are set)
> > is not the same as *'expression' {'bit'[,'bit']...}* (which yields
> > true if
> > exactly one of the bits are set).
> 
> Can be skipped, or maybe one should add a small reference like:
> > See <<BITMASK TYPE>> for how equality checks differ between sets and
> > bitmasks.

Reference is fine.

> This:
> > It may however be (effectively) the same, in cases like
> > `ct state established,related` and `ct state {established,related}`,
> > where these
> > states are mutually exclusive.
> 
> We can either simply drop, or move over to the BITMASK TYPE section.
> It's not super important, but I think there might be some value in
> understanding why these are identical (especially as many people use
> something like ct new {established,related}.

Yes, its an exception by virtue of a flow being either-or...

If you think it should be documented then maybe it should be added to
the bitmask example, it documents the difference with tcp flags example,
maybe the counterexample can be made there.

(Its not identical, however -- the established,related [ no set ] way is
slightly faster).

> Wanna a new patch or are you going to do it yourself?

Can you just revamp this one patch?  I thin its the one closest
to applicable form.
