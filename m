From: Mikado <mikado4vn@gmail.com>
Subject: Re: Conntrack + Connection owner
Date: Tue, 20 Dec 2005 09:49:38 +0700
Message-ID: <43A77142.3040805@gmail.com>
References: <1b8130000512182054y7208121dtb6b20814540bbb3b@mail.gmail.com>
	<43A6EA58.9090201@eurodev.net> <43A6EC1F.7030600@eurodev.net>
Reply-To: mikado4vn@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43A6EC1F.7030600@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Oh yes, I want the process ID that owns the connection included in the
event information. Is there another way to do this (maybe not using
conntrack, but it must be programable)

I also need libnfnetlink + libnetfilter_conntrack documents/API
references/guides/tutorials. If you have one, please send me.

Thank you.

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
> 
>>Mikado 4VN wrote:
>>
>>
>>>Is it possible for conntrack to dump process ID that created the
>>>connection to userpsace (via libnetfilter_conntrack or etc...)? If
>>>there is one, please tell me how!
>>
>>There's something incomplete here: Do you mean to include the ID in the
>>event information or in the conntrack table dumping?
> 
> 
> Oh, now I understand. You mean the process ID that owns the connection,
> don't you? In that case the answer is no.
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDp3FBmS/zF9V69ugRArRMAKCFnaN/3T9KcLUuWJiyMvgYZZiCDACdEhQP
op909blJQNW7lwL19toG+zw=
=uG+P
-----END PGP SIGNATURE-----
