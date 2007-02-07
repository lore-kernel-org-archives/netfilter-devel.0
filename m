From: Andrew Beverley <andy@andybev.com>
Subject: Re: How does iptables 'make' pick which modules to compile?
Date: Wed, 07 Feb 2007 16:13:20 +0000
Message-ID: <1170864800.4250.43.camel@andybev.localdomain>
References: <20070207115459.l45qqpib288cwg0g@www.simplelists.com>
	<45C9F057.4050603@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Blake Covarrubias <blake@ekalb.net>, netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C9F057.4050603@ufomechanic.net>
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

> > I'm trying to get iptables 1.3.7 to compile with kernel 2.6.17.4
> > 
> > Some of the modules are not even attempted to be made, so I was wondering what
> > it is in the make cycle that decides which modules it should try and build?
> > 
> > I get "Making dependencies: please wait...", each module is then compiled but
> > some are missed out. Is this because the make does not think it has all the
> > headers needed to compile them?
> > 
> > I had a similar problem with 1.3.6 and fixed this by adding a KERNEL_DIR
> > environment variable to make; however, this does not seem to help this time.
> > 
> 
> 
> Look for .files (files beginning with a . ) in the extension directory.
> These test files signal that a module can be build, by returning with a
> 0 (normal) exit code.

Brilliant, I see exactly what you mean. The modules are not compiling
because (I guess) my kernel is not patched for those particular ones.

I still have a problem though for which I will start a separate thread.

Thanks,

Andy Beverley
