From: Patrick Schaaf <bof@bof.de>
Subject: Re: Why huge timeout btw ?
Date: Wed, 25 Jun 2003 08:21:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030625062124.GB8673@oknodo.bof.de>
References: <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1> <5.2.1.1.0.20030623234428.00b14690@192.168.0.1> <5.2.1.1.0.20030623234428.00b14690@192.168.0.1> <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1> <5.2.1.1.0.20030624231830.00b148e0@192.168.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gael Mauleon <gmauleon@free.fr>
Content-Disposition: inline
In-Reply-To: <5.2.1.1.0.20030624231830.00b148e0@192.168.0.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >because I want to have my SSH session still up and running even if I
> >don't type something for a couple of hours? The same goes for my VPN
> >tunnel.
> 
> Well so am I, a couple of hours that's it...not 5 days....and expecially 
> for a SSH or VPN tunnel :)

For me, it _is_ days, _and_ I don't want to use ssh keepalives, because
those are too short-timed; the ssh sessions should ALSO survive network
outages of hours, in my opinion, without breaking.

> I know I can tweak them by myself now, but the default value isn't great imo
> for both security and laod control of conntrack.

That's your opinion. Everybody has a different one. As Harald wrote,
5 days is the traditional compromise between infinite and soon.

As you note, you can tweak the timeouts; those who cared, could do that
for the whole lifetime of the conntrack code, even if only by changing
the values in the source code (which is trivial, open source rules).

Almost all users of iptables live with this timeout, changing it
will be a surprise for some of them.

> I'm not a specialist so i may be wrong but for me it means that if i 
> connect to my server from an adsl connection for exemple then crash
> and reconnect (ok it might not make a dif for ssh but for other apps...)
> I will probably get another ip from the new connection to my ISP. So 
> another one can take the "ghost" tcp connection still in conntrack
> for is own use isn't he ?

Yes. Too bad. Dialup with dynamic IP addresses sucks, securitywise.
Better use ssh, or other encryption for all data, and that problem
is solved, along with numerous others. Or, better, don't use dynamic
IPs at all, and restrict access to a small set of static IPs, always.
You'll be much better off when the next ssh exploit comes along.

Please end this discussion NOW. It has been held numerous times,
and we were NEVER convinced to do a change. You did not mention
anything that wasn't mentioned numerous times in past discussions.
I have not written anything we didn't mention in reply, before.

I wouldn't have contributed, and won't do it again, but I thought
Harald shouldn't stand out as the sole defender of the truth.

We have a concensus, and you will not change it.

Got it?

regards
  Patrick
