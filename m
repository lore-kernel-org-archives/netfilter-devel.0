From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 1/5] secmark: do not return early if there was no error
Date: Tue, 12 Oct 2010 19:50:24 -0400
Message-ID: <1286927424.2614.15.camel@localhost.localdomain>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.2.00.1010131038160.2949@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, paul.moore@hp.com,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1010131038160.2949@tundra.namei.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2010-10-13 at 10:38 +1100, James Morris wrote:
> On Tue, 12 Oct 2010, Eric Paris wrote:
> 
> > Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
> > netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
> > on 0 (aka no error) early and didn't finish setting up secmark.  This results
> > in a kernel BUG if you use SECMARK.
> > 
> 
> Does this need to go into current Linus?

It's been broken since v2.6.35-rc1 so it's not exactly new, but yes,
it's broken and will bug like this in current Linus.

-Eric

