Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="opAj57fh"
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF5883;
	Thu, 30 Nov 2023 06:17:08 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1701353825; bh=yghvjtwfe2VoJIk53aHU8FWUgdXH2HkotJ7JMAjgvv8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=opAj57fhbJfKcAE+hZ9nHFm8WYWDky/N8TsuvNmO4LDnhlqLTO5cjxjfYo6u2ZQwO
	 PkOyD5UMD0UQISsL5XQl4QfTiIy8RGzOI1pQqbcfCN3wMtEzFTwZdatn+AeKtMG1ZH
	 aL8KOYAXk426EIKQ/M6grA3PNsf9Nr7Z/ivWZ4eN10uDCpLP89bgrHBqtd5NsjM6F8
	 3QWycqSQbZrxZzvqkjttTMlE8SLPd6sYIzyB44o73jicXkxtra7C9CrwGY26NOTeK/
	 4uv9oL4YX4aVBRM9gcRBjsRUfDwYIazz5D9HmAXPlpf1XdWdFCZv+4/w2CWEXXo53W
	 LroZ6qNQ5LUOg==
To: Florian Westphal <fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
 lorenzo@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add flowtable map for
 xdp offload
In-Reply-To: <20231130135308.GA5447@breakpoint.cc>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-8-fw@strlen.de> <87il5re7su.fsf@toke.dk>
 <20231130135308.GA5447@breakpoint.cc>
Date: Thu, 30 Nov 2023 15:17:05 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ttp31g2m.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:
>> I am not a huge fan of this flag, especially not as UAPI. Using the XDP
>> offload functionality is already an explicit opt-in by userspace (you
>> need to load the XDP program). So adding a second UAPI flag that you
>> have to set for the flowtable to be compatible with XDP seems to just
>> constrain things needlessly (and is bound to lead to bugs)?
>
> I can remove it.  But it leads to issues, for example one flowtable
> can shadow another one.
>
> I'd prefer to handle this from control plane and reject such config.
> Alternative is to ignore this and handle it as "self sabotage, don't
> care" combined with "do not do that, then".

I do see your point about avoiding invalid configurations, but, well XDP
is already very much a "use it right or it will break on you" kind of
thing, so I think that bit is kinda unavoidable. As in, upon loading the
XDP program that does the lookup, you can validate the configuration and
reject loading if it's setup in a way that your program can support.
Whereas if you have to set a flag on the flowtable itself, that means
you have to make changes to the nft ruleset itself to be compatible with
XDP acceleration (right?), you can't just go "accelerate my existing
ruleset".

>> If we can't change the behaviour, we could change the lookup mechanism?
>> BPF is pretty flexible, nothing says it has to use an ifindex as the
>> lookup key? The neatest thing would be to have some way for userspace to
>> directly populate a reference to the flowtable struct in a map, but a
>> simpler solution would be to just introduce an opaque ID for each
>> flowtable instance and use that as the lookup key (userspace could
>> trivially put that into a map for the BPF program to find)?
>
> Won't that complicate things?  Userspace will have to use netlink
> events to discover when a flowtable is removed, no?

Well, I am kinda assuming that userspace is the entity doing the
removing, in which case it should already know this, right? I must admit
to being a little fuzzy on the details of when a flowtable object is
replaced, though. For instance, does reloading an nft ruleset always
replace the flowtable with a new one (even if there's no change to the
flowtable config itself)?

-Toke
