From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: iptables as a state machine
Date: Mon, 4 Oct 2004 12:04:53 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0410041008280.16289@blackhole.kfki.hu>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
	<415E6A86.6040707@drugphish.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, shemminger@osdl.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <415E6A86.6040707@drugphish.ch>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2 Oct 2004, Roberto Nibali wrote:

> > Have you looked at nf-hipac.  It works and is fast but is limited
> > to 2.4 right now.  It's on my to do list...
>
> I've started porting it as well, except a few locking issues and some
> Makefile hazzle I should be done with it. I can send it to you in private.
>
> Having seen a lot of packet classification and matching schemes lately
> I'm a bit in favour of the IDD based approach described in [1]. The
> proof of concept implementation, which lacks a big amount of features
> still, can be found at [2]. I probably favour that since I teach Linear
> Algebra at college myself :)

Unfortunately the time to generate the rulesets grows rapidly by the
number of rules and that can cripple cf in practice.

It's definitely not a comprehensive solution, still worth to mention ipset
as an alternative.

There are different kind of sets already supported by ipset:

- ipmap: uses a memory range, where each bit represents one IP address.
  Up to to 65535 (B-class network) IP addresses can be stored. Can store
  network addresses of the same size as well.

- portmap: the same as ipmap, but for port numbers

- macipmap: in a memory range each 8 bytes represents one IP and a MAC
  addresses

- iphash: IP/network addresses stored in a hash where clashes are resolved
  by double hashing and rehashing

Any (set, set-element) can be bound to another set which can then be
matched in iptables by a single match. An example: let's assume we
administer a full A class network (:-) and want to set up the rules for
every server on the network, expressed in sets:

- the ipmap set "toplevel" stores the addresses of our in-use B-class
  networks
- the ipmap sets "b-class-0" ... "b-class-255" stores the IP addresses of
  the servers in the different B-class networks

  We bound every (toplevel, entry) to the corresponding "b-class-n" set.

- portmap sets "service-model-n" contain the ports of the services offered

  We bound the entries in "b-class-n" to the corresponding
  "service-model-n" sets.

Now the single iptables rule

  .. -m set --set toplevel dst,dst,dst -m state --state NEW

will match any new request targeted to any service on any server. The
computation cost of the matching:

- match the destination (network) address in set "toplevel"
- find the binding value corresponding to (toplevel, entry)
- match the destination address in set "b-class-n" we found
- find the binding value corresponding to (b-class-n, entry)
- match the destination port in service-model-n

That is three bitmap and two hash lookups.

Set elements/bindings can be added/deleted fast, save/restore
functionality is supported. One can also swap sets without the need to
modify referring iptables rules or set bindings.

The new version I'm working on it adds the save/restore support, better
iphash type, minimalized syscalls and better binding support compared to
the old version.

It's a pragmatical solution and of course does not address the
rule-handling in iptables itself at all.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
