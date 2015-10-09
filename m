From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH 0/3] new test suite
Date: Fri, 9 Oct 2015 14:52:32 +0200
Message-ID: <20151009125232.GA4457@salvia>
References: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45138 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbbJIMpj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 08:45:39 -0400
Content-Disposition: inline
In-Reply-To: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 09, 2015 at 02:38:06PM +0200, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> I suggest a testsuite like this, which can test higher level operations,
> so more tests can be performed to the code apart of the regression tests:
>  * listings/filterings
>  * deletions/flushes
>  * monitor operations
>  * ruleset loadings with -f
>  * interactive interface with -i (perhaps)

I started something similar here locally.

We can probably rearrange the directory to something like:

tests
  |
  .--- py
  .--- shell
  .--- files

So under tests/py/ we get the python-based infrastructure, then shell
includes shell scripts for your test cases. The files directory should
contain files that we can load via 'nft -f'.

That should be pretty much covering all paths of the command line
interface.

> In patch 1/3 there is a description of this simple testbed.
> 
> If you like the idea I would be happy to add more tests cases.

I think it's good idea to enhance the test infrastructure to catch
regressions on as many fronts as possible.
