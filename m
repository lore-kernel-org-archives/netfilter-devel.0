Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6DD43DA4B
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316888; cv=none; b=lV6diekHM09svDIvPNXlPGeyxBCE6LJ3/y+eb7qFOnAebeEd3oQnbjzK7mpDNashWKnoQjCTN/PQ50gi5454t+6i9vAzSVlbA0c+IXBoiFWSGPM/13oP1bx3C3vC/HMFflnyEvBtIRYKTbKqXg4MGst3FuZfWSS6aQfxclTv2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316888; c=relaxed/simple;
	bh=72CTobXy4BOkBP9zgC9Iuli2Bfn0Mfzy/srk5goZ8SY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/zhnSLE3pWZXYVCC8fCZNkD3ay2EBk9d6IWfaQiAVlF6CjzsdvYs7XKs3RZ/xsBYsSkoFQm67WyrGU9OZzJsaEWMFvARs6kaLTEXZiG3CZ08V5CGiwqHIV5WOKOHlJ8S1nBlvrgMgNjPNj8tLbHiBUeXxb7hDdhNjRn0IPsA4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qpzVj57z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qpzVj57z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6RQ5xwodq7p8WIQ5uoJj7hZJYV4DThqF3f5ZZ8c3Nxo=; b=qpzVj57zwKkiiaUPHj8uTLgi9A
	Qyog5cSoi4kdNh/E53YD8vTrzTQKvMXp20DKVFk8ywhBUlyDrwlAwb7RjHcn5xu9+3oAWEv4SJkGu
	4CusWg8HI4cGsgAE8tIIyawXLw/udkvzjXXTzlYYB0NThdE+TRqNuaHUkmKY0PL8vOnAnaw4wnPHl
	OSBqQZDCgfua9IUQPg0nxIDTFG/2WUpYwsHrmmmvhJwwngx09/24vWyf5u0vgXH9/i/C+qBGvIN2j
	lHWEqiXXiTQagWJJsIZMYfo7jT0ItRgozqE/ubiqqaLKu+57Js9+/TYyWBZyC92KOFkXtH0eu4O+Y
	63yH4h2Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wp0Ta-000000006qd-17zl;
	Wed, 29 Jul 2026 11:21:22 +0200
Date: Wed, 29 Jul 2026 11:21:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amnGEhXHD5175bxC@orbyte.nwl.cc>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com>
 <amjWjTkt1Dsh66Xv@orbyte.nwl.cc>
 <amkAJuVZmpGy7pvY@chamomile>
 <20260728201909.1773000-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728201909.1773000-1-avinash.duduskar@gmail.com>

On Wed, Jul 29, 2026 at 01:49:09AM +0530, Avinash Duduskar wrote:
> On Tue, Jul 28, 2026 at 09:16:54PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 28, 2026 at 06:19:25PM +0200, Phil Sutter wrote:
> > > So with nft printing non-existent cgroup names using PRIu64 and parsing
> > > code still performs the path lookup first, what is all the fuss about
> > > non-decimal number input?
> >
> > They claim they cannot delete entries via numeric value, it seems.
> 
> Correct, the earlier example proves it.
> 
> A typo'd id can collide with a live inode and then list as another
> cgroup's path. Fine with dropping the checks if you prefer.

Isn't this "garbage in, garbage out" then?

> > > Is this AI output?
> 
> Yes. Point taken on the length.
> 
> > > Can't this just be something like (untested):
> > > [...]
> 
> Yes. v2, keeping the two checks:
> 
> 	if (stat(cgroupv2_path, &st) == 0) {
> 		ino = st.st_ino;
> 	} else if (isdigit((unsigned char)sym->identifier[0])) {
> 		char *end;
> 
> 		errno = 0;
> 		ino = strtoull(sym->identifier, &end, 10);
> 		if (*end != '\0' || errno == ERANGE)
> 			return error(&sym->location, "invalid cgroupv2 id");
> 	} else {
> 		return error(&sym->location, "cgroupv2 path fails: %s",
> 			     strerror(errno));
> 	}
> 
> > > out=$($NFT -j list table t)
> > > [...]
> > > $NFT -j -f - <<< "$out"
> 
> Will do.
> 
> > > Hmm. Looks like we'll have to update all .json-nft files if we ever bump
> > > json_schema_version. Maybe json_pretty should drop that array elem, we
> > > merely keep asserting it exists and that could be done by a dedicated
> > > shell test.
> 
> Can do that as a follow-up if wanted.

It may be a political decision whether that part of JSON output should
be trimmed or not (there was hesitance when I requested to pipe output
through json_pp). So maybe only do it if you don't break a leg over it:
Use jq or awk to eliminate the metainfo object and write a simple test
which asserts its presence in output.

Thanks, Phil
