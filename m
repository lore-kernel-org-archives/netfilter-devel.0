Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E887D39FD6;
	Fri, 29 Mar 2024 22:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711750330; cv=none; b=j7hSsPOLq1kERq0GSa6k+MXlehN1DPwi2k6D/Xa0+EjLNhCZwiacFaMYIjM+9MJqn190FvHMzb2bLsJk+LvHzwVH/j5plCzzZO4GeiHXqTLTuslucB0KzrUwi/dqZINb01ES5UBPbVeV6Cy42qnqbofDfJEZw9KmC1JJFB1KvEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711750330; c=relaxed/simple;
	bh=4pyAcfmQivB1ekKoU0AtYp3wcKhIcJ+R2eM65+IthZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfigRfo5/Uim0BVvEDTIcbuFDYqMdNqZgyAUrlQ2bnpIfA5o6QZyc4qNA394xCV4cbz//O/tklE3+v56YUbtg380gSm0AjKbOvFetVLHjdqrVYvEjpCzMCW1Tni6q66LhSTn2Cqn3dWmZxoRlt89S6VpIgfuAuw6PpcxMk0tBgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 29 Mar 2024 23:12:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Stanislav Fomichev <sdf@google.com>, donald.hunter@redhat.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/2] tools/net/ynl: Add multi message support
 to ynl
Message-ID: <Zgc8tPPX2fdJ1AJP@calendula>
References: <20240327181700.77940-1-donald.hunter@gmail.com>
 <20240327181700.77940-3-donald.hunter@gmail.com>
 <20240328175729.15208f4a@kernel.org>
 <m234s9jh0k.fsf@gmail.com>
 <20240329084346.7a744d1e@kernel.org>
 <m2plvcj27b.fsf@gmail.com>
 <CAD4GDZw0RW3B2n5vC-q-XLpQ_bCg0iP13qvOa=cjK37CPLJsKg@mail.gmail.com>
 <20240329144639.0b42dc19@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240329144639.0b42dc19@kernel.org>

On Fri, Mar 29, 2024 at 02:46:39PM -0700, Jakub Kicinski wrote:
> On Fri, 29 Mar 2024 21:01:09 +0000 Donald Hunter wrote:
> > There's no response for 'batch-begin' or 'batch-end'. We may need a
> > per op spec property to tell us if a request will be acknowledged.
> 
> :(
> 
> Pablo, could we possibly start processing the ACK flags on those
> messages? Maybe the existing user space doesn't set ACK so nobody
> would notice?
> 
> I don't think the messages are otherwise marked as special from 
> the "netlink layer" perspective.

It is possible to explore this. I don't have a use-case for NLM_F_ACK
and the begin marker message at this stage.

Thanks.
