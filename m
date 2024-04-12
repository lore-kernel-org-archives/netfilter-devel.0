Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4D148313;
	Fri, 12 Apr 2024 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712936511; cv=none; b=U6wQpiRM/B2uA1e5IRzBusljNfU+7bZ0dghemZauOz+AooSzzEoEhCgCptKhatL/7/UEEVsW5Eliyqj5Xq76xcQDXggtVPIm0rkwrLVPi6ennSv8pp6UcaK7eutR9dipEOjfIj6xu150KlZOZjKnc9HLnkzCBRjVo/alZirn9Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712936511; c=relaxed/simple;
	bh=ltpldv20m8mKDyTh2QLhHxncVLR3ocLNjfeoAoBCP4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtoyYfeT3PDuyLepYNFfBCtJLw8YXHicOvpdMkHwIqWzh/Nn6tZlHhoEQgDIP+aJMvqTWKQhBcj8QSsIrTKaBcPMrw3a/JAcGDQOh6pw+X35qJEXbZlWnEaF/Q3p1fHU44CCKGoS4a7dFmRxRelfSsMAKzAfYYpkQ9+gecHzxEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=qpuJWG1p; arc=none smtp.client-ip=84.16.66.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="qpuJWG1p"
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VGLQW2n4DzHmL;
	Fri, 12 Apr 2024 17:41:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1712936499;
	bh=ltpldv20m8mKDyTh2QLhHxncVLR3ocLNjfeoAoBCP4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpuJWG1pkRY9dDvX0IxIKZF+uILKHVp697FDqEsGjnBtWdby0B3rPNMngoQmMDFTp
	 jjcDmnxCE2h72y/v+C+dutuuAjNBrfRy62OPxH2Q1pxbgYfKkRHVmV2w3Jvbx36dh0
	 oV5DRTUdt+5VGU+GTC5pCxsTHTn6sbT8auNMYWOw=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VGLQV5zqkzsWV;
	Fri, 12 Apr 2024 17:41:38 +0200 (CEST)
Date: Fri, 12 Apr 2024 17:41:38 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 01/10] landlock: Support socket access-control
Message-ID: <20240412.VeKuuY4ohG6e@digikod.net>
References: <20240408093927.1759381-1-ivanov.mikhail1@huawei-partners.com>
 <20240408093927.1759381-2-ivanov.mikhail1@huawei-partners.com>
 <ZhRKOTmoAOuwkujB@google.com>
 <a7e8f467-036c-a3e0-e26b-b5ba966b4e9e@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7e8f467-036c-a3e0-e26b-b5ba966b4e9e@huawei-partners.com>
X-Infomaniak-Routing: alpha

Thanks Ivanov, this looks really good!  Let me some time to review the
rest.

You can add this tag to the commit message (as reference and
documentation):
Closes: https://github.com/landlock-lsm/linux/issues/6

