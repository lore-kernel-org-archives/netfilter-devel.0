From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] pom-ng patchlet to add 'goto' type jumps
Date: Thu, 13 May 2004 13:20:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040513112042.GA3591@alpha.home.local>
References: <40A29BE0.2DF2A0D6@info-link.net> <Pine.LNX.4.44.0405130102100.7624-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Brad Fisher <brad@info-link.net>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405130102100.7624-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 13, 2004 at 01:04:47AM +0200, Henrik Nordstrom wrote:
> > Please let me know if it is/is'nt acceptable for pom inclusion.  I'd
> > like to see it included someday...
> 
> I support this even if I am not using the patch and probably never will..

I'm really happy too, because I haven't found a way to write efficient
rules referencing multiple source, dest and service without something like
this. It will improve rules efficiency a lot in certain circumstances.

Regards,
Willy
