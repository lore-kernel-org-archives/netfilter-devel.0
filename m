From: "Samuel Jean" <sjean@cookinglinux.org>
Subject: Re: Working on a match extension (ipt_gateway)
Date: Thu, 15 Jul 2004 09:16:39 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1068.216.239.71.162.1089897399.squirrel@216.239.71.162>
References: <33216.207.236.166.71.1089853555.squirrel@207.236.166.71>
    <Pine.LNX.4.33.0407150844420.32102-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0407150844420.32102-100000@blackhole.kfki.hu>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Jul 2004, Jozsef wrote:
> On Wed, 14 Jul 2004, Samuel Jean wrote:
>
>> I'm working on an extension used to match packets by next-hop ip.
>> It is only valid with FORWARD & POST_ROUTING hooks.
>> It gets the routing decision via (struct rtable*)skb->dst
>> and it works quite well.
>>
>> I just finished on Linux 2.6 and I'm about to do it on 2.4.
>>
>> I've done it after reading that unanswered post :
>> http://lists.netfilter.org/pipermail/netfilter/2004-July/054199.html
>>
>> Please, could someone answer my questions :
>>
>> 1) Is that match useless? (Can this be done without such a match)
>
> Could you give an example in which context can it be useful?
>

Sure, let me take the example given in that unanswered post.

   +-------------+ 200.0.0.0/24       +---------------+ 192.168.2.0/24
   | Router A    | 200.0.1.0/24       | Router B      | 192.168.3.0/24
   +------+------+ 200.0.2.0/24       +--------+------+ 192.168.4.0/24
          |                                    |
    192.168.0.2                          192.168.0.3
          |                                    |
          |                                    |
          +--------------------+---------------+
                               |
                          192.168.0.1
                               | [ETH1]
                        +-------------+
                        | Netfilter   |
                        +------+------+
                               |
                          192.168.5.0/24

 Ok, I know this setup is a little strange, but it could be real.

If packets coming from 192.168.5.0/24 are going to Internet (Router A)
we'd like to MASQUERADE it. But we can't use something like :

iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
because everything going to 192.168.{2,3,4}.0/24 will be NATed too.

Using something like :

iptables -t nat -A POSTROUTING -m gateway --gateway 192.168.0.2 -j MASQUE=
RADE

could be a solution.

MASQUERADE is just a silly example cause I don't know what that person
really wants to do with matched packets. He just mentioned he want to
match packets by next-hop.

Please read (this isn't an order) :
http://lists.netfilter.org/pipermail/netfilter/2004-July/054199.html

And let me know if this setup shall require (or not) the ipt_gateway matc=
h.

>
> Best regards,
> Jozsef

Thanks a lot for you time, Jozsef,

--=20
Samuel Jean
SysAdmin & NetAdmin
at cookinglinux.org
