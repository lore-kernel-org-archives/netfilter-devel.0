From: Gael Mauleon <gmauleon@free.fr>
Subject: Re: Why huge timeout btw ?
Date: Tue, 24 Jun 2003 23:31:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.1.1.0.20030624231830.00b148e0@192.168.0.1>
References: <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1>
 <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
 <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
 <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030624202708.GE2645@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

At 22:27 24/06/2003 +0200, you wrote:
>On Tue, Jun 24, 2003 at 10:03:53PM +0200, Gael Mauleon wrote:
>
>
>because I want to have my SSH session still up and running even if I
>don't type something for a couple of hours? The same goes for my VPN
>tunnel.

Well so am I, a couple of hours that's it...not 5 days....and expecially 
for a SSH
or VPN tunnel :)

I know I can tweak them by myself now, but the default value isn't great imo
for both security and laod control of conntrack.

I'm not a specialist so i may be wrong but for me it means that if i 
connect to my server from
an adsl connection for exemple then crash and reconnect (ok it might not 
make a dif for ssh but for other apps...)
I will probably get another ip from the new connection to my ISP. So 
another one can take the "ghost" tcp connection still in
conntrack for is own use isn't he ?

And the best thing is he have 5 days to exploit it......


> > >> Gael.
>
>--
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
