From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Subject: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system
Date: Wed, 12 Nov 2003 01:36:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009d01c3a8b4$f331e960$06a21851@intranet.dti2.net>
References: <20031110233225.00de7987.davem@redhat.com> <20031111104317.GZ8206@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----- Original Message ----- 
From: "Harald Welte" <laforge@gnumonks.org>
To: "David S. Miller" <davem@redhat.com>
Cc: "Netfilter Development Mailinglist"
<netfilter-devel@lists.netfilter.org>
Sent: Tuesday, November 11, 2003 11:43 AM
Subject: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system


>On Mon, Nov 10, 2003 at 11:32:25PM -0800, David S. Miller wrote:
>> Please have a look, thanks guys.
>
>Thanks, David.  Marcelo forwarded that message to the netfilter
>(non-devel) list, see my reply attached.
>
>I've read and change again and again: The change _is_ correct.  Also, it
>is in effect for quite some time, we have it in CVS/patch-o-matic for
>more than two months, and lots of people are using patch-o-matic.
>
>I also cannot reproduce the bug here, I'm running quite a lot of
>post-pre4 systems in such a simple SNAT scenario.


    Mr Welte, I'd spent the last week debugging a problem in one of my
routers and I can now say that this change has something to do with it. I
use a modified 2.4.21 kernel on my routers, it has been running for months
without a glitch. The last week I applied some patches from pom so that I
can use the connmark and several other new match/targets. I test all the
changes in an SMP box and it worked fine, then I installed the kernel on a
production box and it started to hang "randomly", from minutes to hours. It
is not a hard lockup but a livelock, the box doesn't have network neither
userspace but still responds to Alt-SysRq keys. When I saw this bug report I
tried reverting only this one patch and it started to work again, the box
has been up for 4 days now.
    As I said in my development box I was unable to reproduce the lock.

    Best regards,

    -Jorge

==============================================================
Jorge Boncompte - Tecnico de sistemas
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be done.
==============================================================
