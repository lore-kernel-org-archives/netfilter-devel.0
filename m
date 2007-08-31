From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Sharing information for many rules using same module
Date: Fri, 31 Aug 2007 11:39:22 +0100
Message-ID: <46D7EFDA.8080202@ufomechanic.net>
References: <6ed0182d.25662f4f.46cafca9.d1786@o2.pl>
	<Pine.LNX.4.64.0708211713130.5333@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?B?xYF1a2FzeiBTdG9zaWs=?= <litestep@o2.pl>,
	netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708211713130.5333@fbirervta.pbzchgretzou.qr>
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

* Jan Engelhardt wrote, On 21/08/07 16:15:
> On Aug 21 2007 16:54, =C5=81ukasz Stosik wrote:
>=20
>> I am working on simple netfilter match extension. It takes packet,
>> analyzes it, and puts all info in structure. Then it looks at fields
>> in matchinfo and decides if there is a match or not.
>=20
>> The problem is there will be probably many rules, and each time
>> module will repeat the first part of process- where it would be
>> enought to use same structure as in first rule. Is there any way to
>> share info between rules?
>=20
> Use a global variable (hash, linked list, whatever) in
> xt_yourmatch.c.

Unless the information is specific to the packet (skb) or flow
(conntrack) in which case you could consider extending the skb or
conntrack structs so you can store that information there.

Jan's answer is a neccessity if you are correlating information over
multiple flows, and is perhaps a good idea anyway to avoid conntrack/skb
bloat at the expense of some efficiency.

However you may want to look at the new ct_extend which could help here.

>> I would also like to know if netfilter is processing packetss in
>> pararell - or maybe i can be sure that until packet gets dropped or
>> reaches NIC driver, netfilter wont start to process another one -
>> that would solve my problem as i could simply keep that info inside
>> matching module.
>=20
> You have to assume that it does things in parallel, and hence need
> proper locking around your global variable.

And possibly also out-of-order in some cases.

Sam
