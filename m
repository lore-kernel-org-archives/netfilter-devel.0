From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Some one knows how to implement policy routing with iptables?
Date: Fri, 27 Aug 2004 10:07:45 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF591E362@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>, "Robbert" <hanbo163com@163.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Fri, 27 Aug 2004, Robbert wrote:
>=20
>> And I found the rules iptables added are linear,in fact is a link,
>> and no priority at all.Iptables only match them once,if any.So, if I
>> give these rules some priority, or I arrange them by their priority,
>> do you think that means something?
>=20
> iptables is a table of rules, searched top-down. when using iptables
> you have to sort your rules according to your priority. There is no
> automatic sorting of rules by priority and you must manually sort
> them correctly by rule number.
>=20
> the same thing applies when using mark based policy routing, where
> first the iptables rules needs to be correctly sorted then also the
> routing rules (ip rule ...) needs to be sorted.

Very true, the only thing I'd add is that Netfilter itself was never
designed to be a priority based policy tool. TC already does this
component. The advantage of Netfilter is that its a fabulous classifier.
Using Netfilter in conjunction with TC is almost manditory for complex
and special QOS requirements. Check out lartc.org for more information
on QOS and routing.

As for the ROUTE target, I've had mixed results myself. The ROUTE target
a lot easier to setup/understand than the ip route based policy routing,
but it lacks much of the flexibility that the latter offers.
