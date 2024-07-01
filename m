Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAF912C550
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 10:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719828979; cv=none; b=T7siXVAxcAqQqpYQ59om1tJUUjFYaE769STHvDM3O3ou7R2PoPXDQoqp9MxuJ4VQfYqpTyROPxmqshfGmUCcLWMD9wsqwoWVAw3XqP+51ddY0dR6KPkDQDxfXJ7CTpoT9RbRBw6RwEjYUtLApJSuP+sMpIPSs3hR5WkCZ3C/q7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719828979; c=relaxed/simple;
	bh=I/MXA0zPPYFlP5xrDxlKqDDGJbfrw5DNI6BjVtOLnOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L8YFidqvKV6h0qLPN4mfzSqFWYVn7GVMA8jWYqxpiImSWf2JVfS80HXm3KdPiibc4lHwTIbk6IrHAJml4V71VVPhQ990tzdCHtGd2Sp6xBqAtOY2zZQUEL+vbcxwaOSUsdIraKgk645V0/M9bQPkr7mNbz9qmo2/CF7ISggf7V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1sDkY4f; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1sDkY4f"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035307b08cso4900592276.3
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2024 03:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719828976; x=1720433776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pCkkNdMqFZerD7tkEN5hmKlVtmGwPcLl/F0vhhBqA38=;
        b=F1sDkY4fk+zmddFNOnveVpmlASdFWwydZ4dCzJVI0FtrRAflMjI3uiHEenM/wilxg1
         LwIlgWogBWZqMMZN/PrB0ieBlAOeBaKn1e5+1CnZfPhOXzwntK1PM6b0tqPSxp+v+I/M
         QrrYFRDomfK00Luol7I1Si80oQ10qnFPzixS6YbYs1gG1rMAmimH2XQqs1y+X8V44iWj
         ujs1DZiy4PAiyFLfDBp234VtSn6QM5pioCZg7zc8gCNVpWwdlAAKxmo1DPlgLqfF2gP4
         K+gArBOdSq8gTa9TcCH8AW42n+qKrKHzdurugOxpsEzyE5dUwxVjvRX+q/IaIS0G39yp
         TFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719828976; x=1720433776;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pCkkNdMqFZerD7tkEN5hmKlVtmGwPcLl/F0vhhBqA38=;
        b=Hzdmx8KLgIv1BoOUcb7qN66IUIt18S3axADFePhfGFRAv3QTDxp1CpElAUIQ4Ry7H/
         nNWgoSmnD/n9eNKFDAWLHYqo3FV1Q2AsRs8fHeWPw/6lJVJFdUFE7HLlr9Ofr8l79W+9
         XgdS9zZH33QpIiuXspqD9ZELKG0X5ZcYI7oWVGL8CDeeN8uVfIKe0wN5rS67Fn44z50L
         Psa/homnxu60BB6QEVh7BXcHWv59/Vn0nA4KDosqansYeY81ahi0MfAvEX3yYORQCE4R
         c/HgUSs3XPm8l5hFIN9pPLUpin870cgfBatSi8TSQU7yF7dyM2aocELuhssEu9qmc1xk
         CsUg==
X-Forwarded-Encrypted: i=1; AJvYcCX2z2lZQuHfzKNacMAkOvKDDwEi5c/C6j2WOnv58rQhdTtZbBLrnxY+p9J3S+MAfZzFXPLMojirOOomVg89AqZalCqzj3xFndQupEyIh/8Q
X-Gm-Message-State: AOJu0Ywf52wUG7MS7cU0sx5dfpFabEc/cW9SCSPtOYJLh9dCACKXao85
	h1+IVQtrDv1haDf3PVPoPMTJ2HvJQqL6SZTQb6BG2bbhNt0IvTMf89H8dozy+LVOK/gYa1x8JeW
	Jsw==
X-Google-Smtp-Source: AGHT+IFx2ZlcrsxTL5ignpx/Ts4gwIEOVRBQC4O84/V6VuPKAUXSoRYNyQSRY4mRcL2/wgSRRTIYKbjvDUM=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:1083:b0:e03:58b1:540e with SMTP id
 3f1490d57ef6-e036eb1ebfemr159669276.4.1719828976531; Mon, 01 Jul 2024
 03:16:16 -0700 (PDT)
