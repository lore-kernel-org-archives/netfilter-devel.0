From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Fix the condition extension for 2.6.16 kernels
Date: Fri, 31 Mar 2006 04:09:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603310401430.23448@bizon.gios.gov.pl>
References: <200603302351.27713.max@nucleus.it>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1130639244-1143770988=:23448"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200603302351.27713.max@nucleus.it>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1130639244-1143770988=:23448
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 30 Mar 2006, Massimiliano Hofer wrote:

> Hi,
Hi,

> this is my first contribution to this project, so I suggest you to test i=
t
> before accepting my code.

I think you should create a linux-2.6 directory as this modification=20
prevents this extension from being usable in 2.4 kernels.

> Anyway I did a really simple fix for the condition extension for 2.6.16
> kernels.

BTW: Does it work or only compiles? ;) I remember some mails about porting=
=20
condition to 2.6 raporting kernel crashes when accessing the proc=20
interface.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1130639244-1143770988=:23448--
