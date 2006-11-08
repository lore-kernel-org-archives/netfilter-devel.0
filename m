From: Carlos Velasco <lkml@newipnet.com>
Subject: Re: [Fwd: Re: Networking messed up, bad checksum, incorrect length]
Date: Wed, 08 Nov 2006 14:17:13 +0100
Message-ID: <4551D8D9.80303@newipnet.com>
References: <454538B3.7020408@newipnet.com>	<Pine.LNX.4.64.0610300856560.6150@blackhole.kfki.hu>
	<Pine.LNX.4.64.0610300919270.6150@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0610300919270.6150@blackhole.kfki.hu>
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

Jozsef Kadlecsik escribi=F3:
> On Mon, 30 Oct 2006, Jozsef Kadlecsik wrote:
>=20
>> On Mon, 30 Oct 2006, Carlos Velasco wrote:
>>
>>> I'm forwarding a mail from Linux Kernel, as it seems a bug in Netfilt=
er
>>> in 2.6.18.
>> The TCP session dies because a NAT device between the communicating=20
>> parties does not adjust the sequence numbers in the SACK fields.
>>
>> Is there a NATing device, which is not identical with the machine runn=
ing=20
>> 2.6.28, between the client and the server?
>=20
> No, it's not a NATing device. It's a 'smart' box which munges the TCP=20
> sequence numbers and misses to do so in the SACK fields: the first pack=
et=20
> from both recordings:

Yes, you are absolutely right. This is not a linux/netfilter issue.

After a little research we saw a Cisco PIX firewall behind the receiver
SMTP server doing ISN randomization.

I contacted Cisco and a bug has been raised for this issue:
Bug number: CSCse14419
http://www.cisco.com/cgi-bin/bugtool/onebug.pl?bugid=3DCSCse14419

As a workaround, ISN randomization can be disabled for TCP connections,
like this:

=3D=3D=3D
access-list WAROUNDTCP extended permit tcp any any

class-map WAROUNDTCP
 match access-list WAROUNDTCP

policy-map global_policy
 class WAROUNDTCP
  set connection random-sequence-number disable
=3D=3D=3D

I thought it's a good thing to post this email for future refence if
this issue comes back again in the future.

Regards,
Carlos Velasco