Date: Mon, 1 Jul 2024 12:16:13 +0200
In-Reply-To: <b2d1a152-0241-6a3a-1f31-4a1045fff856@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net> <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
 <ZnMr30kSCGME16rO@google.com> <b2d1a152-0241-6a3a-1f31-4a1045fff856@huawei-partners.com>
Message-ID: <ZoKB7bl41ZOiiXmF@google.com>
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Fri, Jun 28, 2024 at 07:51:00PM +0300, Ivanov Mikhail wrote:
> 6/19/2024 10:05 PM, G=C3=BCnther Noack wrote:
> > I agree with Micka=C3=ABl's comment: this seems like an important fix.
> >=20
> > Mostly for completeness: I played with the "socket type" patch set in a=
 "TCP
> > server" example, where *all* possible operations are restricted with La=
ndlock,
> > including the ones from the "socket type" patch set V2 with the little =
fix we
> > discussed.
> >=20
> >   - socket()
> >   - bind()
> >   - enforce a landlock ruleset restricting:
> >     - file system access
> >     - all TCP bind and connect
> >     - socket creation
> >   - listen()
> >   - accept()
> >=20
> > > From the connection handler (which would be the place where an attack=
er can
> > usually provide input), it is now still possible to bind a socket due t=
o this
> > problem.  The steps are:
> >=20
> >    1) connect() on client_fd with AF_UNSPEC to disassociate the client =
FD
> >    2) listen() on the client_fd
> >=20
> > This succeeds and it listens on an ephemeral port.
> >=20
> > The code is at [1], if you are interested.
> >=20
> > [1] https://github.com/gnoack/landlock-examples/blob/main/tcpserver.c
>=20
> Do you mean that this scenario works with patch-fix currently being
> discussed?

I did not mean to say that, no, I mostly wanted to spell out the scenario t=
o
make sure we are on the same page about the goal.

I have tried it out with a kernel that had V2 of the "socket type" patch se=
t
patched in, with the minor fix that we discussed on the "socket type" patch
thread after the initial submission.  On that kernel, I did not have the
patch-fix applied.

The patch-fix should keep the listen() from working, yes, but I have not tr=
ied
it out yet.


> > On Mon, May 13, 2024 at 03:15:50PM +0300, Ivanov Mikhail wrote:
> > > 4/30/2024 4:36 PM, Micka=C3=ABl Sala=C3=BCn wrote:
> > > > On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> > > > > Make hook for socket_listen(). It will check that the socket prot=
ocol is
> > > > > TCP, and if the socket's local port number is 0 (which means,
> > > > > that listen(2) was called without any previous bind(2) call),
> > > > > then listen(2) call will be legitimate only if there is a rule fo=
r bind(2)
> > > > > allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is=
 not
> > > > > supported by the sandbox).
> > > >=20
> > > > Thanks for this patch and sorry for the late full review.  The code=
 is
> > > > good overall.
> > > >=20
> > > > We should either consider this patch as a fix or add a new flag/acc=
ess
> > > > right to Landlock syscalls for compatibility reason.  I think this
> > > > should be a fix.  Calling listen(2) without a previous call to bind=
(2)
> > > > is a corner case that we should properly handle.  The commit messag=
e
> > > > should make that explicit and highlight the goal of the patch: firs=
t
> > > > explain why, and then how.
> > >=20
> > > Yeap, this is fix-patch. I have covered motivation and proposed solut=
ion
> > > in cover letter. Do you have any suggestions on how i can improve thi=
s?
> >=20
> > Without wanting to turn around the direction of this code review now, I=
 am still
> > slightly concerned about the assymetry of this special case being imple=
mented
> > for listen() but not for connect().
> >=20
> > The reason is this: My colleague Mr. B. recently pointed out to me that=
 you can
> > also do a bind() on a socket before a connect(!). The steps are:
> >=20
> > * create socket with socket()
> > * bind() to a local port 9090
> > * connect() to a remote port 8080
> >=20
> > This gives you a connection between ports 9090 and 8080.
> >=20
> > A regular connect() without an explicit bind() is of course the more us=
ual
> > scenario.  In that case, we are also using up ("implicitly binding") on=
e of the
> > ephemeral ports.
> >=20
> > It seems that, with respect to the port binding, listen() and connect()=
 work
