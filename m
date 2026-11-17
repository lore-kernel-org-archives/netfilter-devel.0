Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909472;
	b=Uek32839yZyHXcabLC2X91TzQMyoKuPrUvkqGj4BVKz+RFsxk6f6z5RgEe4Gdi4l5Nur
	 kAg4DlAIQ1gqU2dRClc+4RtNF0sGRYfKZ6oSXe8VXs+wbr58UUfKFL61MVgptOIzAUuBN
	 For25aF3KIavWeCcWeK7ylTagOT+0z413Q2O9ilh9TYi4NiiuFq4i65FUenubPalaFsjZ
	 3Vin8jt15bNsnEG0MxOrFJ+QVqdxXkqgvaQR+1cGnE4Y0/f53MPSl5BtL3W4GQWvuodAC
	 LjB55KW6OWAWizql1A60R9/TSndWe9048p8RMwK1ySXdW+ALUQ8d3ZAzZxI7IlMjV8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909472;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NPBCRni7dqPhXV3m0qj8RnZnSgSXxrY9Otftjlz4nOo=;
	b=oNbNN6LypXBKl7QmIJyAxL8TObf4AeVtw4Ak7y1PAYbNlw/b4FilCk1INhhlG1MJOSI+
	 MOnJwK9nonx8Csf8hR5bhbWZccHHY3y2FTR56WHEg4CExX4ITF3abvSA0JBaOBbUSQn05
	 a0KMD8oJ2KT5dCInL5owuzgYcC8zchRuZ7kyHZpin8qOCWIzr08cuOrQoXA9MyfTeWaGa
	 eX+dK3FU9PmLZKhU+RcGNQtVSZrrvB+WEKbc/CxPX4JMDIbIzMYZBtwVKqF+amagUnBpd
	 6HyVNbrmAu9VwaPOy7x/lJXc5pFEOsfir0wBPLmTF8JWyrRZFyFISWj0q58LZH3dHaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2b2zNJG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC7E606A31C;
	Tue, 17 Nov 2026 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2b2zNJG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51651F000C5;
	Tue, 17 Nov 2026 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794909472;
	bh=NPBCRni7dqPhXV3m0qj8RnZnSgSXxrY9Otftjlz4nOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U2b2zNJGNI4HHyq2IiKuNP5On/KDos2GxvOOzL7wzeD/LOkKB+XKZkjk34oQ7gohm
	 CFLWgzBRnzY/Ba8Wa6c+J4OsIregkPa8Osw7EnAnV/h629VFJ+uWxftT+NE+jl8nuW
	 zS4qZ9xKBXp4zRjb6KCFryymTUYItGntvHsJPI10=
Date: Tue, 17 Nov 2026 10:57:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: onLeaf <onleaf322@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ipset: exclude add-path GC during resize
Message-ID: <2026111728-deduct-chastise-eac8@gregkh>
References: <20261117092731.14656-1-onleaf322@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117092731.14656-1-onleaf322@gmail.com>

On Tue, Nov 17, 2026 at 06:27:31PM +0900, onLeaf wrote:
> mtype_resize() copies elements to the new table including their extension
> pointers. Garbage collection of an expired element in the old table after
> the copy therefore frees an extension still referenced by the new table.
> 
> Commit cffcf57bf03c ("netfilter: ipset: exclude gc when resize is in
> progress") prevents the delayed-work collector from running during resize.
> However, mtype_add() also invokes mtype_gc_do() directly when its target
> region is full. The packet path can enter this call while a userspace
> resize is copying the old table. It then frees the old copy's comment, and
> collection of the published copy queues the same object for freeing again.
> 
> An unprivileged process can reach packet-side ipset add with CAP_NET_ADMIN
> in newly created user and network namespaces. The resulting duplicate free
> was reproduced with KASAN on x86-64 and exploited from UID 1000 to UID 0 in
> the initial user namespace on a non-KASAN build.
> 
> Serialize the direct collector with the same GC lock and honor the pinned
> table's resizing flag, just as the delayed-work collector does. The table
> remains pinned by uref while the lock is held.
> 
> The issue was found through AI-assisted source review. On the fixed kernel,
> the same copy/old-GC/publish/new-GC ordering completed without producing a
> duplicate object; /etc/passwd remained unchanged and the test ended in
> LPE_FAIL.
> 
> This change was prepared with assistance from OpenAI Codex.
> 
> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@vger.kernel.org
> Signed-off-by: onLeaf <onleaf322@gmail.com>

Real name please.
