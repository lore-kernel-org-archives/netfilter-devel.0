From: "Carlos Fernandez Sanz" <cfs-netfilter@nisupu.com>
Subject: Re: MSN helper module
Date: Tue, 17 Dec 2002 19:35:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002801c2a5fb$1eb92660$152ea8c0@maincomp>
References: <200212171647.gBHGkxmD003537@sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>,
	"Michael Richardson" <mcr@sandelman.ottawa.on.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, it needs some support for file tranmission, voice, etc. The protocol
works a lot like FTP when using PORT (active) connections. The initiator
client sends its IP address and a port number for the other end to connect
to. For basic messaging it doesn't need any special NAT support, though -
the reason being that all connections are outgoing and there are no related
children connections.

So it is not a lot of work but it needs to be done. I haven't found anything
about it so I'm assuming no one has started any work, so I'll do it myself.
Anyway it's pretty much a one man job.

----- Original Message -----
From: "Michael Richardson" <mcr@sandelman.ottawa.on.ca>
To: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, December 17, 2002 17:46
Subject: Re: MSN helper module


> -----BEGIN PGP SIGNED MESSAGE-----
>
>
> >>>>> "Patrick" == Patrick Schaaf <bof@bof.de> writes:
>     Patrick> On Tue, Dec 17, 2002 at 12:57:35AM +0100, Carlos Fernandez
Sanz wrote:
>     >>
>     >> Is there a helper module for MSN? If not, is it being developed and
can I
>     >> join the effort?
>     >>
>     >> If nothing is being done I'll just write the module myself before
not having
>     >> full MSN support becomes a serious issue and starts going up...
>
>     Patrick> Ahem - what would such a helper module have to do? As far as
I know,
>     Patrick> MSN is an Internet Service Provider, and there is no network
protocol
>     Patrick> called MSN. Did that change? Do they do the AOL, 10 years
later?
>
>   I don't know, cause I've never been there, but I think that he means the
> MSN instant message protocol. There is even a possibility that this is
just
> IETF IMPP. (Embrace and extend...)
>   I didn't think it needed NAT support.
>
> ]       ON HUMILITY: to err is human. To moo, bovine.           |
firewalls  [
> ]   Michael Richardson, Sandelman Software Works, Ottawa, ON    |net
architect[
> ] mcr@sandelman.ottawa.on.ca http://www.sandelman.ottawa.on.ca/ |device
driver[
> ] panic("Just another Debian GNU/Linux using, kernel hacking, security
guy"); [
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.0.7 (GNU/Linux)
> Comment: Finger me for keys
>
> iQCVAwUBPf9U/YqHRg3pndX9AQE8oAQA6QLDohf/d+Fi86FPQ2ONrk8LiSqgKmwI
> aiG+cL6pmH+R5lihxYBWMEJ/T+2MpMfeopP4Hc/mquzrkOpo6J64J8EmeqlcAm9c
> 7Rn/K/MvLK2VXFSkqzahZ7S2t5QmfeCQPtgp3QePKqy79AszWW+bxracQ9+ES7A6
> BAzsdtHuPhs=
> =v3E+
> -----END PGP SIGNATURE-----
>
