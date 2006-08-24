From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 13:22:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608241310380.8098@blackhole.kfki.hu>
References: <200608142312.41851.max@nucleus.it> <44EBE13E.9020605@trash.net>
	<Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
	<200608241258.58098.max@nucleus.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200608241258.58098.max@nucleus.it>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Aug 2006, Massimiliano Hofer wrote:

> > # Handle two versions of the same module:
> > -m foo --foo-version 2 <flags 2> --OR --foo-version 1 <flags 1>
> > # Handle new or possibly missing module
> > -m bar --bar-version 1 <flags 1> --OR --false|true|fatal-error|ignore-rule
> >
> > Interesting question is how to handle such rules in the kernel, taking
> > into account that we want the 'SAVE' operation to work correctly.
>
> This could be a userspace problem. The kernel could disclose what matches are
> registered (given that the corresponding module is loaded) and what versions
> are supported.
> Choosing different paths based on some fixed parameter like the current
> version isn't something we should do for every packet in transit.

I completely agree with your last sentence. But what I wanted to say is
that when one issues such commands and then enters 'pkttables/nf --save'
to get the actual ruleset from the kernel, one expects the exactly same
rule returned, without missing parts. Even if the kernel cannot interpret
and thus ignores some parts of the command at packet matching.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
