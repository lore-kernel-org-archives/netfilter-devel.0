Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E702D47EB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004975; cv=none; b=ZGL+GE4Ur3mfubzh+j0fyfuD8i3MikIUm7hBBgw+VACYt3ySQxhV8yLw3/Uf0kPokeS4JGzfFhbxuO1bLlDoFuzF8HyopBOLxemDs+nx8MYO1z9FNDwDhNA9gCB39UepPE7VqQHTtOkMdJiKiAo9wqNh1brNRfpZWc6vG91iFHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004975; c=relaxed/simple;
	bh=uUF16qQKSKUyRCA8Q1JjxQi9rRlHjKMc35fFXf5cp88=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAXI47KTqRkMAFpY7XK+NJHE3kDSD3X+awbSiK3b6NuSSUc6wk2Q5ZK2DpyKCZHVXJt3gdigASPaPcRfjQWrj249CFdglKGXuNS0c14unbVde2GQ4TQbqErU1YkNLl5uZ3TXV5q00TbFVeF44QOejgC4hfl10NJ3Sw3aIcNXMYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S3ENjaI+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S3ENjaI+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S3ENjaI+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S3ENjaI+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CB2F660735; Thu,  4 Sep 2025 18:56:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757004970;
	bh=qCnn4EEXcdUAUnrbJGuFj/Bl74L+xKXWymN9H8OutrQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=S3ENjaI+vWcV7jcDAY9U4933N6KqbQ9BoxLuwU68GEvYT7lSbvWeh+A8u9T+oPI0p
	 FSOSZ8zoz+RbqRM2WliJnzHquUcPRcS27l70jd1pdWQC0sJ+euhVWLqSx+PX+uuy8O
	 /nz7WJoEmUyLPCKaXPK7nhHgi/Sm26rzpnMzorNpuo9g8v4Y3ArUelKXmRXZ1WJ7K5
	 SLpUSqkTO7qo/zuJJInBvpoAyeeMj5PHEuoJ5nR8r5+nI077f6LeCP+CEz+YLxJfz8
	 dbaKY2eCQMBw3aFS+cQW8RK90n0NtXf8c5+pVJYRHjkcpxkKxrWRvAr+PTdoCsjvUQ
	 l27Om8Q6MUEAQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3266760731;
	Thu,  4 Sep 2025 18:56:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757004970;
	bh=qCnn4EEXcdUAUnrbJGuFj/Bl74L+xKXWymN9H8OutrQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=S3ENjaI+vWcV7jcDAY9U4933N6KqbQ9BoxLuwU68GEvYT7lSbvWeh+A8u9T+oPI0p
	 FSOSZ8zoz+RbqRM2WliJnzHquUcPRcS27l70jd1pdWQC0sJ+euhVWLqSx+PX+uuy8O
	 /nz7WJoEmUyLPCKaXPK7nhHgi/Sm26rzpnMzorNpuo9g8v4Y3ArUelKXmRXZ1WJ7K5
	 SLpUSqkTO7qo/zuJJInBvpoAyeeMj5PHEuoJ5nR8r5+nI077f6LeCP+CEz+YLxJfz8
	 dbaKY2eCQMBw3aFS+cQW8RK90n0NtXf8c5+pVJYRHjkcpxkKxrWRvAr+PTdoCsjvUQ
	 l27Om8Q6MUEAQ==
Date: Thu, 4 Sep 2025 18:56:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 2/8] tests: py: Enable JSON and JSON schema by
 default
Message-ID: <aLnEqJBm6tNK4IrQ@calendula>
References: <20250904152454.13054-1-phil@nwl.cc>
 <20250904152454.13054-3-phil@nwl.cc>
 <aLmwcg4B6JwfqQfR@calendula>
 <aLm6kp0mJfge4_Me@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLm6kp0mJfge4_Me@orbyte.nwl.cc>

On Thu, Sep 04, 2025 at 06:13:06PM +0200, Phil Sutter wrote:
> On Thu, Sep 04, 2025 at 05:29:54PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 04, 2025 at 05:24:48PM +0200, Phil Sutter wrote:
> > > Introduce -J/--disable-json and -S/--no-schema to explicitly disable
> > > them if desired.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  tests/py/nft-test.py | 16 ++++++++++++----
> > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > > index 984f2b937a077..12c6174b01257 100755
> > > --- a/tests/py/nft-test.py
> > > +++ b/tests/py/nft-test.py
> > > @@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
> > >  
> > >      parser.add_argument('-j', '--enable-json', action='store_true',
> > >                          dest='enable_json',
> > > -                        help='test JSON functionality as well')
> > > +                        help='test JSON functionality as well (default)')
> > > +
> > > +    parser.add_argument('-J', '--disable-json', action='store_true',
> > > +                        dest='disable_json',
> > > +                        help='Do not test JSON functionality as well')
> > 
> > Would it be possible to have common options to the different tests?
> > 
> > 1/8 uses -s and -j.
> > 
> > I am not sure we have to worry about breaking backward for test
> > syntax, we only run this.
> 
> It's a bit of a mess with nft-test.py as it always performs standard
> syntax testing and JSON syntax is an add-on one may enable (or not). So
> to test JSON only, I'd have to refactor the ~300 lines long rule_add()
> function. Not the worst thing to do, but much more work than "just"
> having --enable-json being the default.

Oh, I see, so this is:

* no -j, then only standard is tested.
* -j, both standard and json are tested.

Maybe more simple is to reverse this logic, ie.

* no -j, then both standard and json syntax are tested.
* -s, only standard is tested.

Does this help?
