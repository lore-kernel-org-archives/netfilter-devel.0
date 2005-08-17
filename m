From: "Bala Pitchandi" <bs@utstar.com>
Subject: RE: Segmenation fault in netfilter/iptables code in 2.4.18 upon
	receiving a TFTP broadcast
Date: Tue, 16 Aug 2005 20:02:07 -0400
Message-ID: <00ee01c5a2be$eb4c0180$352310ac@nj.us.utstar.com>
References: <20050816234045.GA4611@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Phil Oester'" <kernel@linuxace.com>
In-Reply-To: <20050816234045.GA4611@linuxace.com>
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

Phil,

Thanks for your response. I kinda knew that this bug has been fixed in =
the
later version of the kernel.

Since the kernel that I am using is a modified version of the 2.4.18 =
kernel,
it would be too much of an hassle for me to update the entire kernel. If =
you
could point me to the version of the kernel where this bug was fixed, I
could just port this fix onto my netfilter/iptables.

Thanks again,
=20
-- Bala
=20

-----Original Message-----
From: Phil Oester [mailto:kernel@linuxace.com]=20
Sent: Tuesday, August 16, 2005 7:41 PM
To: Bala Pitchandi
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Segmenation fault in netfilter/iptables code in 2.4.18 upon
receiving a TFTP broadcast

On Tue, Aug 16, 2005 at 06:45:50PM -0400, Bala Pitchandi wrote:
> Hello,
>=20
> I am using a 2.4.18 TimeSys kernel in a PPC device. Please see the
> attachment for the iptables rules that I have installed in my device.
Newly
> installed Cisco routers send out TFTP broadcasts asking for =
configuration
> files (network-confg, cisconet.cfg etc) to get the hostname to IP =
address
> mapping. Upon receiving such a broadcast there was a SIGSEGV exception
> caused in the kernel. The call backtrace is given below:

Please upgrade to a recent kernel...the bug you are experiencing was
fixed long ago.

Phil
