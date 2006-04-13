From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: Re: iptables doubt
Date: Thu, 13 Apr 2006 18:57:20 +0200
Message-ID: <443E82F0.5020102@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
Hash: SHA1

Sven-Haegar Koch wrote:
> On Thu, 13 Apr 2006, varun wrote:
>
>>                         The features i want to implement like that
>> priority for policy is that imagine a scenario where user added some
>> policies and then for some reason wants one policy to be checked
>> before checking others then he would have to add the policy again and
>> delete the old policy isint it?
>
>
> Every iptables rule change is loading the whole ruleset into userspace,
> modifying it, and copying the result back into kernelspace.
>
> So you should be able to fetch the rules (f.e. with iptables-save),
> modify them as you like, and push them back (iptables-restore).
>
> c'ya
> sven
>

which is not robust when competing with another user script doing some
change to netfilter ... i.e. there is no function doing an atomic move.

sta
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEPoLww76McB8jGxkRAs7AAJ9ICzjiB1J/V82UIOsqyKT9AyeGMQCgjiMd
Maq9ku/nKaaXv81wdGd+zU8=
=2j+D
-----END PGP SIGNATURE-----
