From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: libipt_connbytes.c bug in iptables-1.3.1
Date: Mon, 18 Apr 2005 10:26:27 +0000
Message-ID: <42638B53.7080702@outerspace.dyndns.org>
References: <20050417230927.GA23821@daleka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotrek Kaczmarek <kaczorek@k.daleka.net>
In-Reply-To: <20050417230927.GA23821@daleka.net>
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

Quoting Piotrek Kaczmarek on 2005-04-17 23:09 UTC:

> I've spent couple of hours seaching for a fix for this bug... can you apply the patch below?
>
> +               break;

Thanks a lot! It fixes the problems I experienced as well :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCY4tSxyF48ZTvn+4RAlhjAJ0Q82R0SzUMkSelyJcsnVx0LQAHgQCfR0yw
zX66WF6xvWMEkM4h651cZHg=
=SmTE
-----END PGP SIGNATURE-----
