From: Amin Azex <azez@ufomechanic.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Sat, 16 Jun 2007 13:14:26 +0100
Message-ID: <4673D422.6030604@ufomechanic.net>
References: <200706161052.l5GAqYv25389@server1.secure-linux-server.com>
	<Pine.LNX.4.64.0706161358480.32724@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706161358480.32724@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 16 2007 10:29, Amin Azez wrote:
>   
>> = (b) rules from the distribution (e.g. =/etc/sysconfig/network/ifroutes)
>> =    [lesser a problem]
>>
>> Likewise, scope helped recognize these.
>>     
>
> ip r: (created by)
>
> 10.0.254.1 via 10.0.254.5 dev tun0 (openvpn)
> 10.0.254.5 dev tun0  proto kernel  scope link  src 10.0.254.6 (openvpn)
> 192.168.254.0/24 via 10.0.254.5 dev tun0 (openvpn)
> 192.168.222.0/24 dev eth1  proto kernel  scope link  src 192.168.222.1 (distro)
> 192.168.60.0/22 dev vmnet1  proto kernel  scope link  src 192.168.60.1 (vmware)
> 10.10.96.0/20 dev eth0  proto kernel  scope link  src 10.10.106.161 (distro)
> 169.254.0.0/16 dev eth0  scope link (distro)
> 127.0.0.0/8 dev lo  scope link  (distro)
> default via 10.10.96.1 dev eth0  (distro)
>
> Hm! Not much to save :)
>   
And not much to save it with.
I didn't notice any realm attributes to be saved there :-) either.

(However, my routing has multiple rules and tables. I only use 
iproute-save for quick restore if application of new routes (xml) fails).

>>> What would they care about how it's done?
>>>       
>> They might prefer that anything that made things easier were not available
>> outside of the source CD that we ship with the box. There is no official
>> company policy on this yet, and I prefer it that way.
>>     
>
> One could obtain the CD and then redistribute the GPL components, and we'd
> be where we are now. It does not buy the corp.s anything by limiting
> distribution. 
Well it does.
Users have to buy the product to get _any_ of the advantages.

It also maintains the differential between the products and and 
joe-linux standard distribution, as well as between products and 
competitors linux-based products. It maximizes the value of the company 
and its products.

However, as I say, there is no actual policy on this (yet), hence my 
posts of code.
> In fact, spread it, 
that's what I'm trying to do.
> and let others do the work ^_^.
>   
With any luck I'll be one of those "others", and paid for by my employer.
We'll see...

Sam
