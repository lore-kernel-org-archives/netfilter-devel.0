From: "Carlos Fernandez Sanz" <cfs-netfilter@nisupu.com>
Subject: Re: MSN helper module
Date: Tue, 17 Dec 2002 10:51:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006401c2a5b1$eb9d6370$152ea8c0@maincomp>
References: <006d01c2a55e$e7a08200$152ea8c0@maincomp> <20021217075448.GA24766@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick Schaaf" <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick,

MSN is (other than a ISP), an instant messaging service like ICQ.
Unfortunately, one of the most used these days (because it's the Microsoft
supported one). The helper module would have to do the same thing the other
modules do - keep track of children connection, rewrite some packets to
change IPs, etc.

Carlos.

----- Original Message -----
From: "Patrick Schaaf" <bof@bof.de>
To: "Carlos Fernandez Sanz" <cfs-netfilter@nisupu.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, December 17, 2002 08:54
Subject: Re: MSN helper module


> On Tue, Dec 17, 2002 at 12:57:35AM +0100, Carlos Fernandez Sanz wrote:
> >
> > Is there a helper module for MSN? If not, is it being developed and can
I
> > join the effort?
> >
> > If nothing is being done I'll just write the module myself before not
having
> > full MSN support becomes a serious issue and starts going up...
>
> Ahem - what would such a helper module have to do? As far as I know,
> MSN is an Internet Service Provider, and there is no network protocol
> called MSN. Did that change? Do they do the AOL, 10 years later?
>
> I sure hope so, it would be their final death.
>
> Sorry for off-topic; my first question, above, is what should be
discussed.
>
> best regards
>   Patrick
>
