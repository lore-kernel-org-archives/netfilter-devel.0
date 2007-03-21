From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: Re: bloom filter in netfilter?
Date: Wed, 21 Mar 2007 13:45:15 +0100
Message-ID: <460128DB.3030109@info.ucl.ac.be>
References: <46000DDF.70509@info.ucl.ac.be> <46003590.9070002@netfilter.org>
	<46005512.9070001@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46005512.9070001@info.ucl.ac.be>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

one must read 2^16 buckets and not 216 ... of course.


Sebastien Tandel wrote:
>>>> That wouldn't be a big problem in my opinion, you can freely tune
>>>> the probability.
>>>>> In the specific case I was speaking about, you don't expect to
>>>>> find anything. Therefore, as Patrick says, if you tune the
>>>>> probability of false positives, you should not expect ones really
>>>>> often. If one occurs, of course, you have to verify it in the
>>>>> list.
>>> But the case in which we don't expect to find anything is the worst
>>> case, eg. someone is generating trash traffic to stress the
>>> conntrack system. So this can be considered as a hardening
>>> technique.
> 
> In the case of the traversal of the two lists in "nf_conntrack_confirm"?
> You're not expecting the race from NAT at every call, do you? Or have I
> missed something in the code?
> 
>>> Anyway, we would need to evaluate the impact of such solution in
>>> terms of memory consumption (probably something from 4KB to 16KB)
>>> and extra CPU cycles due to hashing.
> 
> Yes, of course I do not imagine that it will be very useful for people
> at home with only a few connections at a time.
> 
>>> Of course, previously we would have to get some numbers
>>> to know how bad is currently the worst case.
> 
> Indeed, it would be good.
> 
>>> I have some experimental stuff on bloom filters at my people
>>> netfilter place that I needed for some works here at the university,
>>> it can't be used for any productive purposes but you could use it as
>>> a starting point.
> 
> Why? what are your deceptions about these bloomy things?
> 
> I've looked at your bloom-experiments.tgz. Do you think one sha1 is
> slower than this implementation of hash in your modulo.c? Do you really
> think it will be random?
> One sha1 computation should suffice to compute what you need. The digest
> is of 160 bits. If you want 216 buckets, you may generate 10 bits hash.
> Could the sha1 algorithm from the kernel take advantage of cryptography
> dedicated chipset?
> 
> One another nice property of counting bloom filters is that you have the
> opportunity to perform some kind of "repartition" in your hash table.
> But as Patrick has mentioned earlier, the drawback is the memory
> consumption, if you want to avoid this memory consumption, it will take
> much more CPU cycles.
> 
> 
> 
> Regards,
> Sebastien Tandel
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGASjbw76McB8jGxkRCuMKAJ9cpfePn3/jB5gApIRX5ZXUVdSBlgCeOI4O
7xQUdwQjMfWse1lPG/oKSHs=
=9wZr
-----END PGP SIGNATURE-----
