From: "Brian Long" <brian.long3@mail.dcu.ie>
Subject: Pointers for writing packet mangling modules
Date: Wed, 2 Nov 2005 17:38:10 -0000
Message-ID: <11246.2490018972$1131022503@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: 
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

Hi,

I have been experimenting with a module for altering the destination IP
address for all packets on a given port at the PRE_ROUTING stage =
(don=92t
worry - I know this is something easily done with IPTables).=A0 =
Unfortunately,
any examples/tutorials dealing with writing modules that use Netfilter
always fall short of describing the necessary steps to take when =
altering
the skbuff.

Are the following steps necessary (judging from the NAT source code)?

Calling skb_ip_make_writable
Recalculating ip checksum
Calling dst_release

What else am I missing?

Thanks,

Brian
