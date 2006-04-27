From: "David Vogt" <mail@davidvogt.de>
Subject: Re: iptables http problems
Date: Thu, 27 Apr 2006 14:02:53 +0200
Message-ID: <859616420604270502k5c5e0352g4091d821c156f02e@mail.gmail.com>
References: <op.s8nue2ddextast@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Paolo Cerrito" <paolo.cerrito@tin.it>
In-Reply-To: <op.s8nue2ddextast@localhost.localdomain>
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

2006/4/27, Paolo Cerrito <paolo.cerrito@tin.it>:
> Hi, i'm writing a userspace application, using nfnetlink_queue. Can i
> write a rule for iptables that send on a queue http packets? the problem
> is that i have to distinguish the packets for apllication layer protocols=
.
> Is there a way for that?

I am not sure if I understand correctly. Something like this?

$IPTABLES -t mangle -INPUT -p TCP --sport 80 -j NFQUEUE --queue-num 1

David
