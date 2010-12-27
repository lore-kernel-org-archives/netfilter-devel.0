From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Mon, 27 Dec 2010 19:20:04 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012271854400.11291@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com>
 <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com>
 <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu> <4D17475B.9000909@googlemail.com>
 <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu> <4D17B730.8040505@googlemail.com> <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki. hu> <4D18BD80.2030807@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D18BD80.2030807@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 27 Dec 2010, Mr Dash Four wrote:

> I learn something new every day. Then it makes even more sense to store the
> protocol as a number, not as string for easier matching - useful if you one
> day decide to apply masking (or other convenient form of searching) against
> the captured protocol (which could also be a number). ;-)

Of course the protocol number is stored and not the string.
 
> > Double check and triple check both the kernel and userspace of ipset 5. Get
> > more feedback, especially from uncommon architecture. Submit for kernel
> > inclusion. After that new features can be added.
> >   
> Fair enough. Any idea when ipset 5.2 will be incorporated into xtables so that
> I could download it and start testing it? *nudges Jan*

You constantly ignore the difference between xtables and xtables-addons...
 
> As it stands, I do not have enough information to build the rpm spec file in
> order to create a complete xtables rpm package to incorporate your version of
> ipset (without this I cannot distribute it across my test machines easily), so
> unless I am able to build this rpm the whole thing is a no go from me.
> 
> > Besides the elements, the different prefixes are also stored in the set. So
> > the test set in the example "knows" that the prefixes 30 and 24 occur only
> > and use only those to find a match, starting from the most speficic prefix
> > to the least one.
> >   
> If I understand you correctly, you keep a separate structure which stores all
> prefixes used in the target set, walk through that structure and for each
> element you build start-end range based on the IP address captured and the
> current prefix. You then create a hash on the calculated start-end range,
> protocol and port triple and then test that hash against the hash value of the
> target set triple (IP range, protocol, port). Is that how you do it?

No, there's no point to store start-end ranges: the network address and 
the prefix is stored, which thus require less memory compared to the 
range.

> I understand that things are a bit easier with hash:ip,protocol,port as you
> don't need to store prefixes - you just calculate the hashes and match them
> against the corresponding hashes of the set triple, right?

Yes, that's it.
 
> > What I referred to was that it's not hard to send forged packets, which
> > create the widest and least filled in (i.e. worst) tree structure. It does
> > not slow down the set but pushes it to the worst memory usage case.
> >   
> Couldn't the same be said for the hash (or any other?) ipsets as well? I am
> not using that 'feature' anyway, as I include the ip addresses/ranges manually
> from script files (though some of them are automatically generated and are
> based on the geoip database which is downloaded at regular intervals), so that
> 'vulnerability' does not apply to me.

No, there's no such weakness in the hash or bitmap types.
 
> > I regard it as a weakness of the type: an attacker must not be able to
> > trigger any worst case situation of a set type intentionally.
> >   
> How is that changed in the hash (or bitmap even) ipsets - would that not be
> the same then: an attacker crafts specifically designed packets to include
> certain ip/port ranges in a set (*a* set - it could be any set)?

The attacker cannot guess the initial parameter of the hash types, so even 
if he/she knew the hash size, cannot figure out what addresses to send in 
order to create clashing entries in the hash. The initial parameter is 
even not saved when saving a set, so if you save a hash type of set, 
destroy and then restore it, the set won't be expressed by the same hash 
structure as the original one because the initial parameter is internal 
and created random.
 
> I think the culprit is not the set itself, but the SET target as I find it
> rather foolish that someone would let an outsider to manipulate a set using
> this SET target. For example, if I am an attacker and I know that the target
> machine relies on access to certain IP address, then I could craft a packet in
> such a way that it triggers this SET target which then includes the IP
> address/range in the 'attackers' set and therefore disable access to that
> address on the target machine - job done!

Of course, it's absolutely possible. However in order to slow down for 
example ssh scanning, even short time blocking of the addresses from 
which scanning is detected can be quite useful.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
