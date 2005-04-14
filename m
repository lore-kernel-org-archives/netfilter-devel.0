From: Ben La Monica <ben.lamonica@gmail.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 02:01:04 -0600
Message-ID: <7174b1e40504140101b5138e0@mail.gmail.com>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
Reply-To: Ben La Monica <ben.lamonica@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>, Patrick Schaaf <bof@bof.de>
In-Reply-To: <Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
Content-Disposition: inline
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

On 4/13/05, Henrik Nordstrom <hno@marasystems.com> wrote:
> On Wed, 13 Apr 2005, Patrick Schaaf wrote:
>=20
> > BTW, anybody ever thought about giving -j RETURN an --up N option?

I actually started working on a patch, but then someone mentioned that
it had to be binary compatible with the current iptables. The problem
being that RETURN is a special case. The --up N option is only like 15
lines of code if nobody minds the fact that you'll need to use a newer
version of the iptables binary and newer kernel. Since RETURN is just
an ipt_standard_target like DROP or ACCEPT.

Also, concerning the multiple targets for one match, what about a
module that did something like this:

iptables -I INPUT -p tcp -s 10.0.0.0/24 -j MULTIPLE --mjump ULOG
--ulog-prefix "bad" --mjump REJECT --reject-with tcp-reset

And then the MULTIPLE target would actually create the targets for
ULOG and REJECT, put them in a linked list, execute them in the order
received, and then use the last value to return to iptables with the
verdict.

Anyway, if you have any input regarding this, I can try to write it
this weekend.

-Ben
