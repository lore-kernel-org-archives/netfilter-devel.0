From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 12:58:57 +0200
Message-ID: <200608241258.58098.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it> <44EBE13E.9020605@trash.net>
	<Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
Content-Disposition: inline
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

On Thursday 24 August 2006 10:50 am, Jozsef Kadlecsik wrote:

> + Match/target versioning support, i.e. be able to specify
> =A0 version-dependent features. That might require OR operation
> =A0 support at some level in one rule:
>
> # Handle two versions of the same module:
> -m foo --foo-version 2 <flags 2> --OR --foo-version 1 <flags 1>
> # Handle new or possibly missing module
> -m bar --bar-version 1 <flags 1> --OR --false|true|fatal-error|ignore-rule
>
> Interesting question is how to handle such rules in the kernel, taking
> into account that we want the 'SAVE' operation to work correctly.

This could be a userspace problem. The kernel could disclose what matches a=
re=20
registered (given that the corresponding module is loaded) and what version=
s=20
are supported.
Choosing different paths based on some fixed parameter like the current=20
version isn't something we should do for every packet in transit.

=2D-=20
Saluti,
   Massimiliano Hofer
        Nucleus
