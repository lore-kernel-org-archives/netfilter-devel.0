From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: how to implement "SYN Proxy firewall"with syn cookies for
 "Preventing syn flood
Date: Fri, 29 Apr 2005 16:52:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504290109430.26003@filer.marasystems.com>
References: <1c65012a05042720021d9eb92e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?GB2312?B?s8LWvrfl?= <aaafeng@gmail.com>
In-Reply-To: <1c65012a05042720021d9eb92e@mail.gmail.com>
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

On Thu, 28 Apr 2005, [GB2312] =B3=C2=D6=BE=B7=E5 wrote:

> recently i want to implement "SYN Proxy firewall"with syn cookies for
> "Preventing
>
> SYN Flood".
>
> but i do not know how to implement it?

The simplest approach would be TPROXY with a good user-space proxy (TPROX=
Y=20
aware), running with SYN-cookies enabled.

If you do not require the original client IP to be preserved during an=20
attack then a good user-space proxy is sufficient, used in conjunction=20
with the standard REDIRECT target.

In both cases a limit match is useful to define a threshold when to start=
=20
proxying.

Regards
Henrik
