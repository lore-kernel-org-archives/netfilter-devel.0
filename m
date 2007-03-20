From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: [Fwd: Re: bloom filter in netfilter?]
Date: Tue, 20 Mar 2007 17:38:29 +0100
Message-ID: <46000E05.6030204@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

cc list (bis)


Patrick Schaaf wrote:
>>> We can't just get rid of it since bloom filters have false positives, so
>>> it could happen that we could miss some new connections that are not
>>> actually in the conntrack table.
>> That wouldn't be a big problem in my opinion, you can freely tune the
>> probability.
>
> Wouldn't two conntrack entries in the hash for the same tuples be
> catastrophic somewhere? (I have no idea, actually)
>
> The other thing about bloom filters that worries me, having read
> the wikipedia entry, is that you cannot remove elements. Probability
> of false positives thus increases as conntracks are added. And a
> future repetition of exactly the same tuple would certainly be
> a false positive. Tuples repeat pretty fast with things like BGP,
> and a filter regeneration seems to involve shuffling all current
> conntracks into a fresh bloom filter.

In fact, you can delete with counting bloom filters.


Regards,
Sebastien Tandel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGAA4Fw76McB8jGxkRCodmAJ0VCLY2WGJneDjRp4c2G3uiM+wHMACfTKuj
diooKOsjswPHfuPV6NG7dTA=
=4stR
-----END PGP SIGNATURE-----
