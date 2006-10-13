From: Michael Rash <mbr@cipherdyne.org>
Subject: Re: new match extension to implement port knocking in one
Date: Thu, 12 Oct 2006 22:50:34 -0400
Message-ID: <20061013025034.GB12880@minastirith>
References: <cd08d610610111333m4db2ccc3l78dedcc3da060128@mail.gmail.com>
	<Pine.NEB.4.64.0610121956250.24305@otaku.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <Pine.NEB.4.64.0610121956250.24305@otaku.freeshell.org>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Oct 12, 2006, Alexey Toptygin wrote:

> On Wed, 11 Oct 2006, Luis Floreani wrote:
> 
> >>If you're interested in port knocking, you might want to read this
> >>paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
> >>issues relating to port knocking in detail, and presents an architecture
> >>for solving most of them.
> >>
> >>Full disclosure:  I wrote that paper.  Feel free to contact me if you
> >>have questions.
> >>
> >>Rennie deGraaf
> >
> >In our implementation, for security, we are using the Tumbler protocol, we
> >found it simple yet powerful, check it out here:
> >http://tumbler.sourceforge.net/.
> 
> It seems that Tumbler is not capable of working across NAT, unless the 
> client can somehow obtain its public IP address. Also, it relies on clocks 
> being synchronized, since authentication will fail if the UTC time in 
> minutes is not identical on the client and server. Tumbler is not as 
> stealthy as the techniques in Rennie deGraaf's paper, since it uses an 
> open UDP port.

Why not use fwknop in Single Packet Authorization mode?:

http://www.cipherdyne.org/fwknop/

(Disclosure: I wrote it).

Here are some of the highlights (parts of this are related to both the
original poster's question and the Alexey's observation above about the
open UDP port in Tumbler):

 - Support for both asymmetric and symmetric encryption via Rijndael and
   GnuPG.  If GnuPG is used, then fwknop verifies that the data is both
   signed and encrypted.  Any multi-packet port knocking scheme would
   have serious difficulty in using an asymmetric cipher because of the
   generally long key lengths and resulting size of encrypted data.
 - No open ports on the server side; all packet data is monitored via a
   sniffer.  Iptables should be configured in a default-drop stance for
   all protected services and for the port on which the SPA packet is
   sent (UDP 62201 by default, but fwknop also supports sending over
   ICMP and over a blind TCP ACK packet).
 - Automatic reconfiguration of the local iptables policy via the
   IPTables::ChainMgr perl module; this is not as cool as using a
   netlink socket to communicate to a userspace program, but doing the
   knock verification in the kernel itself limits your options for doing
   things like using GnuPG.
 - Because an encrypted payload is used, any access directive can be
   used instead of just a pre-determined set of access directives for
   which the hashes can be worked out as in the Tumbler protocol.  A
   full command channel is also supported by fwknop.
 - SPA packets are non-replayable in both asymmetric and symmetric
   encryption modes due to the fact that 16 bytes of random data is
   included within every packet, and the md5 sum is tracked (and written
   to disk) on the server side.
 - Support for multiple users, each with their own encryption keys and
   authorization rules.
 - Support for a time window over which an SPA packet is accepted (this
   feature can easily be disabled if time synchronization is a problem).
 - Custom patch against openssh, so (after fwknop is run against <host>
   for the first time so it can cache your command line arguments) you
   can just do:

ssh -K "-L <host>" user@host

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