> > quite similarly then?  This being considered, maybe it *is* the listen(=
)
> > operation on a port which we should be restricting, and not bind()?
>=20
> Do you mean that ability to restrict auto-binding for connect() should
> also be implemented? This looks like good idea if we want to provide
> full control over port binding. But it's hard for me to come up with an
> idea how it can be implemented: current Landlock API allows to restrict
> only the destination port for connect().

I do not think that restricting auto-binding for connect as part of
LANDLOCK_ACCESS_NET_BIND_TCP would be the correct way.


> I think an independent restriction of auto-binding for bind() and
> listen() is a good approach: API is more clear and Landlock rules do
> not affect each other's behavior. Did I understood your suggestion
> correctly?

I believe you did; After reading a lot of documentation on that subject
recently, let me try to phrase it in yet another way, so that we are on the=
 same
page:

The socket operations do the following things:

 - listen() and connect() make the local port available from the outside.

 - bind(): Userspace processes call bind() to express that they want to use=
 a
   specific local address (IP+port) with the given socket.  With TCP, users=
pace
   may always omit the call to bind().  If omitted, the kernel picks an
   ephemeral port.

So, bind() behaves the same way, whether is is being used with listen() or
connect().  The common way is to use listen() with bind() and connect() wit=
hout
bind(), but the opposite can also be done: listen() without bind() will lis=
ten
on an ephemeral port, and connect() with bind() will use the desired port.

(The Unix Network Programming book remarks that listen() without bind() is =
done
for SunRPC servers, where the separately running portmapper daemon provides=
 a
lookup facility for the running services, and services can therefore be off=
ered
on any port.)

A good description I found in the man pages is this:

From ip(7):

  An ephemeral port is allocated to a socket in the following circumstances=
:

  =E2=80=A2  the port number in a socket address is specified as 0 when cal=
ling bind(2);
  =E2=80=A2  listen(2) is called on a stream socket that was not previously=
 bound;
  =E2=80=A2  connect(2) was called on a socket that was not previously boun=
d;
  =E2=80=A2  sendto(2) is called on a datagram socket that was not previous=
ly bound.

(This section of the ip(7) man page is referenced from connect(2) and liste=
n(2),
in their ERRORS sections.)

So, due to the symmetry of how bind() behaves for both connect() and listen=
(),
my suggestion would be:

 * Keep the LANDLOCK_ACCESS_NET_BIND_TCP implementation as it is.

 * Clarify in LANDLOCK_ACCESS_NET_BIND_TCP that this only makes calls to bi=
nd()
   return errors, but that this does not keep a socket from listening on
   ephemeral ports.

 * Create a new LANDLOCK_ACCESS_NET_LISTEN_TCP access right and restrict
   listen() with that.  Looking at your patch set again, the code in
   hook_socket_listen() should be very similar, but we might want to call
   check_access_socket() with the port number that was previously bound (if
   bind() was called).

Does that sound reasonable?


With the current patch-fix as you sent it on the top of this thread, there =
are
otherwise some confusing aspects to it, such as:

 * connect() is also implicitly using a local ephemeral port, just like
   listen().  But while calls to listen() are checked against
   LANDLOCK_ACCESS_NET_BIND_TCP, calls to connect() are not.

 * listen() can return an error due to LANDLOCK_ACCESS_NET_BIND_TCP,
   even when the userspace program never called bind().

Both of these are potentially puzzling and might be more in-line with BSD s=
ocket
concepts if we did it differently.


> > With some luck, that would then also free us from having to implement t=
he
> > check_tcp_socket_can_listen() logic, which is seemingly emulating logic=
 from
> > elsewhere in the kernel?
>=20
> But check_tcp_socket_can_listen() will be required for
> LANDLOCK_ACCESS_NET_LISTEN_TCP hook anyway. Did I miss smth?

You are right -- my fault, I misread that.

=E2=80=94G=C3=BCnther
