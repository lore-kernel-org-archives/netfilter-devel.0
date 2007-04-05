From: Remi Denis-Courmont <rdenis@simphalempin.com>
Subject: Re: sendto failed
Date: Thu, 5 Apr 2007 13:48:00 +0200
Message-ID: <a5e0d66c347aaad688f182fe32748c44@localhost>
References: <00bf01c77777$0865a080$dd2d10ac@synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Manish Jain <manish.jain@globallogic.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <00bf01c77777$0865a080$dd2d10ac@synapse.com>
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


On Thu, 5 Apr 2007 17:09:12 +0530, "Manish Jain" <manish.jain@globallogic=
.com> wrote:=0D
> We have some rate limiting rules on OUTPUT side on our box, so if a dae=
mon=0D
> tries to send message beyond a limit, sendto() starts failing. Can we f=
ind=0D
> out from return value or errno that we had failed because of firewall.=0D
=0D
IIRC, the DROP target will return EACCESS (or maybe it was EPERM?) if it'=
s hit from a=0D
local OUTPUT rule - you can check by yourself anyway. Also IIRC, grsecuri=
ty has some=0D
patch to make the OUTPUT filtering silently fail.=0D
=0D
Regards,=0D
=0D
--=0D
R=C3=A9mi Denis-Courmont=0D
http://www.remlab.net/
