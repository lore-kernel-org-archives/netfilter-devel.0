From: Klaus Mark <netfilter@0u.dk>
Subject: The question never answered :-)
Date: Wed, 01 Nov 2006 23:01:02 +0100
Message-ID: <4549191E.6050903@0u.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi there!

I don't know if i got it right the first time, i didn't send from the=20
address that mailman/netfilter knows, should you receive this mail=20
twice, then i'm sorry :-)

Let me try to describe what my suggestion/question is. I=92ll just start
my mentioning that I=92m Danish, so I apologies about my lousy English!

I have a system already in production and basically it does double NAT
locally, but I use 2 LINUX servers. If I was able to SNAT in PREROUTING
then I might be able to do this on one box!

I see one problem though, if I SNAT in PREROUTING will I then be able to
NETMAP in PREROUTING too or are we forced to NETMAP in POSTROUTING?

All this is done so the second LINUX server can have tunnels to any
number of overlapping networks, the source being the difference, and
IPSec in 2.6 is satisfied with X number of tunnels to for example
192.168.1.0/24 if the source just differs!

I=92m not routing based on the destination, so it would be ok to DNAT in
POSTROUTING.

I=92ve been looking for a solution to this problem for a long time, and
I=92m wondering why no one has posted a solution to this, the question ha=
s
been asked here before, but you=92ve never posted any solutions!

Regards Klaus
