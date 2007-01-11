From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Patch: add id to libnetfilter_conntrack XML export
Date: Thu, 11 Jan 2007 13:00:07 +0000
Message-ID: <45A634D7.4090101@ufomechanic.net>
References: <200701051427.37273.victor.stinner@inl.fr>	<459E6489.9070307@netfilter.org>	<200701051618.09855.victor.stinner@inl.fr>
	<459ED4E8.1000508@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <459ED4E8.1000508@netfilter.org>
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

* Pablo Neira Ayuso wrote, On 05/01/07 22:44:
> Hi Victor,
>=20
> Victor Stinner wrote:
>> Le Vendredi 5 Janvier 2007 15:45, vous avez =E9crit :
>>> Victor Stinner wrote:
>>>> I heard that connection identifiers may disappear. Is it true? I lik=
e
>>>> unique identifier because it's small (only 32 bits) and easy to
>>>> manipulate. It's hard to identify a connection without such identifi=
er.
>>> Indeed, it's planned to get rid of the id. We resolved that the tuple
>>> src/dst/port-src/port-dst/l3protonum/l4protonum is enough to identify=
 a
>>> conntrack.
>> Hum, what is your motivation to remove identifiers? I will be harder t=
o=20
>> identify a connection: parameters to identify it depends on the layer =
3 and=20
>> layer 4 protocols. (src, dst, port-src, port-dst, l3protonum, l4proton=
um)=20
>> doesn't work with ICMP (arguments type and code) :-/ And what about IP=
v6?=20
>> What about other layer3 protocols?
>=20
> The 'id' is not enough to uniquely identify a flow since it can wrap
> around: in a scenario with long-time flows, this can result in two flow=
s
> with the same 'id'. The 'id' was introduced as a complement for the
> tuple since we weren't sure that the tuple was enough to identify a
> flow. After several discussions [1], we resolved that the tuple was eno=
ugh.


Storing start-time for a conntrack can be very useful, I do it, it's the
kind if thing that is likely to be useful for people who want to collect
conntrack data over netlink.

Start-time combined with the tuple makes a good unique id.

Sam