On Thu, Apr 11, 2024 at 06:16:31PM +0300, Ivanov Mikhail wrote:
> Hello! Big thanks for your review and ideas :)
> 
> P.S.: Sorry, previous mail was rejected by linux mailboxes
> due to HTML formatting.
> 
> 4/8/2024 10:49 PM, Günther Noack wrote:
> > Hello!
> > 
> > Just zooming in on what I think are the most high level questions here,
> > so that we get the more dramatic changes out of the way early, if needed.
> > 
> > On Mon, Apr 08, 2024 at 05:39:18PM +0800, Ivanov Mikhail wrote:
> > > diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> > > index 25c8d7677..8551ade38 100644
> > > --- a/include/uapi/linux/landlock.h
> > > +++ b/include/uapi/linux/landlock.h
> > > @@ -37,6 +37,13 @@ struct landlock_ruleset_attr {
> > >   	 * rule explicitly allow them.
> > >   	 */
> > >   	__u64 handled_access_net;
> > > +
> > > +	/**
> > > +	 * @handled_access_net: Bitmask of actions (cf. `Socket flags`_)
> >                             ^^^
> > 			   Typo
> > 
> 
> Thanks, will be fixed.
> 
> > > +	 * that is handled by this ruleset and should then be forbidden if no
> > > +	 * rule explicitly allow them.
> > > +	 */
> > > +	__u64 handled_access_socket;
> > 
> > What is your rationale for introducing and naming this additional field?
> > 
> > I am not convinced that "socket" is the right name to use in this field,
> > but it is well possible that I'm missing some context.
> > 
> > * If we introduce this additional field in the landlock_ruleset_attr, which
> >    other socket-related operations will go in the remaining 63 bits?  (I'm having
> >    a hard time coming up with so many of them.)
> 
> If i understood correctly Mickaël suggested saving some space for
> actions related not only to creating sockets, but also to sending
> and receiving socket FDs from another processes, marking pre-sandboxed
> sockets as allowed or denied after sandboxing [2]. This may be necessary
> in order to achieve complete isolation of the sandbox, which will be
> able to create, receive and send sockets of specific protocols.
> 
> In future this field may become more generic by including rules for
> other entities with similar actions (e.g. files, pipes).

I think it would make sense to have one field per file kind (not
necessarily type) because not all actions would make sense.

> 
> I think it is good approach, but we should discuss this design before
> generalizing the name. For now `handled_access_socket` can be a good
> name for actions related to accessing specific sockets (protocols).
> What do you think?

I'm OK with this name for now unless someone has a better proposition.

> 
> [2]
> https://lore.kernel.org/all/b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net/
> 
> > 
> > * Should this have a more general name than "socket", so that other planned
> >    features from the bug tracker [1] fit in?
> 
> I have not found any similar features for our case. Do you have any in
> mind?
> 
> > 
> > The other alternative is of course to piggy back on the existing
> > handled_access_net field, whose name already is pretty generic.

handled_access_net is indeed quite generic, but the question is: would
this new access right make sense for the net_port rule?  In the case of
socket creation, this is not the case because we don't know at this time
which port will be used.

> > 
> > For that, I believe we would need to clarify in struct landlock_net_port_attr
> > which exact values are permitted there.

Potentially anything that would be possible to check against a port.

> > 
> > I imagine you have considered this approach?  Are there more reasons why this
> > was ruled out, which I am overlooking?
> > 
> > [1] https://github.com/orgs/landlock-lsm/projects/1/views/1
> > 
> > 
> 
> Currently `handled_access_net` stands for restricting actions for
> specific network protocols by port values: LANDLOCK_ACCESS_NET_BIND_TCP,
> LANDLOCK_ACCESS_NET_SEND_UDP (possibly will be added with UDP feature
> [3]).
> 
> I dont think that complicating semantics with adding fields for
> socket_create()-like actions would fit well here. Purpose of current
> patch is to restrict usage of unwanted protocols, not to add logic
> to restrict their actions. In addition, it is worth considering that we
> want to restrict not only network protocols (e.g. Bluetooth).

Correct.  It's worth it mentionning this rationale in the patch
description.

> 
> [3] https://github.com/landlock-lsm/linux/issues/1
> 
> > > @@ -244,4 +277,20 @@ struct landlock_net_port_attr {
> > >   #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
> > >   #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> > >   /* clang-format on */
> > > +
> > > +/**
> > > + * DOC: socket_acess
> > > + *
> > > + * Socket flags
> > > + * ~~~~~~~~~~~~~~~~
> > 
> > Mega-Nit: This ~~~ underline should only be as long as the text above it ;-)
> > You might want to fix it for the "Network Flags" headline as well.
> > 
> 
> Ofc, thanks!
> 
> > > + *
> > > + * These flags enable to restrict a sandboxed process to a set of
> > > + * socket-related actions for specific protocols. This is supported
> > > + * since the Landlock ABI version 5.
> > > + *
> > > + * - %LANDLOCK_ACCESS_SOCKET_CREATE: Create a socket
> > > + */
> > 
> > 
> > > diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> > > index c7f152678..f4213db09 100644
> > > --- a/security/landlock/ruleset.h
> > > +++ b/security/landlock/ruleset.h
> > > @@ -92,6 +92,12 @@ enum landlock_key_type {
> > >   	 * node keys.
> > >   	 */
> > >   	LANDLOCK_KEY_NET_PORT,
> > > +
> > > +	/**
> > > +	 * @LANDLOCK_KEY_SOCKET: Type of &landlock_ruleset.root_socket's
> > > +	 * node keys.
> > > +	 */
> > > +	LANDLOCK_KEY_SOCKET,
> > >   };
> > >   /**
> > > @@ -177,6 +183,15 @@ struct landlock_ruleset {
> > >   	struct rb_root root_net_port;
> > >   #endif /* IS_ENABLED(CONFIG_INET) */
> > > +	/**
> > > +	 * @root_socket: Root of a red-black tree containing &struct
> > > +	 * landlock_rule nodes with socket type, described by (domain, type)
> > > +	 * pair (see socket(2)). Once a ruleset is tied to a
> > > +	 * process (i.e. as a domain), this tree is immutable until @usage
> > > +	 * reaches zero.
> > > +	 */
> > > +	struct rb_root root_socket;
> > 
> > The domain is a value between 0 and 45,
> > and the socket type is one of 1, 2, 3, 4, 5, 6, 10.
> > 
> > The bounds of these are defined with AF_MAX (include/linux/socket.h) and
> > SOCK_MAX (include/linux/net.h).
> > 
> > Why don't we just combine these two numbers into an index and create a big bit
> > vector here, like this:
> > 
> >      socket_type_mask_t socket_domains[AF_MAX];
> > 
> > socket_type_mask_t would need to be typedef'd to u16 and ideally have a static
> > check to test that it has more bits than SOCK_MAX.
> > 
> > Then you can look up whether a socket creation is permitted by checking:
> > 
> >      /* assuming appropriate bounds checks */
> >      if (dom->socket_domains[domain] & (1 << type)) { /* permitted */ }
> > 
> > and merging the socket_domains of two domains would be a bitwise-AND.
> > 
> > (We can also cram socket_type_mask_t in a u8 but it would require mapping the
> > existing socket types onto a different number space.)
> > 
> 
> I chose rbtree based on the current storage implementation in fs,net and
> decided to leave the implementation of better variants in a separate
> patch, which should redesign the entire storage system in Landlock
> (e.g. implementation of a hashtable for storing rules by FDs,
> port values) [4].
> 
> Do you think that it is bad idea and more appropriate storage for socket
> rules(e.g. what you suggested) should be implemented by current patch?

Günther's suggestion would be a good optimization, but I agree that it
should be part of another series.  We also need to keep in mind that the
layer level should be known for audit and debugging reasons.

> 
> [4] https://github.com/landlock-lsm/linux/issues/1
> 
> > 
> > As I said before, I am very excited to see this patch.
> > 
> > I think this will unlock a tremendous amount of use cases for many programs,
> > especially for programs that do not use networking at all, which can now lock
> > themselves down to guarantee that with a sandbox.
> > 
> > Thank you very much for looking into it!

Same :)
