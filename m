From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Orphaned expectations
Date: Tue, 20 Apr 2004 08:14:21 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040420151421.GA3298@linuxace.com>
References: <20040419203744.GA1328@linuxace.com> <Pine.LNX.4.44.0404201250190.4160-100000@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0404201250190.4160-100000@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I don't think any other helper is vulnerable, since it would likely have to 
be a UDP helper for it to generate the expect in advance of conntrack
confirmation.

Phil

On Tue, Apr 20, 2004 at 12:51:38PM +0100, Chris Wilson wrote:
> Hi Phil,
> 
> > https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=131
> 
> Thanks for fixing that one, it's been bugging me for a while! 
> 
> Do you think that any other helpers might be vulnerable to the same 
> problem?
