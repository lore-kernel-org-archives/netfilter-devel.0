From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] pom-ng new release
Date: Tue, 4 May 2004 22:38:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405042230350.3961-100000@filer.marasystems.com>
References: <4097B2BA.7000500@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4097B2BA.7000500@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 May 2004, Patrick McHardy wrote:

> >      for my $dep (@{$$patchlet{info}{depends}}) {
> >		$dep =~ s/^!//;
> >      }
> 
> My local Perl guru is surprised, too, but if you really want
> to modify only $dep (why, it's scope is just the loop?)

Well.. it is one of many Perl oddities, but it is well documented, and 
also a great strength of Perl (even if confusing, but a lot is in Perl..)

 Foreach Loops

  [...]

If any element of LIST is an lvalue, you can modify it by modifying VAR
inside the loop.  Conversely, if any element of LIST is NOT an lvalue, any
attempt to modify that element will fail.  In other words, the "foreach"
loop index variable is an implicit alias for each item in the list that
you're looping over.



Or in other words, do not touch the loop variable unless you want to
modify the source elements. If you want to process/filter the value
without modifying the source element then use a "dummy" loop variable and
assign it to a local variable within the loop. This implicit reference is
a very poverful idiom for processing lists of elements, but can be
confusing very confusing when not expected..


Regards
Henrik
