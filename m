From: Gael Mauleon <gmauleon@free.fr>
Subject: Re: Why huge timeout btw ?
Date: Tue, 24 Jun 2003 22:03:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1>
References: <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
 <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030624153904.GP2645@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

At 17:39 24/06/2003 +0200, you wrote:
>On Mon, Jun 23, 2003 at 11:48:15PM +0200, Gael Mauleon wrote:
> > I'm just wondering as i realise my conntrack entry regarding tcp had huge
> > timeouts. I saw the patch regarding the tweak of those timeouts but
> > why a 5 day one by default ??
>
>because an ESTABLISHED TCP session that hasn't been closed down by
>either RST or FIN can live _forever_ without any data.
>
>5 days is a trade-off between 'forever' and 'broken applications not
>closing connection correctly'.

Ah ok thanks... But well is there any applicative use or logical use of this ?
I mean commonly session use some sort of keep alive packet or so on
to keep tcp connections alive by themselves, so is there any application
that open a connection without using it for 5 days and that is still need it ?

I agree the tcp connection must be closed volunterly by a RST or
FIN (in normal case), but really does it make sense a 5 days tcp ghost 
connection,
instead of a few hours one for exemple (default value) ??

Well sorry if I disturb you with those kind of dumb question :)


> > Sorry if it had been discuss on this list before but maybe you can refresh
> > my mind :)
>
>There is a list archive...
>
> > Gael.
>
>--
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
