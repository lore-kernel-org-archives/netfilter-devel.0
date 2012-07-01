From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Mon, 02 Jul 2012 10:58:56 +1200
Message-ID: <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu>
 <4FF02A93.8080603@googlemail.com>
 <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu>
 <4FF04038.4080306@googlemail.com>
 <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
 <4FF04647.7060807@googlemail.com>
 <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu>
 <4FF04DDA.3020609@googlemail.com>
 <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	<netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 02.07.2012 03:21, Jozsef Kadlecsik wrote:
> On Sun, 1 Jul 2012, Mr Dash Four wrote:
>
>> > the manpage, but it's totally counter-intuitive for you. Changing 
>> the
>> > meaning might break working firewalls. Therefore the meaning won't 
>> be
>> > changed.
>> >
>> This isn't simply a question of "meaning" - it is an issue caused by 
>> the
>> fact that you have introduced something which, it seems, wasn't 
>> properly
>> checked initially for whatever reason and that is causing a great 
>> deal
>> of inconsistency and inconvenience for people, like myself, who use
>> ipset on a daily basis.
>
> I have to weight the "great deal of inconsistency and inconvenience"
> caused to you against breaking firewall setups out there. I really
> appreciate your comments, but in this case you should adapt.
>
>> When I match an incoming packet destined to an IP address for 
>> example, I
>> have to use, quite rightly, a "dst" designation, but when I match
>> against the interface to which this same IP address belongs to,
>> according to your man page, I have to use "src" instead - all this,
>> simply because you didn't check this properly when hash:net,iface 
>> was
>> first released and you can't be bothered, for one reason or another, 
>> to
>> change it simply because "this has been out for a long time"?
>>
>> Do you think that all the network admins out there will have to 
>> remember
>> to use "dst" when matching on destination IP addresses, port numbers
>> etc, but use exactly the opposite designation - "src" - when 
>> matching on
>> the same destination interface that same IP address belongs to? Do 
>> you
>> not see how inconvenient and downright misleading this is? If you 
>> can't,
>> you are beyond hope, I am afraid.
>
> Do you think all admins constantly read all changelogs, mailing lists
> about all the software they use to catch backward incompatible 
> changes?
> You are aware of the "inconveniece", and you could adapt yourself to 
> it
> anytime. I'm responsible for every user, for those who never read 
> these
> mailing lists as well.
>
>> Right, I am going to include Patrick in this as this whole saga is 
>> becoming
>> something of a monologue and I need a bit of clarity on this.
>
> Feel free to involve anyone. Just to sum up: in the case of the
> net:hash,iface type of ipset, the manpage says
>
> "The second direction parameter of the set match and SET target 
> modules
> corresponds to the incoming/outgoing interface: src to the incoming 
> one
> (similar to the -i flag of iptables), while dst to the outgoing one
> (similar to the -o flag of iptables)."
>
> You argue that the meaning of src/dst for the interface part is
> counter-intuitieve and therefore must be reversed - regardless of the
> backward compatibility issue and the possible breaking of existing 
> setups.

Jozsef,
  just my 3c on this discussion to see if its any help.

As you say Mr Dash Four brings up a good point about confusion. It 
certainly seems to confuse him/her, and very likely others with less 
documentation reading experience.

IME the practice when this type of thing happens is good to find some 
alternative clear naming for the parameters and to deprecate the old 
ones. That allows the old names to be dropped from documented use, but 
kept supported for existing config with a warning that admin need to 
check the docs for new usage.

For myself, given the man page snippet it is clear what you intended 
src/dst to be the "local" src/dst. But it is inconsistent with iptables 
usages of src/dst and will trip up anyone not reading that page. Which 
is not a good situation to be in.

Having been in that situation myself I sympathize and had this same 
argument about the same scope concept with other developers several 
times now. We usually end up using some form of "local" terminology for 
the box internal details to differentiate from end-to-end scope 
terminology. In this case --iface-ip / --oface-ip would probably be the 
clearest contenders for your selection. But that is up to you.

/3c

HTH
AYJ

