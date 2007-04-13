From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20 support for other 'features'
Date: Fri, 13 Apr 2007 06:22:29 +0200
Message-ID: <461F0585.9030103@trash.net>
References: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>	
	<461D2033.2030508@trash.net>	
	<e6af3bc80704111114lea2aafdg281b8599b2d34996@mail.gmail.com>	
	<461D2748.4050000@trash.net>
	<e6af3bc80704121549g44dfb1bct8a8a735a2d6dc67f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Mohammad Mohsenzadeh <mmohsenz@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <e6af3bc80704121549g44dfb1bct8a8a735a2d6dc67f@mail.gmail.com>
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

Mohammad Mohsenzadeh wrote:
> On 4/11/07, Patrick McHardy <kaber@trash.net> wrote:
> 
>> And how would it do that for two external modules, that don't know
>> how large the last part is?
>>
> 
> That's absolutely correct. How about having only one slab cache and a
> dynamic list of features. Whenever a new feature is registered or an
> old one is removed, we can reallocate slab cache with a new size. I'm
> not sure if that would work for sure, just throwing some ideas out
> there. Something like
> 
> [...]
> One problem that I can see with this is that we have flush all our
> conntracks so we can call     kmem_cache_destroy and then recreate the
> slab with new size. Would this be alright since it would only happen
> on registering and unregistering features since it doesn't happen
> often.


No, I don't like that, besides a single slab cache would force us to
waste space by always allocating the maximum size even if not needed
for a specific conntrack (helpers for example are rare). Rusty had a
better idea, search the archives for ct_extend.
