From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Mon, 10 Nov 2003 16:20:19 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF52E37C7@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <Alistair@nerdnet.ca>,
	"Kishore Dharmavaram" <kishored@servgate.com>,
	<netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ack! (slaps head)

I was a victim of this! I finally have a reason for all those annoying
TCP window error messages! Who knows, I may actually have 'traffic'
through my gateway at this rate.

-----Original Message-----
From: Alistair Tonner [mailto:Alistair@nerdnet.ca]=20
Sent: Monday, November 10, 2003 4:03 PM
To: Kishore Dharmavaram; netfilter@lists.netfilter.org
Cc: 'netfilter-devel@lists.netfilter.org'
Subject: Re: Memory leaks in ip_conntrack?

On November 10, 2003 03:10 pm, Kishore Dharmavaram wrote:

	Kishore:

	what is set in /proc/sys/net/ipv4/tcp_wmem?

	I suspect that what is STOPPing the network is there ..=20
	cat /proc/sys/net/ipv4/tcp_wmem -- on my system the max is ...=20
	!! 131072 !!
=09
	Maybe you've maxed your memory allocation for TCP?
