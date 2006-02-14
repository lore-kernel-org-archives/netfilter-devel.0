From: Allen Francom <aef@prismnet.com>
Subject: Re: New target
Date: Mon, 13 Feb 2006 18:52:19 -0600 (CST)
Message-ID: <20060213185128.A78007@tempest.prismnet.com>
References: <43F0B0F8.6060909@speedy.com.ar>
	<43F0B596.2010808@cpsc.ucalgary.ca>
	<43F0CE59.5040201@speedy.com.ar> <43F128FB.6040009@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
In-Reply-To: <43F128FB.6040009@cpsc.ucalgary.ca>
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



Also,

With IPSec, can you "require" any communication from
a.com to b.com to be encrypted ?

IPTables might be able to enforce a requirement for
encrypted communications.

Just a thought...

FYI
-AEF


On Mon, 13 Feb 2006, Rennie deGraaf wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Gervasio Bernal wrote:
>> Rennie deGraaf wrote:
>>
>>> Gervasio Bernal wrote:
>>>
>>>
>>>>> Hi all!!!
>>>>>
>>>>> I have developed a new target for iptables that encrypts a
>>>>> communication. I would like to send it so that you can see it and prove
>>>>> it. And the possibility that in a future adding it to iptables.
>>>>> Which are the steps to follow?
>>>>> Thanks a lot!
>>>
>>>
>>> Our of curiosity, what advantages does your method have over IPSec?
>>>
>>> Rennie
>>
>>
>> The great advantage is the ease of use. You only need to put 2 iptables
>> rules in each endpoint of communication. One rule for encryption and the
>> other for decryption. IPSec is a little more complicated to configure.
>
> Well, I'd be interested in taking a look at your design.  How about
> posting your design and source somewhere so that we can take a look at it?
>
> Rennie
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iD8DBQFD8Sj7IvU5mZP08HERApcYAJ4pOmVyYQJRdI7fuj2PSgjUjF4C2wCeNwie
> kOW7cV2dIM3st6SQnsM09G8=
> =6K7k
> -----END PGP SIGNATURE-----
>
