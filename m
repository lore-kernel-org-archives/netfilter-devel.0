From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter on solaris?
Date: Fri, 14 Jun 2002 12:32:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206141216360.17029-100000@blackhole.kfki.hu>
References: <20020614100540.GA6399@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20020614100540.GA6399@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 Jun 2002, Balazs Scheidler wrote:

> It is a strange idea I know, but I'd be interested in what the opinion of
> the core netfilter developers is on porting the whole netfilter subsystem to
> Solaris?

You must have plenty of time. I envy you! :-)

> Apart from the technical issues, would there be any problems? Does the GPL
> allow this kind of usage? (it would be implemented as a module)

If the module is GPLed, then I don't see problems here but I'm not a
layer.

But how do you imagine the porting so that the maintenance would not
become a nightmare?

> Technically, the most difficult tasks are to remove the dependency on Linux
> like sk_buff (Solaris has a chain of mblk_t's), locking (it's more or less
> done using macros), routing differences and I suppose many things I don't
> see right now.

Challenging. But wouldn't it be more straightforward to run Linux on that
SPARC machine? And there are still plenty to do on 32/64bit issues in
netfilter...

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
