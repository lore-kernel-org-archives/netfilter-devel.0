From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: Re: iptables doubt
Date: Thu, 13 Apr 2006 16:16:27 +0200
Message-ID: <443E5D3B.7000608@info.ucl.ac.be>
References: <443D06A7.1060504@rocsys.com> <443E21C1.9090508@info.ucl.ac.be>
	<443E341F.1080206@rocsys.com> <443E42E6.2010405@info.ucl.ac.be>
	<443E4BAA.3020607@rocsys.com> <443E4F34.10206@info.ucl.ac.be>
	<443E57E6.8080005@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <443E57E6.8080005@rocsys.com>
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

Hi,

varun wrote:
> Hi Sebastien,
> 
>                         Well i do not want to use policy from user space
> because , the very need for me to do this activity is to play around and
> get to understand netfilter iptables.

ok ... that's the point :)

> 
>                          The features i want to implement like that
> priority for policy is that imagine a scenario where user added some
> policies and then for some reason wants one policy to be checked before
> checking others then he would have to add the policy again and delete
> the old policy isint it?

Yes it is correct ... even if this may seem curious I think it is not
the worth to add such a mechanism to netfilter. IMHO, a switch option
'-M' (MOVE) would be sufficient but not with all these unique-id's ... I
fear that with the time this number list would be completely fragmented
and human-unreadable
I don't know wether it had already been discussed on this mailing-list.
IMHO, it is not a strong requirement for iptables/netfilter and this
situation may be handled in a semi-automatic way with a user script
(with the danger, however, of having a race condition with another user
script changing netfilter too).
Of course, if it is another exercise to play with netfilter do it and
have fun ;)

>                          By the thanx for the help man and can you
> suggest me some good mailing list which deal with iptables development
> where newbies like me could get some help. This mailing list does not
> seem to help newbies much.

Unfortunately, I don't know any other mailing list devoted to netfilter. :-/

sta
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEPl07w76McB8jGxkRAi5cAJ0TPTCHg3ENQtf/7OMS8NQvlfqglgCfUkJp
GMvcI8Bety73ooSHNMQM/3I=
=ztZe
-----END PGP SIGNATURE-----
