From: Wilson Padovani =?ISO-8859-1?Q?J=FAnior?= <admin@netmogi.com.br>
Subject: Re: Problem using REDIRECT and SO_ORIGINAL_DST
Date: Thu, 07 Nov 2002 17:49:26 GMT
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021107.17492673@mis.configured.host>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs Scheidler wrote:
>
> inet_ntoa() uses a static buffer to format its result, you are calling=

> inet_ntoa three times which all work on the same buffer -> the result =
of=20
the
> last invocation will be used three times.
>
> try writing 3 printf() statements, or copy the result of inet_ntoa()=20=

to a
> private buffer, or create your own inet_ntoa() function.
>
> --
> Bazsi
> PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E=20=

C82C 8EB1

Thanks Bazsi.

    I changed the code to use 3 printf() statements, as you said, and=20=

it worked. I was expecting an error on my program, but not something=20=

stupid like that!!

Wilson.
