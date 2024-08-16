Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB814830D;
	Fri, 16 Aug 2024 09:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723802348; cv=none; b=nP2Bjm+XFUycA51NJDiFma8OPNwK93x7pWt4ow+cYeXFXcThEokduWQ2JwnPfthCQcoGgwmocnBVdQ+29po5TqRunqJeKYT5L163tcKAw8J4uF7Djwz264otyeTDha/RaPHZjQkG11iu64NrAGNCMIOMkR9CwfGH/2g8+riznaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723802348; c=relaxed/simple;
	bh=qwNlm8uTabWBcWAKcpFjMkrkArb4FqURXqO1BVFp5qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i14MzTEHjIHikcf0AyzEsFQMi6oqAeSDp6xWzW7gojPd6DVTJ9dCL+LFerTlAaVZTyPlQVPqo8e1CG7EWZhDbUZRKu+0y05aS4FLXvv2y6FkuBPbg738hhgfYr8G3ers9WK+wDKHwmpmh4CMfZDVvbJU3ukOxviFLn7aQgG1ybU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44818 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1setjO-000p5M-EC; Fri, 16 Aug 2024 11:58:52 +0200
Date: Fri, 16 Aug 2024 11:58:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	donald.hunter@redhat.com, mkoutny@suse.cz,
	Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <Zr8i2cwJtTe76h7F@calendula>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
 <3f714aad-43b8-443d-a168-db02cb9453af@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f714aad-43b8-443d-a168-db02cb9453af@kernel.org>
X-Spam-Score: -1.9 (-)

Hi Jiri,

On Fri, Aug 16, 2024 at 11:23:55AM +0200, Jiri Slaby wrote:
> On 18. 04. 24, 12:47, Donald Hunter wrote:
> > The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
> > messages. This is a problem for ynl which wants to receive an ack for
> > every message it sends, not just the commands in between the begin/end
> > messages.
> > 
> > Add processing for ACKs for begin/end messages and provide responses
> > when requested.
> > 
> > I have checked that iproute2, pyroute2 and systemd are unaffected by
> > this change since none of them use NLM_F_ACK for batch begin/end.
> > 
> > Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> > ---
> >   net/netfilter/nfnetlink.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index c9fbe0f707b5..4abf660c7baf 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
> >   	nfnl_unlock(subsys_id);
> > +	if (nlh->nlmsg_flags & NLM_F_ACK)
> 
> I believe a memset() is missing here:
> +               memset(&extack, 0, sizeof(extack));

Indeed, see below.

> > +		nfnl_err_add(&err_list, nlh, 0, &extack);
> > +
> 
> Otherwise:
> > [   36.330875][ T1048] Oops: general protection fault, probably for non-canonical address 0x339e5eab81f1f600: 0000 [#1] PREEMPT SMP NOPTI
> > [   36.334610][ T1048] CPU: 1 PID: 1048 Comm: systemd-network Not tainted 6.10.3-1-default #1 openSUSE Tumbleweed 5d3a202ce24e9b465acfbb908cc2eb4f0547bea7
> > [   36.335330][ T1048] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [   36.335906][ T1048] RIP: 0010:strlen+0x4/0x30
> > [   36.336204][ T1048] Code: f7 75 ec 31 c0 e9 17 e0 25 00 48 89 f8 e9 0f e0 25 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 e9 de
> > [   36.338921][ T1048] RSP: 0018:ffffb023808f3878 EFLAGS: 00010206
> > [   36.339802][ T1048] RAX: 00000000000000c2 RBX: 0000000000000000 RCX: ffff9291ca559620
> > [   36.340735][ T1048] RDX: ffff9291ca559620 RSI: 0000000000000000 RDI: 339e5eab81f1f600
> > [   36.341177][ T1048] RBP: ffff9291ca559620 R08: 0000000000000000 R09: ffff9291ce8a6500
> > [   36.341639][ T1048] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> > [   36.342063][ T1048] R13: ffff9291c1015680 R14: dead000000000100 R15: ffff9291ce8a6500
> > [   36.342517][ T1048] FS:  00007f2ee943d900(0000) GS:ffff92923bd00000(0000) knlGS:0000000000000000
> > [   36.342732][ T1048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   36.342868][ T1048] CR2: 00007f9d4769c000 CR3: 0000000100b82006 CR4: 0000000000370ef0
> > [   36.343044][ T1048] Call Trace:
> > [   36.343329][ T1048]  <TASK>
> > [   36.344518][ T1048]  ? __die_body.cold+0x14/0x24
> > [   36.344831][ T1048]  ? die_addr+0x3c/0x60
> > [   36.345029][ T1048]  ? exc_general_protection+0x1cc/0x3e0
> > [   36.345674][ T1048]  ? asm_exc_general_protection+0x26/0x30
> > [   36.349001][ T1048]  ? strlen+0x4/0x30
> > [   36.349423][ T1048]  ? nf_tables_abort+0x67c/0xee0 [nf_tables c16b4fb993ee603261e060fba374eb60b413741a]
> > [   36.350380][ T1048]  netlink_ack_tlv_len+0x32/0xb0
> > [   36.352876][ T1048]  netlink_ack+0x59/0x280
> > [   36.353269][ T1048]  nfnetlink_rcv_batch+0x60c/0x7e0 [nfnetlink a5ded37673006e964178e189bb08592f3ffd89ce]
> 
> extack->_msg is 0x339e5eab81f1f600 (garbage from stack).
> 
> See:
> https://github.com/systemd/systemd/actions/runs/10282472628/job/28454253577?pr=33958#step:12:30

Fix:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d1a7b382a9d3f0f3e5a80e0be2991c075fa4f618
