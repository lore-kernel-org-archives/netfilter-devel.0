From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Syncookie firewall
Date: Fri, 7 Jun 2002 11:56:46 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071156.46926.hno@marasystems.com>
References: <20020606020322.05BF64258@lists.samba.org> <200206061932.04510.hno@marasystems.com> <3D007B24.9010804@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Michel Banguerski <Michel.Banguerski@laposte.net>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3D007B24.9010804@laposte.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Michel Banguerski wrote:

> The timestamp case: I must confess, I'm not sure to fully understand how it
> works, but it seems to me that the important decision to take at SYN packet
> reception is to agree ot not on timestamping. Would it be really
> harmfull if
> the first timestamp is not accurate (if You answer to the timestamp from
> the
> firewall the RTT value calculated by the peer will be shortened be the RTT
> inside your private net with is commonly short)

There is nothing "accurate" about TCP timestamps, but they MUST have the 
property that each new timestamp (per direction) must be >= the previous one, 
and not with a too big difference.

> If we can accept that, then let's just do like for other options: setup
> rules where you accept timestamp for particular hosts and reject
> for the rest.

Nope. What you can do is to

a) Not use it.
b) Make the connection to the real server, having it do all the option 
processing and generating a correct timestamp
c) Use a TCP proxy, terminating the original TCP at the firewall, allowing the 
firewall to do full timestamp processing.
d) Assuming you can hardcode in the ruleset that your server support TCP 
timestamping and it in fact does, Implement a TCP timestamp translation in 
conntrack/nat, having the firewall generate the original timestamp option and 
translate any future server timestamp options (including echo from client) to 
match the startingpoint set by the firewall.. a matter of simply learning the 
offset between the firewall generated timestamp and the SYNACK timestamp 
value from the server and then translate all server timestamps with this 
offset.

> Well, all this works if you protect your inside network from outside
> attacks, but protecting outside from inside is way more difficult
> because you can't gather and keep information about all servers
> that your users will potentially connect to.

And using a TCP proxy works just as good in both directions, and does not need 
to be very inefficient about it.. but is a bit costly in memory requirements 
due to TCP windows and reassembly.. but on the other hand it makes your 
firewall as strict as it's TCP implementation and fully protects servers from 
any kind of TCP abuse (your firewall TCP takes the hit).

Regards
Henrik
