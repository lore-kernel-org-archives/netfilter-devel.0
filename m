From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables/libnftables packages for Fedora
Date: Wed, 15 Jan 2014 10:53:30 +0100
Message-ID: <20140115095330.GA4855@localhost>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
 <20140112171116.46eaf896@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaAOJxk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:53:40 -0500
Content-Disposition: inline
In-Reply-To: <20140112171116.46eaf896@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sun, Jan 12, 2014 at 05:11:16PM -0700, Kevin Fenzi wrote:
> [ re-sending as I forgot to cc the list ] 
> 
> On Sun, 12 Jan 2014 22:16:35 +0100
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> 
> ...snip...
>  
> > There is a patch from me to address this:
> > http://patchwork.ozlabs.org/patch/304866/
> > Feel free to test it and comment.
> > 
> > I have the same issue in the Debian land. I applied the patch locally
> > in the package as a workaround.
> > 
> > The patch is not applied yet to upstream.
> 
> Cool. 
> 
> That addresses the part of the issue where the interpreter isn't fully
> specified, but still the question is if these are config files that
> users are expected to modify or are noarch scripts provided by the
> package that are expected to be read-only (ie, /etc vs /usr/share)?
> 
> > > 6. I recently enabled the xml stuff in libnftables and am seeing a
> > > number of tests fail:
> > >
> > > parsing xmlfiles/55-rule-real.xml:  [31mFAILED [0m (Invalid
> > > argument) and
> > > parsing xmlfiles/74-set.xml:  [31mFAILED [0m (Invalid argument)
> > > mxml: <!-- nft add rule filter output ct secmark 0 counter -->
> > > cannot be a second root node after <nftables>
> > >
> > 
> > I can't see the libmxml version in the build log. Which version of
> > libmxml are you using?
> > Seem that your version of libmxml treats XML comments different than
> > in my version (libmxml 2.6 from Debian).
> 
> 2.7 here. ;) So, likely that changed between 2.6 and 2.7?

@Arturo: please investigate this issue as the first release is coming
soon, otherwise we'll have to restrict xml support to one of the
libmxml versions. I think it would be better if libnftables supports
latest version of libmxml as it's the natural move on most
distributions to pack the last software version. Moreover, it would be
good to contact the author to know if he has plans to keep a stable
API/ABI in upcoming releases of libmxml, this is very important for
third party software.
