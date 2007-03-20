From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: [Fwd: Re: bloom filter in netfilter?]
Date: Tue, 20 Mar 2007 17:37:51 +0100
Message-ID: <46000DDF.70509@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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

forgot to CC to the list ... :-/


Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>>> I was then wondering if we could not get rid of these two
>>> list_for_each_entry in the __nf_conntrack_confirm by using the bloom
>>> filters.
>>
>> We can't just get rid of it since bloom filters have false positives, so
>> it could happen that we could miss some new connections that are not
>> actually in the conntrack table.
>
>
> That wouldn't be a big problem in my opinion, you can freely tune the
> probability.
>

In the specific case I was speaking about, you don't expect to find
anything. Therefore, as Patrick says, if you tune the probability of
false positives, you should not expect ones really often. If one occurs,
of course, you have to verify it in the list.

Regards,
Sebastien Tandel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGAA3fw76McB8jGxkRCnGjAJ0diPmS3tmxWs/sqymSuSXS1S/aWgCgm/JO
Abrg/mwtbgdUzbnXhqR9GcA=
=LBzy
-----END PGP SIGNATURE-----
