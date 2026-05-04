Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C91B34BA28
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777890988; cv=none; b=EhCm22UAZcGxgllwUV2Q54a6wwQiBMFGE1kLJ5KR5s/Fs9JqlO+ARwAfYslfQDnPvbmhdUtuNIpPEqh7bp+/c5Dj1x63GMx5tzXR4y444RtaNfpRCi33VfcZXXE7zcOOXe+S//PMXqw1/8g0AiQtUqfJIXyBMIZIAodcGPzc3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777890988; c=relaxed/simple;
	bh=ZEaEIxLtUBcnptiQOXPAOOKklQsBQJRh5exgIEIMvcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6+IzPCOZpnynonpxle+U2TiJjHb5XjLDSjt6z/KnCW8Wkwn6PzYIeE4lZqp/0NS+dctrBxeca9deKTJVC3+OzaHkqB/Rs4WES7+5eo76lois4HBoTzf6wnhdaA7TfAacmlVHq40q+UFITwzhkDxYy1Bkfgqv3CcQl3I/hkVGiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BXwPt0Q/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BXwPt0Q/"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C25C660179;
	Mon,  4 May 2026 12:36:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777890976;
	bh=f32qqd2Lh6Av6qwQEq7wFR0uANiXRdk15YbxMXZVHJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXwPt0Q/R935IFp4cadHblx2OgIItVx3puNUT9OZMo3YKdWmx9ZnNyepb+ZTuY4b/
	 0NS+W3+jtxwccwH70Uim3vFeoVRKZ0iMBNbtt6jHeE1j9t3X0Yz9MFzavTre3j49av
	 WcVusuPFzPcPrHeHx9YSQgfaJb26bt5Z2paV0Jvi3Jd5qCEeC6WQGBa23tzItyIziP
	 9dqrCB6ciYmXuTISdvhTg8zdg3OtVYa6B0sASQ+UzjbIhqF3AXiNev3JC0dgq/i0R8
	 xlObWz/Trsw8ap1ZW51oixJxTNH5v3qyz8EwrKUhoRA/GUBcV3AABogAZ2+X8g+Wsm
	 Y3lpEDN3PrXUw==
Date: Mon, 4 May 2026 12:36:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: tomaquet18 <tomaquet18@protonmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v3] netfilter: conntrack: fix integer overflow in
 expectation timeout
Message-ID: <afh2nhDpxA_fpvMN@chamomile>
References: <URoBmF5z41cfYHGx8q3nhf3YY8hHFUEBPerB7PUqjKfy_QJ4Ka-i6Vd-_gCFnz3zk6ehxJLuQbbsw9QXoI2Z65Ey3vzsbrZwwI2I76m7VHo=@protonmail.com>
 <afgHrJui7augpjpY@1wt.eu>
 <l8AVWvD6RoSmOCOiqbZjUDtyKQ1edunHPFxlYRyOFmcGArTkah4UWfxXZ7bXUTR_4xE4DBb0g-ihuV6htO-hkgEVPcMtkKNt7QczaF0YzGw=@protonmail.com>
 <2026050434-regulator-quadrant-dea5@gregkh>
 <f23njo6iy6gjV6hIAuL-14bzzPrCruI62xydmyd9GtYmKQIY4x91k1tqKeT7LufsDxVKKUBi6rzkQgq0uj-YSApJe9-L56z2h-U4dvPBLZA=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f23njo6iy6gjV6hIAuL-14bzzPrCruI62xydmyd9GtYmKQIY4x91k1tqKeT7LufsDxVKKUBi6rzkQgq0uj-YSApJe9-L56z2h-U4dvPBLZA=@protonmail.com>

Hi,

This is not security stuff, submitting this via
netfilter-devel@vger.kernel is sufficient.

Patchwork does not show your patch.

https://patchwork.ozlabs.org/project/netfilter-devel/list/

On Mon, May 04, 2026 at 10:14:25AM +0000, tomaquet18 wrote:
> Hi Pablo, Florian, and Greg,
> 
> Here is the v3 resubmission of the fix, with the changelog text properly wrapped at 72 columns as requested.
> 
> Regarding the security implications: while this function requires CAP_NET_ADMIN, I have verified that an unprivileged local user can trigger the overflow by setting up a user and network namespace (unshare -Ur -n).

What security implication? This is just the entry being removed
inmediately.

> Although this does not escape the sandbox, the 32-bit wrap-around forces the garbage collector to immediately destroy valid expectations. This breaks the integrity of the conntrack state machine and causes a selective local DoS against protocols relying on expectations within that environment.

What? "Selective local DoS against protocol relying on expectation"?

No, sorry. This is not security material, maybe nf-next stuff at best.

> Thanks for your time and review.
> 
> ---
> From b7a8f10666325ca70020769dc20d47776ccae440 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?=C3=80lex=20Fern=C3=A1ndez?= <tomaquet18@protonmail.com>
> Date: Mon, 4 May 2026 09:51:40 +0200
> Subject: [PATCH v3] netfilter: conntrack: fix integer overflow in expectation
>  timeout
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> In ctnetlink_change_expect(), the expectation timeout is calculated by
> multiplying the user-provided timeout value by HZ. Because ntohl()
> returns a 32-bit unsigned integer, this multiplication is performed in
> 32-bit arithmetic before being promoted to the 64-bit jiffies format.
> 
> If a user provides a large enough timeout (e.g., 42949673 on a system
> with HZ=100), the multiplication wraps around the 32-bit limit,
> resulting in a near-zero jiffies value. This causes the expectation
> to be immediately collected by the garbage collector instead of staying
> open for the requested duration.
> 
> This patch casts the result of ntohl() to u64 prior to multiplication,
> matching the safe pattern already used for standard conntrack timeouts.
> 
> Signed-off-by: Àlex Fernández <tomaquet18@protonmail.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index eda5fe4a7..be89bf1ba 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3466,7 +3466,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
>                         return -ETIME;
> 
>                 x->timeout.expires = jiffies +
> -                       ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> +                       (u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
>                 add_timer(&x->timeout);
>         }
>         return 0;
> --
> 2.43.0
> 
> On Monday, May 4th, 2026 at 10:10, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, May 04, 2026 at 08:05:45AM +0000, tomaquet18 wrote:
> > > Hi Willy,
> > >
> > > Thank you for the feedback and the guidance regarding the requirements. I completely understand.
> > >
> > > I have updated my identity to my real name. I am resending the fix as a v2 patch and including the Netfilter maintainers in CC as requested.
> > 
> > As this isn't a security issue, shouldn't this just be sent to the
> > normal mailing list and maintainers that way?  Again, no need to cc:
> > security@kernel.org anymore, right?
> > 
> > Also, you should wrap your changelog text at 72 columns.
> > 
> > thanks,
> > 
> > greg k-h
> >
