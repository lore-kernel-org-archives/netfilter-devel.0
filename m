From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables/libnftables packages for Fedora
Date: Tue, 14 Jan 2014 08:55:33 +0000
Message-ID: <20140114085532.GA23920@macbook.localnet>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <alpine.LSU.2.11.1401130953150.14789@nerf08.vanv.qr>
 <20140113090942.GA14601@macbook.localnet>
 <20140113121836.0d4b1595@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaANIzh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:55:37 -0500
Content-Disposition: inline
In-Reply-To: <20140113121836.0d4b1595@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 12:18:36PM -0700, Kevin Fenzi wrote:
> On Mon, 13 Jan 2014 09:09:43 +0000
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > On Mon, Jan 13, 2014 at 09:54:22AM +0100, Jan Engelhardt wrote:
> > > 
> > > On Sunday 2014-01-12 21:40, Kevin Fenzi wrote:
> > > >
> > > >1. Completely minor, but noted in review of both packages that the
> > > >COPYING file has the old fsf address in it. Would be great if you
> > > >could update to the new one. 
> > > >https://fedoraproject.org/wiki/Common_Rpmlint_issues#incorrect-fsf-address
> > > 
> > > No, best remove the address, because you really don't want to be
> > > updating all the time.
> > 
> > "All the time" seems slightly exagerated. But the "updated" license
> > linked in the wiki is exactly the same version we're using, the
> > address hasn't been changed:
> > 
> > http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
> 
> It has: 
> 
> - Copyright (C) 1989, 1991 Free Software Foundation, Inc.
> -                          675 Mass Ave, Cambridge, MA 02139, USA
> + Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
> + 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> 
> ... and a few other diffs like saying <yeah> instead of 19xx and Lesser
> GNU Public License instead of Library, etc. 

That's what we have (and always had) in nftables:

 Copyright (C) 1989, 1991 Free Software Foundation, Inc.
               51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

> FSF moved buildings a few years ago... as far as I know they don't plan
> to move again, and it's only happened once. The GPLv3 COPYING file I
> note doesn't have any physical address in it. ;) 
> 
> kevin


